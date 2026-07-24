# 用户词典本地自动备份：调研与方案设计

## 1. 使用场景

本功能只解决一个问题：

> 用户不小心“清除应用数据”或卸载 Google 拼音后，仍能从设备公共存储中找到此前自动导出的用户词典，并在新安装的应用中使用现有“导入用户字典”功能手动导入。

因此它是**本地自动导出备份**，不是同步系统，也不是自动恢复系统。

明确边界：

- 备份只写入设备本地公共存储或本机可移除存储；
- 不写入 Google Drive、其他云盘或网络服务；
- 不上传任何用户词条；
- 不在新安装后自动搜索备份；
- 不自动导入、自动恢复或自动合并；
- 不把备份位置、配置或历史版本同步到账号；
- 新安装后由用户打开现有“导入用户字典”，手动选择本地备份文件；
- 自动备份本身不需要新增网络权限、Service、Receiver 或账号依赖。

本功能与 V41 内部恢复机制互补：

- `主文件/_bak/_tmp` 位于应用私有数据中，处理保存中断和主文件损坏，但清除应用数据或卸载后会消失；
- 本地自动导出文件位于应用私有目录之外，清除数据或卸载后仍保留，用于新装后的手动导入。

## 2. 现有原生导出链路

当前“导出用户字典”不是复制 `user_dict_3_3` 二进制 Trie，而是枚举原生词条并生成文本：

1. `AbstractDictionarySettings` / `ado` 处理设置页和导出点击；
2. `awx.startUserDictionaryExport(Uri)` 向全局任务队列 `aib` 提交 `beg`；
3. `beg` 建立两个 engine factory：
   - `bdt`：中文用户词典；
   - `agb`：英文用户词典；
4. `UserDictExportTask.openDictionaries()` 为两者创建 `DictionaryAccessor(USER_DICTIONARY)`；
5. `DictionaryExporter.dump()` 调用 native `exportAllEntries()`；
6. `bea` / `bec` 将 entry 格式化为文本行；
7. `TsvFileWriter` 通过 `ContentResolver.openOutputStream(Uri)` 写入文件。

导出格式：

- UTF-16LE；
- 文件开头有 UTF-16 BOM；
- header 为 `# User dictionary for Google Pinyin Input`；
- TSV 字段包含词面、count/权重、token/拼音，必要时附加 `tx=`；
- 同一文件依次包含中文和英文用户词典。

当前设备已经通过原生“导出用户字典”成功导出并解析 339 行词条，证明该 exporter 在 Android 16 上可用。

结论：自动备份必须复用 `beg`、`UserDictExportTask`、`DictionaryExporter` 和 `bea`，不能直接复制私有 Trie，也不能重新实现词条格式。

## 3. 新装后的恢复语义

现有导入入口通过 `ACTION_GET_CONTENT` 选择本地文本文件，随后使用 `UserDictImportTask`：

1. `duplicateDictionary()` 当前用户词典；
2. 解析 TSV；
3. 通过 `DictionaryImporter.insertOrUpdate()` 写入词条；
4. persist 中文和英文用户词典。

因此导入在技术上是 merge/update，不会删除当前已有但备份中没有的词条。

这不影响本功能的主要使用场景：新装应用的用户词典为空，手动导入本地备份后，结果等同于从该备份恢复其中的词条。若在已有词条的安装中导入，则仍按原生行为合并，而不是精确回滚。

第一版不新增“恢复备份”按钮，也不修改 importer；恢复入口继续使用设置页已有的**导入用户字典**。

## 4. 本地存储位置

### 4.1 不使用应用私有目录

`files/`、`no_backup/` 和 `cache/` 会在清除应用数据或卸载时被删除，不能满足本功能目标。

### 4.2 不使用固定 raw `/sdcard` 路径

旧手动导出依赖：

- `Environment.getExternalStorageDirectory()`；
- raw filesystem path；
- `WRITE_EXTERNAL_STORAGE`；
- `Uri.fromFile()`。

这种做法不利于后续 scoped storage 和 target SDK 现代化，也不适合 SD 卡卷标变化。

