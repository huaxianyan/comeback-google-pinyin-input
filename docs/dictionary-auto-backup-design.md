# 用户词典自动导出备份：调研与方案设计

## 1. 目标与边界

目标是在“设置 → 字典 → 用户字典”下增加可配置的自动备份，并且让每一份备份与现有“导出用户字典”产生的文件完全兼容。

计划中的核心设置项：

- 自动备份开关；
- 自动备份位置；
- 自动备份时间间隔；
- 保留的自动备份版本数量；
- 建议额外提供“立即备份”，用于首次授权、验证位置和手动建立检查点。

自动导出备份是现有内部滚动恢复的第二层保护，两者职责不同：

- `主文件/_bak/_tmp`：处理正在保存时进程终止、主文件不可读等即时故障；
- 自动导出的历史文本：提供多个时间点、可由用户查看和复制、可在卸载或设备故障后通过“导入用户字典”恢复。

第一阶段不改变：

- 原生 Trie 格式；
- 词条学习和权重；
- 手动导入/导出的文本格式；
- 联系人词典、快捷词典和可选系统词典；
- 账号同步逻辑；
- 用户输入期间的候选行为。

## 2. 现有导出链路

当前“导出用户字典”不是复制 `user_dict_3_3` 二进制文件，而是通过原生 accessor 枚举词条：

1. `AbstractDictionarySettings` / `ado` 处理字典设置页和导出点击；
2. `awx.startUserDictionaryExport(Uri)` 向全局任务队列 `aib` 提交 `beg`；
3. `beg`（`UserDictExportTaskFactory` 子类）建立两个 engine factory：
   - `bdt`：中文用户词典；
   - `agb`：英文用户词典；
4. `UserDictExportTask.openDictionaries()` 为两者创建 `DictionaryAccessor(USER_DICTIONARY)`；
5. `DictionaryExporter.dump()` 调用 native `exportAllEntries()`；
6. `bea` / `bec` 将 entry 格式化为文本行；
7. `TsvFileWriter` 通过 `ContentResolver.openOutputStream(Uri)` 写入文件。

导出格式为：

- 编码：UTF-16LE；
- 文件开头：UTF-16 BOM；
- header：`# User dictionary for Google Pinyin Input`；
- TSV 字段：词面、count/权重、token/拼音，必要时附加 `tx=`；
- 同一文件依次包含中文和英文用户词典。

当前设备导出的文件已经证明该链路在 Android 16 上可用。现有“导入用户字典”也能通过 `ACTION_GET_CONTENT` 获得 content URI，因此自动备份文件可以直接走原生导入流程恢复。

需要准确区分“导入”和“精确回滚”：`UserDictImportTask` 先 `duplicateDictionary()` 当前词库，再由 `DictionaryImporter.insertOrUpdate()` 写入备份词条，因此现有导入是**合并/更新**，不会自动删除备份时间点之后新增的词条。第一阶段的恢复入口应继续使用“导入用户字典”，并明确文案为“导入备份”；不能宣称它会把词库精确还原到历史快照。若用户先主动清空当前词库再导入，结果才更接近完整恢复。真正原子的 replace/rollback 需要独立设计，不应夹带在自动备份第一版中。

结论：自动备份必须复用 `beg`、`UserDictExportTask`、`DictionaryExporter` 和 `bea`，不自行解析或复制 Trie。

在当前本地 Gboard 反编译样本的 HMM 保存链路、字典设置资源和相关字符串中，没有定位到一个面向用户、可配置目录和保留数量的本地文本自动备份功能。Gboard 的现代实现可用于参考保存串行化，但本功能没有可直接照搬的 Gboard UI/调度方案。因此设计依据应是 Google 拼音现有 exporter、Android 官方 SAF 模型和本项目的低回归原则，而不是猜测 Gboard 私有云端同步行为。

历史 AOSP PinyinIME 代码也把用户词典作为 native 内部文件加载、写回和同步，而没有把原始二进制文件定义为跨版本公共备份格式。这进一步支持“通过词条 exporter 建立可导入文本”，而不是把 Trie 文件直接暴露给用户：