### 4.3 推荐：SAF 选择设备本地目录

使用 `ACTION_OPEN_DOCUMENT_TREE` 让用户选择一个**设备本地目录**，例如：

- 内部存储 `/Documents/GooglePinyinBackup`；
- SD 卡上的 `GooglePinyinBackup`。

Android 官方 SAF 文档：

- https://developer.android.com/training/data-storage/shared/documents-files
- https://developer.android.com/reference/android/provider/DocumentsContract

选择 Intent：

- `Intent.ACTION_OPEN_DOCUMENT_TREE`；
- 不使用 `Intent.EXTRA_LOCAL_ONLY`：Android 16 DocumentsUI 在 tree 模式下可能因此隐藏或禁用 primary storage 入口；纯本地策略改由返回 URI 的 provider authority 强制校验；
- API 26+ 通过 `DocumentsContract.EXTRA_INITIAL_URI` 默认打开内部存储的 `Documents` 目录，使体验接近现有导入文件选择器；
- `FLAG_GRANT_READ_URI_PERMISSION`；
- `FLAG_GRANT_WRITE_URI_PERMISSION`；
- `FLAG_GRANT_PERSISTABLE_URI_PERMISSION`；
- `FLAG_GRANT_PREFIX_URI_PERMISSION`。

取得结果后：

1. 从 result Intent flags 中截取实际授予的 read/write flags；
2. 调用 `ContentResolver.takePersistableUriPermission()`；
3. 验证 URI 属于本地 DocumentsProvider；Pixel/AOSP 本地共享存储为 `com.android.externalstorage.documents`；
4. 第一版建议只允许经过本项目实测的 `com.android.externalstorage.documents`，它同时覆盖 primary shared storage 和该 provider 暴露的可移除 SD 卡；
5. 若以后支持 OEM 的其他本地 provider，必须按设备实测加入明确 allowlist，不能仅凭显示名称接受任意 authority；
6. 拒绝 Drive、Dropbox 等云端 provider URI；
7. 在所选目录完成一次“创建测试文档 → 写入 → rename → 删除”；
8. 只有全部成功才保存目录并允许启用自动备份。

目录能力要求：

- create；
- write；
- read（校验）；
- rename（发布完整备份）；
- delete（失败清理和版本轮换）。

APK 的 minSdk 仍为 17，而 tree picker 从 API 21 才可用。实现必须有 `SDK_INT >= 21` 保护；API 17–20 隐藏或禁用自动备份设置。

Android 11+ 不允许选择内部存储根目录、Download 根目录、`Android/data` 或 `Android/obb`。应引导用户建立普通子目录，优先建议 `Documents/GooglePinyinBackup`。

### 4.4 清除数据和卸载后的行为

- 备份 `.txt` 位于公共本地目录，不随应用数据一起删除；
- SharedPreferences 中的开关、目录 URI 和时间记录会在清除数据后消失；
- persisted URI permission 会在清除数据/卸载后失效；
- 这不影响用户在新安装中通过系统文件选择器读取备份；
- 若希望新安装继续自动备份，用户需要重新选择本地备份目录并重新打开开关；
- 应用不会自动发现旧目录，也不会自动恢复配置。

## 5. 设置界面

入口放在：

`设置 → 字典 → 用户字典`

位于现有“导出用户字典”之后。

### 5.1 自动备份用户字典

`CheckBoxPreference`：

- `android:persistent="false"`，由 helper 写入独立的本地备份配置文件；
- 默认关闭；
- 未配置目录时打开，先启动本地目录选择器；
- 授权和能力测试成功后才真正保存为开启；
- 摘要显示上次成功时间、尚未备份或最近错误；
- 关闭开关不会删除已有备份文件。

### 5.2 备份位置（仅本地）

普通 `Preference`：

- 始终可点击；
- 摘要显示本地目录友好名称；
- 更换目录不会移动或删除旧目录中的文件；
- 不接受云端 provider。

建议说明：

> 备份保存在设备本地，清除应用数据或卸载后仍会保留。重新安装后请使用“导入用户字典”手动选择备份文件。

### 5.3 备份频率