- https://android.googlesource.com/platform/packages/inputmethods/PinyinIME/+/7898d76cc005bbe1c5893a9f57439561e0771cc8/PinyinIME/jni/share/userdict.cpp
- https://android.googlesource.com/platform/packages/inputmethods/PinyinIME/+/7898d76cc005bbe1c5893a9f57439561e0771cc8/PinyinIME/src/com/android/inputmethod/pinyin/PinyinDecoderService.java

## 3. 存储位置方案

### 3.1 不推荐：保存原始文件系统路径

旧手动导出使用类似：

`/storage/emulated/0/GooglePinyinInput/user-dictionary.txt`

并依赖 `WRITE_EXTERNAL_STORAGE` 和 `Uri.fromFile()`。这种做法对当前 target 28 尚可运行，但不适合作为新功能基础：

- 以后提升 target SDK 时会受到 scoped storage 限制；
- 无法稳定表示云盘、可移除存储和 DocumentsProvider 位置；
- 后台写入依赖旧式广泛存储权限；
- 用户输入原始路径容易出错。

### 3.2 推荐：Storage Access Framework 目录 URI

使用 `ACTION_OPEN_DOCUMENT_TREE` 让用户选择目录，并保存 tree URI。

Android 官方文档确认：

- API 21+ 的 `ACTION_OPEN_DOCUMENT_TREE` 可授予所选目录及子目录访问权；
- SAF 不要求传统的全盘存储权限；
- 通过 `takePersistableUriPermission()` 可在重启后继续访问；
- 文档可以通过 `ContentResolver` / `DocumentsContract` 创建、查询和删除；
- 存储可以来自本机、SD 卡或支持相应操作的文档提供程序。

参考：

- https://developer.android.com/training/data-storage/shared/documents-files
- https://developer.android.com/reference/android/provider/DocumentsContract

选择目录时使用：

- `Intent.ACTION_OPEN_DOCUMENT_TREE`；
- `FLAG_GRANT_READ_URI_PERMISSION`；
- `FLAG_GRANT_WRITE_URI_PERMISSION`；
- `FLAG_GRANT_PERSISTABLE_URI_PERMISSION`；
- `FLAG_GRANT_PREFIX_URI_PERMISSION`。

取得结果后：

1. 从 result Intent flags 中截取实际授予的 read/write flags；
2. 调用 `ContentResolver.takePersistableUriPermission()`；
3. 验证目录可查询，并能完成“创建测试文档 → 写入 → rename → 删除”；自动备份的原子发布和版本轮换要求这些能力；
4. 只有验证成功才保存 URI 并启用自动备份；
5. 更换目录时可释放旧 URI 的持久授权。

每次进入设置页时，应同时查询 `ContentResolver.getPersistedUriPermissions()`，确认目标 URI 仍有 write grant；不能只相信 SharedPreferences 中存在 URI 字符串。覆盖升级通常保留授权，卸载后重装则需要用户重新选择目录。备份文件本身位于用户选择的位置，不会随卸载自动删除。

APK 的 minSdk 仍为 17，而 tree picker 从 API 21 才可用。实现必须有 `SDK_INT >= 21` 保护；API 17–20 隐藏或禁用这些新设置，不可因类验证或直接调用新 API 造成旧系统启动回归。

Android 11+ 不允许通过 tree picker 选择内部存储根目录、Download 根目录、`Android/data` 或 `Android/obb`。设置说明应引导用户建立一个普通子目录，例如 `Documents/GooglePinyinBackup`。

### 3.3 URI 与显示名称

SharedPreferences 保存：

- tree URI 字符串；
- 用户选择时查询到的目录显示名称；
- provider authority（仅用于友好摘要和诊断）。

UI 不直接显示很长的 percent-encoded URI。摘要优先显示类似：

`Documents / GooglePinyinBackup`

无法取得友好名称时才回退到 URI。

## 4. 调度方案

### 4.1 不追求精确闹钟

自动备份不需要在某个精确时刻唤醒设备。精确 Alarm 会引入权限、Doze、电量和后续 target SDK 行为问题，不适合词库文本备份。

WorkManager 的周期任务也只是保证“最小间隔”，实际运行时间由系统优化和约束决定。官方文档明确说明周期执行并不精确：

https://developer.android.com/develop/background-work/background-tasks/persistent/getting-started/define-work

当前 APK 没有 WorkManager。为了一个很小的本地导出功能引入整套 AndroidX Worker、初始化 Provider 和新的后台组件，回归面明显大于收益。

### 4.2 推荐：与词库保存周期协同的事件驱动检查

与现有 `SaveDictionaryTask` 协同：PinyinIME 提交中英文正常保存后，再把到期的 exporter 排到同一个默认串行执行链后方。

现有定时保存阈值为 `0xdbba00`，即 14,400,000 ms（4 小时）。因此用户持续使用输入法时，自动备份到期后的延迟通常不超过下一次词库保存机会。

定义“备份间隔”为：

> 两次成功自动备份之间的最小时间。达到间隔后，在下次使用输入法并完成词库保存时执行。

它不是固定时刻的闹钟。这样可以：

- 不新增后台 Service、Receiver、Alarm 或 Job；
- 不在输入法长期未使用时无意义地唤醒设备；
- 原生 engine 已经初始化，导出 accessor 可直接工作；
- 与当前 V41 的保存串行化配合；
- 后续 target SDK 升级时迁移成本较低。

进一步审计后，推荐把触发点放在 Pinyin 专属生命周期，而不是泛化修改 `SaveDictionaryTask`：

- `PinyinIME.a()` 已按“中文 → 英文”调用两次 `launchTaskIfNeeded()`；在这两次调用之后检查是否到期；
- `PinyinIME.h()` 已按“中文 → 英文”调用两次同步 `saveDictionaryNow()`；在这两次调用之后检查是否到期；
- 设置页完成目录授权或点击“立即备份”时执行强制请求。

`launchTaskIfNeeded()` 和导出任务都使用 `AsyncTask.execute()`。先提交的中文、英文保存会在默认串行 executor 中排在后提交的 exporter 前面；`aib` 还会把手动导入、手动导出和自动导出串行排队。这样无需让通用 `SaveDictionaryTask` 识别混淆类 `Lagb`，也不会把 Pinyin 自动备份行为扩散到其他语言框架。

SAF 发布和轮换不能再使用默认 `AsyncTask` 串行 executor，否则慢速云盘 copy 会把后续字典 Task 一起堵住。应使用自动备份 helper 自己的单线程 executor（或专用短生命周期 worker thread）。原生 exporter 完成后，`aib` 可以继续处理其他任务，而发布线程只处理已经关闭的普通 cache 文件。

仍需增加一个共享 dictionary-I/O lock：V41 的 `sSaveLock` 只覆盖保存任务，`saveDictionaryNow()` 可能与已经在后台运行的导出相遇。自动/手动 `UserDictExportTask` 应在打开 accessor、dump 和关闭期间使用同一把 lock，防止生命周期同步保存与导出并发操作 native mutable dictionary。导出文本很小，锁持有时间可控；向慢速 SAF/cloud provider 发布文件则必须在释放该锁后进行。

协调器还需要进程级 `inProgress` 门闩，避免快速显示/隐藏键盘和手动请求重复建立同一时间点的备份。

## 5. 推荐设置界面

放置在现有 `PreferenceCategory`“用户字典”中，位于“导出用户字典”之后：

1. **自动备份用户字典**（CheckBoxPreference）
   - 默认关闭；
   - 摘要显示上次成功时间、尚未备份或最近错误；
   - 没有位置时开启会先启动目录选择；目录授权成功后再真正开启。

2. **备份位置**（Preference）
   - 始终可点击；
   - 使用系统目录选择器；
   - 摘要显示友好目录名称；
   - 更换目录不移动旧目录中的历史备份。

3. **备份频率**（ListPreference）
   - 每天；
   - 每 3 天；
   - 每 7 天；
   - 每 14 天；
   - 每 30 天；
   - 推荐默认：每 7 天。

4. **保留备份版本**（ListPreference）
   - 3、5、10、20、30 份；
   - 推荐默认：10 份；
   - 当前导出约几 KB，容量成本很低；仍设置上限避免长期堆积。