`ListPreference`：

- `android:persistent="false"`，由 helper 管理；
- 每天；
- 每 3 天；
- 每 7 天；
- 每 14 天；
- 每 30 天；
- 默认每 7 天。

“频率”表示两次成功备份之间的最小间隔，不是固定时刻闹钟。

### 5.4 保留版本

`ListPreference`：

- `android:persistent="false"`，由 helper 管理；
- 3；
- 5；
- 10；
- 20；
- 30；
- 默认 10 份。

### 5.5 立即备份

普通 `Preference`：

- 配置本地目录后即可使用；
- 不要求自动开关开启；
- 绕过时间间隔和失败退避；
- 用于第一次确认目录以及建立手动检查点。

不增加自动恢复、自动同步或启动时扫描备份的设置项。

## 6. 调度方式

### 6.1 不使用 Alarm/Job/WorkManager

本功能不要求准点运行，也不需要应用未使用时唤醒设备。

当前 APK 没有 WorkManager。引入 AndroidX Worker、Manifest 组件或精确 Alarm 会扩大回归面，而且无法改善“词典必须先加载才能导出”的事实。

### 6.2 与现有词库保存周期协同

现有 `SaveDictionaryTask` 保存阈值是 `0xdbba00`，即 4 小时。

推荐触发点：

- `PinyinIME.a()` 已依次提交中文、英文 `launchTaskIfNeeded()`；在两次调用之后检查自动备份是否到期；
- `PinyinIME.h()` 已依次执行中文、英文 `saveDictionaryNow()`；在两次调用之后检查自动备份是否到期；
- 设置页完成首次目录配置后立即执行一次；
- 用户点击“立即备份”时强制执行一次。

中文、英文保存和 `UserDictExportTask` 都通过 `AsyncTask.execute()`，会进入默认串行 executor；`aib` 也会串行处理手动导入、手动导出和自动导出。

自动备份间隔定义：

> 达到最小间隔后，在用户下一次使用输入法并进入正常保存检查时执行。

输入法长期未使用时不产生新备份，这是预期行为。

### 6.3 到期和退避

到期条件：

- `lastSuccess <= 0`；或
- `now < lastSuccess`（系统时钟回拨）；或
- `now - lastSuccess >= interval`。

普通失败后至少退避 1 小时，避免每次显示键盘都重复失败。“立即备份”可绕过退避。

进程级静态 `inProgress` 防止快速显示/隐藏键盘产生重复文件。

## 7. 保存与导出的并发

V41 的 `SaveDictionaryTask.sSaveLock` 只覆盖保存任务。生命周期中的同步 `saveDictionaryNow()` 仍可能与后台 exporter 相遇。

实现自动备份前，应让自动/手动 `UserDictExportTask` 与保存路径共享同一把 dictionary-I/O lock：

```text
shared lock
  → open 中文/英文 DictionaryAccessor
  → dump 到本地 SAF partial 文档
  → close writer
  → close accessor
  → release lock
```

最终校验、rename 和版本轮换在释放 dictionary lock 后执行。

因为只允许设备本地目录，而且当前导出文件很小，锁不会等待网络或云端上传。

实现方式可以是：

- 将 `SaveDictionaryTask.sSaveLock` 改为 exporter 可访问的共享锁；或
- 把锁迁移到独立 `DictionaryIoCompat`。

不修改 native Trie、学习权重或保存格式。

## 8. 文件发布与完整性

### 8.1 文件名

最终文件：

`google-pinyin-user-dictionary-2026-07-24_13-55-01-123.txt`

写入中的文件：

`google-pinyin-user-dictionary-2026-07-24_13-55-01-123.txt.partial`

时间包含毫秒，避免连续“立即备份”重名。

### 8.2 两阶段本地发布

1. 在 tree URI 下以 MIME `text/plain` 创建 `.partial` 文档，确保 rename 后仍能被现有 `ACTION_GET_CONTENT` 的 `text/plain` 过滤器看到；
2. 把 partial URI 直接交给原生 `beg` / `UserDictExportTask`；
3. exporter 写入 UTF-16LE、BOM、header、中文和英文词条；
4. exporter 关闭 writer 和 accessor；
5. 重新读取 partial，验证 BOM、完整 header 和合法空词库的最小长度；
6. 可计算 SHA-256 用于日志和设置页诊断；
7. 调用 `DocumentsContract.renameDocument()` 去掉 `.partial`；
8. rename 成功后才更新 `lastSuccess`；
9. 最后执行版本轮换。

失败规则：

- exporter 返回 false：删除 partial；
- 校验失败：删除 partial；
- rename 失败：删除 partial，不产生正式 `.txt`；
- 进程中止：最多留下 `.partial`；
- 下次配置/备份时清理超过安全年龄（例如 24 小时）的本应用 partial；
- `.partial` 永远不计入有效版本。

仅支持本地且要求 rename 的原因，是保证新装后用户看到的每个正式 `.txt` 都已经完成写入。第一版不提供非原子 fallback。

## 9. 版本轮换

只处理所选目录的直接子文档。

查询：

- `DocumentsContract.buildChildDocumentsUriUsingTree()`；
- `COLUMN_DOCUMENT_ID`；
- `COLUMN_DISPLAY_NAME`；
- `COLUMN_LAST_MODIFIED`；
- `COLUMN_SIZE`；
- `COLUMN_FLAGS`。

规则：

1. 只匹配 `google-pinyin-user-dictionary-*.txt`；
2. 不匹配 `.partial`；
3. 按受控文件名中的时间排序，缺失时回退 `COLUMN_LAST_MODIFIED`；
4. 新文件成功 rename 后才轮换；
5. 保留最新 N 份；
6. 使用 `DocumentsContract.deleteDocument()` 删除超额的最旧版本；
7. 删除失败不把新备份改为失败，但记录 cleanup warning；
8. 绝不删除不符合固定命名规则的文件。

关闭自动备份、清除当前用户词典、清除应用数据或卸载应用，都不主动删除公共目录中的历史备份。用户可通过系统文件管理器自行删除。

## 10. 偏好数据与“不得自动恢复配置”

当前 Manifest 使用自定义 `com.google.android.apps.inputmethod.libs.framework.core.BackupAgent`。其 `onCreate()` 只把默认的 `<package>_preferences` 注册给 `SharedPreferencesBackupHelper`，意味着写入默认偏好的新 key 可能被 Android 系统备份并在重装后自动恢复。

本功能明确不需要自动恢复或同步，因此**不能**把自动备份开关和 tree URI 写入默认 SharedPreferences。应使用单独文件，例如：

`dictionary_local_backup_preferences`

该文件不注册到现有 `BackupAgent`：

- 不进入现有 Android preference backup；
- 清除数据或卸载后配置消失；
- 重装后开关保持默认关闭；
- 不会恢复一个已经失去 URI grant 的旧 tree URI；
- 公共本地 `.txt` 文件仍然保留，用户可手动导入。

XML 中相关 Preference 全部设为 `android:persistent="false"`，由 `DictionaryAutoBackupSettingsCompat` 显式读写独立配置文件。

建议 key：

- `dictionary_auto_backup_enabled`：boolean，默认 false；
- `dictionary_auto_backup_tree_uri`：string；
- `dictionary_auto_backup_tree_label`：string；
- `dictionary_auto_backup_interval_days`：默认 7；
- `dictionary_auto_backup_retention_count`：默认 10；
- `dictionary_auto_backup_last_success_time`：long；
- `dictionary_auto_backup_last_attempt_time`：long；
- `dictionary_auto_backup_last_status`：int/string；
- `dictionary_auto_backup_last_document_uri`：string，可选；
- `dictionary_auto_backup_last_sha256`：string，可选；
- `dictionary_auto_backup_consecutive_failures`：int，可选。

读取时约束：

- interval：1–365 天；
- retention：1–100；
- 非法值回退默认值。

`inProgress` 只存在于进程内，不持久化。

偏好丢失不会影响已经生成的公共本地 `.txt` 文件。独立配置文件不得被追加到现有 `BackupAgent`，也不新增其他配置同步路径。