5. **立即备份**（Preference，推荐）
   - 只要已配置位置即可使用，不要求自动开关处于开启；
   - 绕过时间间隔和失败退避；
   - 用于验证目录和建立手动检查点；
   - 摘要可显示最后结果。

恢复入口继续复用列表上方现有的**导入用户字典**，系统文件选择器可直接选择自动备份目录中的 `.txt`。第一阶段不增加一个行为重复的“恢复”按钮；说明中应明确“导入会与当前词库合并，并非精确回滚”。

可以在后续版本增加“删除所有自动备份”。第一阶段不让现有“清除用户字典”自动删除用户选择目录中的历史备份，因为备份本身就是恢复渠道。设置文案应明确：清除当前词库不会自动清除历史导出文件。

## 6. 偏好数据模型

建议使用独立、明确的 key，避免混入旧同步字段：

- `dictionary_auto_backup_enabled`：boolean，默认 false；
- `dictionary_auto_backup_tree_uri`：string；
- `dictionary_auto_backup_tree_label`：string；
- `dictionary_auto_backup_interval_days`：string/int，默认 7；
- `dictionary_auto_backup_retention_count`：string/int，默认 10；
- `dictionary_auto_backup_last_success_time`：long；
- `dictionary_auto_backup_last_attempt_time`：long；
- `dictionary_auto_backup_last_status`：int/string；
- `dictionary_auto_backup_last_document_uri`：string，可选，用于诊断；
- `dictionary_auto_backup_last_sha256`：string，可选，用于完整性诊断；
- `dictionary_auto_backup_consecutive_failures`：int，可选。

读取时强制范围：

- interval：1–365 天；
- retention：1–100；
- 非法值回退默认值。

不要将 `inProgress` 持久化；它是进程内状态。进程死亡后应自然恢复为 false。

## 7. 备份文件命名与轮换

建议文件名：

`google-pinyin-user-dictionary-2026-07-24_13-55-01-123.txt`

规则：

- 固定前缀，避免删除用户的其他文件；
- 包含毫秒，允许短时间内多次“立即备份”；
- 扩展名 `.txt`；
- MIME `text/plain`；
- 文件内容仍为原生 UTF-16LE TSV。

保留策略：

1. 仅在新备份成功后执行轮换；
2. 枚举 tree URI 的直接子文档；
3. 只匹配固定前缀和 `.txt` 后缀；
4. 通过 `DocumentsContract.buildChildDocumentsUriUsingTree()` 查询 `COLUMN_DOCUMENT_ID`、`COLUMN_DISPLAY_NAME`、`COLUMN_LAST_MODIFIED`、`COLUMN_SIZE` 和 `COLUMN_FLAGS`；
5. 用 `DocumentsContract.buildDocumentUriUsingTree()` 构造每个 child URI；
6. 按文件名时间排序，必要时回退 `COLUMN_LAST_MODIFIED`；
7. 保留最新 N 份；
8. 使用 `DocumentsContract.deleteDocument()` 删除超额的最旧文件；
9. 删除失败不把刚完成的备份标记为失败，但记录 cleanup warning；
10. 绝不删除不符合本应用命名规则的文件。

为了避免慢速或离线 DocumentsProvider 长时间占用 dictionary-I/O lock，推荐采用“本地生成、随后发布”：

1. 用 app-private cache 中的唯一临时文件建立 `file://` URI；
2. 把该 URI交给原生 `beg` / `UserDictExportTask`，完整生成 UTF-16LE 文件；
3. exporter 成功并关闭 accessor/stream 后，检查 BOM、完整 header 和至少达到合法空词库文件的最小长度；
4. 释放 dictionary-I/O lock；
5. 在后台创建 SAF `*.partial` 文档并逐字节复制已完成的本地文件；
6. 关闭 provider stream，并核对 copy byte count 与本地长度；
7. 计算并记录本地文件 SHA-256；可选地重新打开 provider 文档做 read-back hash，支持时要求一致；
8. 优先用 `DocumentsContract.renameDocument()` 发布为最终 `.txt`；
9. 记录成功后删除本地 cache，并执行版本轮换。