## 11. 设置与任务类设计

### 11.1 `DictionaryAutoBackupSettingsCompat`

只服务于 Pinyin 的 `DictionarySettingsFragment`：

- 绑定 5 个 `persistent=false` Preference；
- 只读写未注册到 `BackupAgent` 的独立本地配置文件；
- 发起仅本地 `ACTION_OPEN_DOCUMENT_TREE`；
- 处理 persisted URI permission；
- 验证本地 provider 和 create/write/read/rename/delete；
- 更新目录、时间、版本数和错误摘要；
- 触发“立即备份”；
- 不执行恢复或导入。

`DictionarySettingsFragment` 只需转发生命周期：

- `onCreate()`：bind；
- `onActivityResult()`：处理专用 request code，其余交给 superclass；
- `onResume()`：检查 persisted write grant 并刷新摘要；
- `onDestroy()`：释放 Fragment 引用。

### 11.2 `DictionaryAutoBackupCompat`

不持有 Activity/Fragment：

- 读取配置；
- 检查 enabled、到期、退避和 `inProgress`；
- 创建本地 SAF partial URI；
- 使用任务 key `user_dict_auto_backup` 向 `aib` 提交 `beg`；
- 在 listener 中处理校验、rename、状态和轮换；
- 清理失败或过期 partial；
- 不访问网络；
- 不扫描词库并自动恢复；
- 不调用 importer。

## 12. 状态机

### 12.1 自动备份

```text
PinyinIME 进入保存检查
  → 自动备份 enabled?
  → 本地 tree URI 存在且仍有 write grant?
  → 已到最小间隔?
  → 非 inProgress?
  → 失败退避已结束?
  → 创建本地 .partial
  → aib 提交 beg 原生 exporter
  → 校验 BOM/header/长度
  → rename 为正式 .txt
  → 更新 lastSuccess
  → 保留最新 N 份
  → 清除 inProgress
```

### 12.2 首次启用

```text
用户打开开关
  → 没有目录
  → 启动仅本地目录选择器
  → persist read/write grant
  → 本地 provider 验证
  → create/write/read/rename/delete 测试
  → 保存 URI 和 enabled=true
  → 立即生成第一份备份
```

### 12.3 清除数据或卸载后

```text
应用私有数据和 URI grant 消失
  → 公共本地 .txt 继续存在
  → 用户重新安装应用
  → 打开现有“导入用户字典”
  → 系统文件选择器定位本地备份目录
  → 用户手动选择某一 .txt
  → 原生 importer 导入到新装空词库
```

不会发生自动搜索、自动恢复或自动同步。

## 13. 错误处理

错误分类：

- 未配置目录；
- 选择了云端 provider；
- persisted URI permission 丢失；
- 本地存储被移除或不可用；
- provider 不支持 create/write/read/rename/delete；
- 输出流打开失败；
- exporter 返回 false；
- BOM/header/长度校验失败；
- 存储空间不足；
- rename 失败；
- 版本轮换删除失败。

自动失败不能：

- 阻塞输入法启动；
- 清空、回滚或修改当前用户词典；
- 弹出打断输入的 Dialog/Toast；
- 持续高频重试；
- 触发任何网络请求。

错误写入偏好和日志，在设置页显示。只有用户点击“立即备份”时可以显示一次明确结果。

## 14. 原生 exporter 的防御性整理

`UserDictExportTask` 当前主要捕获 `IOException`。正式接入前建议做不改变格式的资源安全整理：

- writer/output stream 在 finally 中关闭；
- `openDictionaries()` 部分成功时也关闭已经创建的 accessor；
- 处理 `openOutputStream()` 返回 null；
- 将 `SecurityException` 和 provider runtime failure 转成任务失败；
- 与 `SaveDictionaryTask` 共享 dictionary-I/O lock；
- 不让异常逃出 AsyncTask 导致进程错误。

不能修改：

- UTF-16LE；
- BOM/header；
- formatter；
- 字段顺序；
- 中文/英文导出顺序；
- native `exportAllEntries()`。

## 15. 隐私