不同 DocumentsProvider 对 rename 支持不完全一致。第一版不应为了兼容缺少 rename/delete 的 provider 而退回非原子最终写入；目录授权后的能力测试若失败，应提示“该位置不支持安全自动备份，请选择其他位置”。这样最终 `.txt` 只可能由已完整关闭的 `.partial` 原子发布而来，进程中止最多留下可识别、不会参与轮换的 `.partial`。下一次运行删除超过安全年龄（例如 24 小时）的残留 partial；绝不删除当前仍可能由发布线程使用的文件。

该两阶段方案仍然完整复用原生 exporter，只把“导出词条”和“向用户 provider 发布字节”分开。它比直接让 native accessor 等待云盘写入更安全，也避免把无法证明完整的非原子发布文件当成历史版本。

## 8. 任务与线程架构

建议新增两个隔离 helper，而不是继续扩大已经高度混淆的 `AbstractDictionarySettings`：

### 8.1 `DictionaryAutoBackupCompat`

职责：

- 读取偏好；
- 判断是否到期；
- 维护静态 `inProgress`；
- 在 app-private cache 创建唯一临时文件；
- 使用现有 `aib` 队列和任务 key `user_dict_auto_backup`；
- 构造 `beg(context, listener, Uri.fromFile(cacheFile))`；
- exporter 成功后在独立后台阶段通过 `DocumentsContract` 发布到 tree URI；
- 处理成功、失败、重试节流、临时文件清理和版本轮换；
- 更新 last-success / last-attempt / status；
- 不持有 Activity 或设置 Fragment。

`beg` 会继续使用中文 `bdt`、英文 `agb` 和 `bea` 格式，因此自动文件与手动导出同源。

### 8.2 `DictionaryAutoBackupSettingsCompat`

职责：

- 仅服务于 `DictionarySettingsFragment`；
- 绑定新 Preference；
- 发起 `ACTION_OPEN_DOCUMENT_TREE`；
- 处理 Activity result 和持久 URI 授权；
- 更新目录、时间、版本数和状态摘要；
- 触发“立即备份”；
- 不参与实际导出。

建议只给 Pinyin 的 `DictionarySettingsFragment` 增加一个 helper 字段，并在以下生命周期转发：

- `onCreate()`：bind；
- `onActivityResult()`：处理专用 request code，其余交给 superclass；
- `onResume()`：刷新授权和摘要；
- `onDestroy()`：释放 Fragment 引用。

这样不会修改所有继承 `AbstractDictionarySettings` 的语言或设置实现。

## 9. 状态机

### 9.1 普通到期请求

```text
PinyinIME 提交/完成中英文保存路径
  → enabled?
  → tree URI 存在?
  → now - lastSuccess >= interval?
  → 非 inProgress?
  → 失败退避已结束?
  → 记录 lastAttempt，设置 inProgress
  → aib 提交 beg，先导出到 app-private cache
  → exporter 成功后后台发布至 SAF tree URI
  → 发布成功：记录 lastSuccess，清理超额版本
  → 失败：删除 cache/partial/本次目标，记录错误
  → 清除 inProgress
```

### 9.2 首次启用

```text
打开开关但无目录
  → 暂不保存 true
  → ACTION_OPEN_DOCUMENT_TREE
  → 获取并持久化 write grant
  → 验证目录
  → 保存 URI 和 enabled=true
  → 立即备份一次
```

### 9.3 URI 授权失效

```text
SecurityException / FileNotFoundException / provider unavailable
  → 不修改现有词库
  → 不更新 lastSuccess
  → 记录“备份位置不可访问”
  → 保留 enabled=true 以便设置页明确显示故障
  → 普通触发至少退避 1 小时
  → 用户重新选择位置后清除错误并立即重试
```

## 10. 错误与重试策略

推荐普通失败后至少 1 小时再重试，避免每次显示/隐藏键盘都访问失效 provider。手动“立即备份”始终允许绕过退避。

到期计算不要照搬 `Math.abs(now-last)`。推荐规则：`lastSuccess <= 0`、`now < lastSuccess`（用户向后调整时钟）或 `now-lastSuccess >= interval` 时视为到期。时钟回拨最多产生一份额外备份，不会把备份抑制到未来某个不可预测时间。进程内门闩/短期状态可使用 `elapsedRealtime()`；跨重启成功时间仍保存 wall-clock 供 UI 显示。

错误分类建议：

- 未配置位置；
- 持久 URI 权限丢失；
- provider 不支持创建、rename 或删除；
- 打开输出流失败；
- 原生词条导出失败；
- 存储空间不足；
- 版本轮换删除失败；
- 未知 I/O 错误。

自动备份失败不能：

- 阻塞输入法启动；
- 影响 native dictionary 保存；
- 清空或回滚用户词库；
- 弹出打断输入的 Toast/Dialog；
- 在键盘界面持续重试。

错误只记录到偏好和日志，在设置页显示。只有用户点击“立即备份”时可以显示一次明确结果。

## 11. 现有导出器需要的防御性整理

`UserDictExportTask` 当前主要捕获 `IOException`，正常路径会关闭 `TsvFileWriter` 和两个 `DictionaryAccessor`。自动后台使用前建议进行不改变格式的资源安全整理：

- output stream / writer 使用等价的 finally 关闭；
- `openDictionaries()` 部分或全部成功后，无论导出结果如何都关闭已创建 accessor；
- 将 `SaveDictionaryTask.sSaveLock` 改为可被 exporter 安全访问的共享锁，或等价迁移到独立 `DictionaryIoCompat`；锁仅覆盖 accessor/export 阶段；
- 处理 `openOutputStream()` 返回 null；
- 将 `SecurityException`、provider runtime failure 转换为任务失败；
- 不让自动备份异常逃出 AsyncTask 并影响进程。

这项整理同时提高现有手动导出的可靠性，但不能修改字段顺序、编码、header 或 formatter。

## 12. 隐私与安全

用户词典可能包含：

- 姓名和地址；
- 私人短语；
- 工作术语；
- 偶然学习的验证码或其他敏感文本。

自动备份文件是未加密的可读文本。设置页必须明确说明：

- 文件由用户选择的 DocumentsProvider 保存；
- 其他能够访问该目录或云账号的主体可能读取文件；
- 关闭自动备份不会删除已有文件；
- 清除当前用户词典不会自动删除历史备份；
- 可通过系统文件管理器手动删除。

第一阶段不设计自定义加密格式，因为那会破坏与现有导入功能的直接兼容。加密备份可以作为后续独立功能，必须同时设计密钥和恢复流程。

## 13. 不采用的方案

### 直接复制二进制 `user_dict_3_3`

拒绝。它依赖 native Trie 版本、内部状态及中英文分文件，不等价于用户可恢复的导出文件。

### 在应用私有目录保留历史文本

不作为主要方案。应用卸载会删除数据，用户也无法方便复制；与“备份”目的冲突。

### 固定 `/sdcard` 路径

拒绝作为新功能基础。依赖旧权限和 raw path，不利于 target SDK 与 scoped storage 现代化。

### 精确 Alarm

拒绝。没有精确时刻需求，会增加权限、电量和平台行为负担。

### 立即引入 WorkManager

第一阶段拒绝。当前 APK没有该依赖，event-driven 保存检查已经覆盖活跃使用场景。未来完成 SDK/架构现代化后可以重新评估。

## 14. 分阶段实施建议

### Phase A：设置与 SAF 授权

- 添加 Preference、字符串和数组；
- 实现目录选择、persisted URI、摘要和权限失效检测；
- 暂不自动触发，仅完成“立即备份”。

### Phase B：原生导出复用与错误闭环

- 通过 `beg` 导出到 app-private cache，再两阶段发布到 document tree；
- 增加自动 listener、成功/失败状态；
- 让 exporter 与同步保存共享 dictionary-I/O lock；
- 整理 `UserDictExportTask` 资源关闭；
- 验证文件可被现有导入流程恢复。

### Phase C：到期调度与版本轮换

- 在 `PinyinIME.a()` 和 `PinyinIME.h()` 的中英文保存调用之后接入到期检查；
- 实现 interval、inProgress、failure backoff；
- 枚举并保留最新 N 份；
- 清理失败/不完整文档。