用户词典可能包含姓名、地址、私人短语和工作术语。备份是未加密的可读文本。

设置页应说明：

- 文件只保存在用户选择的设备本地目录；
- 本功能不会上传或同步；
- 有权访问该本地目录的人或应用可能读取文件；
- 关闭自动备份、清除当前词典或卸载不会删除已有备份；
- 用户可以使用系统文件管理器删除备份。

第一阶段不增加加密格式，因为加密会破坏现有“导入用户字典”直接读取的能力，并引入密钥丢失问题。

## 16. 实施阶段

### Phase A：仅本地目录与立即备份

- 添加设置项和字符串/数组；
- 实现默认打开内部存储 Documents、但以 authority 强制限制本地 provider 的 tree picker；
- 验证本地 provider；
- 验证 create/write/read/rename/delete；
- 完成“立即备份”；
- 暂不接自动时间触发。

### Phase B：原生导出与完整发布

- 复用 `beg` 导出到 SAF `.partial`；
- exporter 与保存共享 lock；
- 整理资源关闭；
- 校验并 rename 为 `.txt`；
- 在隔离包中验证现有 importer 可以导入该文件。

### Phase C：自动间隔与版本轮换

- 接入 `PinyinIME.a()` / `PinyinIME.h()` 到期检查；
- 实现 interval、inProgress 和失败退避；
- 保留最新 N 份；
- 清理过期 partial。

### Phase D：真正的灾难恢复验收

在隔离 application ID 中：

1. 学习可识别的中文和英文测试词；
2. 生成本地自动备份；
3. 记录备份文件 SHA-256；
4. 清除隔离包应用数据，确认公共备份仍存在且 hash 不变；
5. 重新进入新装状态；
6. 使用现有“导入用户字典”手动选择该文件；
7. 导出并比较恢复后的词条；
8. 再执行一次“卸载 → 重装 → 手动导入”测试；
9. 全程不使用正式 `com.google.android.inputmethod.pinyin.compat` 做故障注入。

## 17. 验证矩阵

### 本地存储

- 内部存储 Documents 子目录；
- 本机 SD 卡目录（若设备存在）；
- Drive/云盘被隐藏或明确拒绝；
- 覆盖升级后 URI grant 保留；
- 清除数据后 `.txt` 保留，同时开关、URI 和时间记录被清除；
- 卸载后 `.txt` 保留；
- Android 系统执行应用数据 restore 时，不会重建独立的本地备份配置文件；
- 新装后的自动备份开关保持关闭，也不会扫描旧目录；
- 新装无需旧 URI grant，也能通过现有 import picker 读取文件；
- 备份过程不产生网络连接或云端 provider I/O。

### 导出内容

- 自动文件与手动导出格式一致；
- 同时包含中文和英文用户词典；
- 空词库文件合法；
- BOM/header 正确；
- partial 不出现在有效版本中；
- 正式 `.txt` 能由原生 importer 导入新装空词库。

### 调度和轮换

- 未到间隔不备份；
- 到期后下一次输入法保存检查只产生一份；
- 快速显示/隐藏键盘不重复；
- “立即备份”绕过间隔；
- retention=3 时第四份成功后删除最旧版本；
- 失败备份不删除旧成功版本；
- 不删除目录中的其他文件。

### 故障

- 写入 partial 前终止进程；
- 写入 partial 中终止进程；
- exporter 返回 false；
- 存储空间不足；
- SD 卡移除；
- URI permission 失效；
- rename 失败；
- 保存与导出接近同时发生；
- 所有失败都不影响输入、学习和 V41 内部 `_bak` 恢复。

## 18. 推荐结论

采用：

**原生用户词典 exporter + 仅本地 SAF 目录 + `.partial` 完整写入后 rename + 保存周期到期检查 + 本地版本轮换 + 新装后用户手动使用现有 importer。**

不采用云端 provider，不实现自动恢复，不实现账号同步，不在新装后扫描备份目录。

这直接覆盖“误清除应用数据”和“误卸载后未手动导出”两个目标，同时保持恢复操作由用户明确发起，并最大限度复用 Google 拼音现有导入/导出格式。