分阶段可以先验证 SAF/provider 和导出器，再触碰保存生命周期，降低回归定位成本。

## 15. 验证矩阵

### 设置与授权

1. 首次选择本机 Documents 子目录；
2. 重启设备后仍能写入；
3. 覆盖升级后仍能写入；
4. 更换目录后只在新目录创建文件；
5. 取消目录选择不改变旧配置；
6. 手动撤销 provider 权限后显示明确错误；
7. 选择只读或不支持 create/write/rename/delete 的 provider 时拒绝启用。

### 导出内容

1. 自动备份与同一时刻手动导出的编码/header/字段一致；
2. 同时包含中文和英文用户词典；
3. 空词库也能生成合法文件；
4. 特殊字符、emoji、制表符边界沿用现有 formatter 行为；
5. 自动文件可通过现有导入入口恢复到隔离测试包；
6. 验证导入是 merge/update，并单独验证“先清空后导入”的近似完整恢复；
7. 慢速 provider 发布期间，dictionary-I/O lock 已释放，输入和保存不被云端 I/O 长时间阻塞。

### 调度

1. 未到间隔不备份；
2. 到间隔后下一次保存触发一次；
3. 中文和英文连续保存只产生一份；
4. 快速显示/隐藏键盘不产生重复文件；
5. “立即备份”绕过 interval 和失败退避；
6. 自动开关关闭后不再触发。

### 轮换

1. retention=3 时第四份成功后删除最旧一份；
2. 失败导出不删除任何旧成功版本；
3. 目录中的其他文件绝不删除；
4. 删除旧版本失败时保留新成功版本并记录 warning；
5. 文件时间缺失时仍能按受控文件名排序。

### 故障

1. 写入前进程终止；
2. 写入中进程终止；
3. provider 临时离线；
4. 空间不足；
5. URI 权限失效；
6. exporter 返回 false；
7. 保存任务和手动立即备份接近同时发生；
8. 自动备份失败不影响输入、学习和内部 `_bak` 恢复。

## 16. 预计代码触点与风险

正式实现预计只需要触碰：

- `res/xml/setting_dictionary.xml`：增加 5 个 Preference；
- 新的 values patch：标题、摘要、interval/retention arrays；
- `DictionarySettingsFragment`：helper 字段和少量生命周期转发；
- 新 `DictionaryAutoBackupSettingsCompat`：SAF 与设置交互；
- 新 `DictionaryAutoBackupCompat` 及 listener/publisher worker：到期、cache export、SAF 发布、轮换；
- `PinyinIME.a()` / `PinyinIME.h()`：各一个到期检查 hook；
- `UserDictExportTask` 与 shared lock：资源安全及同步；
- `scripts/apply_patches.py`：严格、可重复地应用上述 patch。

不需要新增 Manifest service/receiver/provider，不需要新增运行时存储权限，也不需要修改 native library。

主要风险按高到低：

1. exporter 与 lifecycle `saveDictionaryNow()` 并发；由 shared lock 解决；
2. DocumentsProvider 能力差异；由授权后的 create/write/rename/delete 实测、两阶段发布和明确拒绝不兼容位置解决；
3. 进程在发布中死亡；由 cache/`.partial` 清理和“发布完成后才记成功”解决；
4. 旧 PreferenceFragment 生命周期和 request code 冲突；由 Pinyin 子类隔离及专用 request code 解决；
5. 误删用户文件；由严格固定前缀、直接子目录范围和成功后轮换解决；
6. 用户把“导入”理解为精确回滚；由 UI 文案和测试明确 merge 语义。

## 17. 推荐结论

推荐采用：

**原生文本导出器 + SAF 持久目录 URI + 保存后到期检查 + 固定前缀版本轮换。**

这是当前代码基础上回归面最小、能跨越未来 scoped storage/target SDK 升级、并且可通过原生导入合并恢复的方案。第一版应先完成“选择目录 + 立即备份 + 原生导入合并”，确认文件和 provider 行为后，再接入自动间隔与版本轮换。
