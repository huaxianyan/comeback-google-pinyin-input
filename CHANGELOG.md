# Changelog

## [0.39.0] - 2026-07-24

对应 Compatibility v45 / versionCode `4520358`，移除不可用的 DocumentsUI 目录选择依赖，改为固定 Documents 本地备份和显式手动导入。

### Changed

- 备份固定写入 `内部存储/Documents/GooglePinyinBackup`；“备份位置”改为只读显示，不再启动系统目录选择器。
- API 29+ 通过 `MediaStore.Files`、`RELATIVE_PATH` 和 `IS_PENDING` 创建并发布原生 UTF-16LE TSV；清除数据或卸载后公共文件保留。
- 新增“导入本地备份”，列出当前安装可访问的固定目录备份并复用原生 `UserDictImportTask`。
- 新增显式 `ACTION_VIEW` / `ACTION_SEND text/plain` 导入 Activity；卸载重装后可在 File Geek 中打开或分享旧备份到 Google 拼音，由用户确认后导入。
- 测试阶段保留旧“导入用户字典/导出用户字典”；验证完成后再以固定路径入口替换重复旧入口。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat45-fixed-documents-backup`。
- 独立测试包名：`com.google.android.inputmethod.pinyin.localbackupaudit`。

## [0.38.0] - 2026-07-24

对应 Compatibility v44 / versionCode `4520357`，修复 V43 本地目录选择器无法从左侧位置列表进入内部存储的问题。

### Fixed

- 移除 tree picker 上的 `Intent.EXTRA_LOCAL_ONLY` 提示；Android 16 DocumentsUI 在目录模式下可能因此隐藏或禁用 primary storage 入口。
- 纯本地限制仍由返回 URI 的 `com.android.externalstorage.documents` authority 强制执行，云端 provider 即使显示也无法通过验证。
- API 26+ 使用 `DocumentsContract.EXTRA_INITIAL_URI` 默认打开 `primary:Documents`，让用户能直接选择预先建立的 `Documents/GooglePinyinBackupAudit`，体验更接近现有“导入用户字典”的文件选择器。
- 继续使用 `ACTION_OPEN_DOCUMENT_TREE`，因为现有导入的 `GET_CONTENT` 只能授权单个文件，无法给自动备份授予创建和轮换多个文件所需的目录写权限。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat44-local-backup-picker-fix`。
- 独立测试包名仍为 `com.google.android.inputmethod.pinyin.localbackupaudit`，可覆盖安装 V42/V43。

## [0.37.0] - 2026-07-24

对应 Compatibility v43 / versionCode `4520356`，修复 V42 打开字典设置时的立即崩溃。

### Fixed

- 旧 `CommonPreferenceFragment` 会在 API 20+ 把 XML 中的 `CheckBoxPreference` 运行时替换为 `SwitchPreference`；V42 helper 错误地强制转换回 `CheckBoxPreference`，触发 `ClassCastException`。
- 自动备份开关改为通过两者共同的 `TwoStatePreference` 基类绑定，不改变旧框架的 Switch 转换和样式。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat43-local-backup-settings-fix`。
- 独立测试包名仍为 `com.google.android.inputmethod.pinyin.localbackupaudit`，可覆盖安装 V42 测试包。

## [0.36.0] - 2026-07-24

对应 Compatibility v42 / versionCode `4520355`，使用独立 localbackupaudit 包验证清除数据或卸载后仍保留的设备本地用户词典导出备份。

### Added

- 在“设置 → 字典 → 用户字典”加入本地自动备份开关、本地目录、频率、保留版本和“立即备份”。
- 仅接受 Pixel/AOSP 的本地 ExternalStorageProvider，通过 SAF 持久目录授权写入；不接受云端 DocumentsProvider，不上传或同步词条。
- 完整复用原生中文/英文 `UserDictExportTask` 和 UTF-16LE TSV 格式，先写 `.partial`，校验 BOM/header 后 rename 为正式 `.txt`。
- 自动配置保存在未注册到旧 `BackupAgent` 的独立 SharedPreferences；清除数据或卸载后配置消失，但公共本地备份文件保留，新装后由用户使用现有“导入用户字典”手动导入。
- 支持 1/3/7/14/30 天最小间隔、3/5/10/20/30 份轮换以及失败退避；不新增 Alarm、Job、Worker、自动恢复或启动扫描。

### Changed

- 原生用户词典 exporter 与 V41 保存路径共享进程级 dictionary-I/O lock，避免生命周期同步保存与后台导出并发访问 mutable dictionary。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat42-local-dictionary-backup`。
- 独立测试包名：`com.google.android.inputmethod.pinyin.localbackupaudit`。
- 测试 APK 已通过 apktool 重建、zipalign 以及 v1/v2/v3 签名校验；构建时设备未连接，因此尚未安装或执行功能测试。
- 研究与设计：`docs/dictionary-auto-backup-design.md`。

## [0.35.0] - 2026-07-24

对应 Compatibility v41 / versionCode `4520354`，在独立 dictionaryaudit 包中复核可变词库的滚动保存与故障恢复。

### Changed

- 对照当前 Gboard 的 `DictionaryAccessor`、enrollment 和 `SaveDictionaryTask`，记录完整故障矩阵及真机词库快照结果。
- 原生加载主文件及 `_bak` 都失败时，继续尝试仍存在的 `_tmp`；每个候选只消费一次，重试路径保持有界。
- 为旧 `SaveDictionaryTask.saveDictionaries()` 增加进程内共享锁，避免不同任务实例中的定时异步保存与生命周期强制保存同时轮换相同的主文件、`_bak` 和 `_tmp`。
- 用户明确关闭某个可变词库，且主文件已删除或本来就不存在时，同时清除 `_bak`、`_tmp` 和 `_unreadable`，避免以后重新启用时恢复已删除数据。
- “清除用户字典”成功持久化空词库后，清除旧滚动备份和故障副本，确保破坏性操作覆盖所有恢复副本；普通学习、编辑和定时保存仍保留滚动备份。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat41-dictionary-recovery`。
- 新增研究记录：`docs/gboard-dictionary-recovery-research.md`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并安装为独立的 `com.google.android.inputmethod.pinyin.dictionaryaudit` 审计包；未覆盖当前兼容包，也未执行输入功能或视觉测试。

## [0.34.0] - 2026-07-24

对应 Compatibility v40 / versionCode `4520353`，继续使用独立 guideaudit 包验证统一的 footer 操作。

### Changed

- 移除完成页内容区中央的完成按钮；完成页右下角沿用前两页“下一步”的固定位置和同一按钮样式。
- 进入最后一页时，右下角按钮文字从“下一步”切换为“完成”，保持可交互；返回前一页时恢复为“下一步”。
- 右下角按钮在最后一页调用 V38 已验证的 `exitGuide()`，直接返回桌面并移除引导任务；第一、第二页仍执行原生下一页动画。
- 最后一页继续保留左下角“上一步”，整体形成固定的左后退、右继续/完成导航逻辑。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat40-footer-finish`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，覆盖安装 guideaudit 测试包，清除该测试包数据并打开引导入口；未执行功能或视觉测试。

## [0.33.0] - 2026-07-23

对应 Compatibility v39 / versionCode `4520352`，继续使用独立 guideaudit 包验证显式引导导航。

### Changed

- 完整移除首次引导底部 PageIndicator，不再依赖旧 `PageIndicatorView` 的 enabled-state 视觉语义。
- 将首次引导 pager 替换为 `NonSwipeableFirstRunViewPager`，仅禁止用户触摸滑页，保留按钮触发的原生程序化翻页和动画。
- 底部改为左侧“上一步”和右侧“下一步”按钮；第一页隐藏上一步，最后一页隐藏下一步。
- 上一步复用旧框架 `navi_skip` 插槽但仅在 `PinyinFirstRunActivity` 中改为后退，功能介绍 Activity 继续保持原来的跳过/关闭行为。
- 启用或选择输入法完成后不再自动跳页，只解锁当前页的下一步按钮；未完成时下一步不可交互，并使用明确的 disabled 背景和文字颜色。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat39-guided-first-run`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并覆盖安装独立的 `com.google.android.inputmethod.pinyin.guideaudit` 测试包；已清除该测试包数据并打开引导入口，未执行功能或视觉测试。

## [0.32.0] - 2026-07-23

对应 Compatibility v38 / versionCode `4520351`，继续使用独立 guideaudit 包验证首次引导。

### Fixed

- 移除步骤完成状态中勾号背后的第二层圆形底色，改为直接在外层完成容器上显示随明暗主题着色的勾号。
- 系统返回键在第二、第三页时返回前一页，仅在第一页退出；不再从任意页面直接关闭引导。
- 完成或从第一页退出时先显式返回桌面，再移除引导任务，避免重新露出启动引导的应用设置页面。
- 为指示器增加独立的明暗主题颜色；暗色模式当前页使用浅色，其他页使用明显更暗的灰色，不再复用按钮 primary/outline 色。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat38-first-run-navigation`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并覆盖安装独立的 `com.google.android.inputmethod.pinyin.guideaudit` 测试包；未执行功能或视觉测试。

## [0.31.0] - 2026-07-23

对应 Compatibility v37 / versionCode `4520350`，用于首次使用引导专项验证。

### Changed

- 对照当前 Gboard 的标准三页数组，将首次使用流程固定为“启用输入法 → 选择输入法 → 完成”，不再显示旧权限总览页或匿名指标页。
- 保留旧框架从系统设置/输入法选择器返回后的状态刷新、自动推进、PageIndicator、完成按钮和 `finishAndRemoveTask()` 行为。
- 构建脚本新增可选 application ID；正式默认仍为 `com.google.android.inputmethod.pinyin.compat`，本次测试包使用独立的 `com.google.android.inputmethod.pinyin.guideaudit`，并同步隔离用户词典 authority 和应用数据。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat37-first-run-audit`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并以独立包名安装到 Pixel 10 Pro；原 V36 compatibility 包仍保持安装且版本不变。
- 未执行引导功能或视觉测试，验证由项目维护者完成。

## [0.30.0] - 2026-07-23

对应 Compatibility v36 / versionCode `4520349`。

### Changed

- 对照当前 Gboard，将手写 `ayc` 的 down/move/up 局部裁剪改为不带 `Region.Op` 的 `Canvas.clipRect(RectF)`，继续以成对 save/restore 隔离每次 dirty rect 绘制。
- 为 `aye` 与 `HandwritingOverlayView` 的全画布清屏补齐 save/restore，并在恢复完整 Canvas 状态后再重放保留的 strokes。
- 不修改 ALPHA_8 离屏 Bitmap、pressure、Path、dirty rect、MotionEvent、Stroke 或 JNI 识别路径；滑行轨迹继续保留原有独立修复。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat36-handwriting-canvas`。
- APK 已成功重建，通过 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试，手写验证由项目维护者完成。

## [0.29.0] - 2026-07-23

对应 Compatibility v35 / versionCode `4520348`。

### Changed

- V34 真机确认全键盘符号/表情单指可轻松左右翻页，局部 velocity fling 修复通过。
- 删除临时 `PagerDiagnosticsCompat`、`GPPagerDiag` 日志及 `lk` 中全部诊断调用；正式版只保留对 `PageableRecentSubCategorySoftKeyListHolderView` 验证通过的 legacy distance 门槛旁路。
- V32 分页误选取消、慢速手势 50% settle、候选 pager、左侧竖向列表和其他 `lk` 使用者保持不变。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat35-symbol-pager-fling`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.28.0] - 2026-07-23

对应 Compatibility v34 / versionCode `4520347`。

### Fixed

- V33 的 30 次采样确认旧 `lk` final-delta distance 始终为 0，导致全键盘符号/表情的 fling 分支完全不可达；21 次回弹中有 16 次速度实际已超过系统 minimum。
- 仅对 `PageableRecentSubCategorySoftKeyListHolderView` 跳过失效的 legacy 25dp final-delta 门槛，改为在已经进入 dragging 后按系统 minimum fling velocity 进入原有 fling 目标页逻辑。
- 保留 paging touch slop、方向竞争、慢速手势 50% settle、target clamp、页码和 Scroller 动画；候选 pager 与其他共享 `lk` 的界面继续使用原双重门槛。
- 保留 V33 日志一个验证周期，并修正 `result` 文本；诊断 tag 仍为 `GPPagerDiag`。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat34-symbol-pager-fling`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；安装后已清空 Logcat，未执行功能测试。

## [0.27.0] - 2026-07-23

对应 Compatibility v33 / versionCode `4520346`，仅用于横向 pager 诊断。

### Diagnostics

- 新增 `PagerDiagnosticsCompat`，只记录 `PageableRecentSubCategorySoftKeyListHolderView` 在 UP 时已经计算完成的 current/target、页面 offset、拖动 distance、25dp threshold、velocity、minimum velocity 与 fling 判定。
- 日志 tag 为 `GPPagerDiag`；候选 pager 和其他共享 `lk` 的界面通过类型检查排除。
- 诊断调用不修改 `lk` 字段、MotionEvent、touch slop、velocity、settle、目标页或 Scroller 动画，V32 点击取消逻辑保持不变。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat33-pager-diagnostics`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；安装后已清空 Logcat，未执行功能测试。

## [0.26.0] - 2026-07-23

对应 Compatibility v32 / versionCode `4520345`。

### Fixed

- 对照 Gboard 的显式滚动取消协议，将分页辅助类 `aws` 接入现有 `ScrollTouchCompat` 外层状态桥。
- 分页候选及全键盘符号/表情在超过原生 paging touch slop 后，除取消 holder 自身事件副本外，也会取消 `SoftKeyboardView` 自定义按键管线的外层释放，避免现代 Android 上滑动后松手误选起点按键。
- 保持 pager 的 `super -> aws detector` 顺序以及原生 touch slop、方向、速度、翻页阈值和 fling 参数不变；不调整已经验证的左侧竖向列表逻辑。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat32-pageable-touch-cancel`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.25.0] - 2026-07-23

对应 Compatibility v31 / versionCode `4520344`。

### Reverted

- 根据 V29/V30 真机测试结果，回滚全部 IME 帧率干预：删除 `FrameRateCompat`、Window touch boost、Window preferred refresh rate、View frame-rate vote 以及开始/结束输入生命周期注入。
- 不恢复曾导致疑似异常发热的固定 120Hz 实现；当前完全由 Android 系统默认调度帧率和 LTPO/ARR。
- 高刷新率支持推迟到 target API 与渲染管线现代化后重新实现。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat31-system-frame-rate`。

## [0.23.0] - 2026-07-23

对应 Compatibility v29 / versionCode `4520342`。

### Fixed

- 移除 IME Window `preferredRefreshRate=120` 和 decor view `setFrameRate(120, DEFAULT)` 两条固定高刷新率请求，避免键盘可见但空闲时阻止 LTPO/ARR 降频。
- API 35+ 改用当前 Gboard 使用的 `Window.setFrameRateBoostOnTouchEnabled(true)`，让系统只在触摸交互期间提升刷新率。
- 新增 `FrameRateCompat.clear()`，在 `onFinishInputView()` 中关闭 touch boost，并将 Window/View 的遗留 frame-rate vote 清为 0。
- Android 30–34 不再写死 120Hz，由系统默认策略选择适合设备的刷新率；90Hz、120Hz、144Hz 屏幕不再被统一映射到固定值。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat29-dynamic-frame-rate`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.22.0] - 2026-07-23

对应 Compatibility v28 / versionCode `4520341`。

### Fixed

- 根据 V27 真机主题切换结果，确认所有主题仍进入原有浅/深 fallback。
- 定位原因：Google 拼音 stylesheet 通过自定义 `bam` Drawable 包装原背景，并把最终主题 tint 保存在公开 `ColorStateList` 中；读取包装内部的基础 `GradientDrawable` 无法获得最终颜色。
- `NavigationBarCompat` 现在优先识别 `bam`，按 Drawable 当前 state 从其 `ColorStateList` 读取真实颜色，再回退到 Android 标准 Drawable 和主题名称路径。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat28-stylesheet-nav-color`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.21.0] - 2026-07-23

对应 Compatibility v27 / versionCode `4520340`。

### Changed

- `NavigationBarCompat` 不再优先通过 theme cache key 猜测浅色或深色，而是读取当前 `keyboard_body_view_holder` 中已经完成 stylesheet 渲染的键盘 body 背景色。
- body 在早期生命周期或切换过程中暂不可用时，继续尝试读取 `keyboard_area` 的最终背景色；只有无法得到 alpha 255 的 surface 时才回退到 V26 的名称判断和内置浅/深颜色。
- 支持从 `ColorDrawable`、`GradientDrawable`、`LayerDrawable` 和当前 `DrawableContainer` 状态中提取颜色，因此可覆盖内置 shape、layer-list 及额外主题 selector。
- 虚拟导航键明暗改为根据实际 surface 的加权亮度计算，不再由主题名称直接决定。
- 本阶段不改变 divider、WindowInsets、三键/手势模式和 contrast enforcement，降低基础重构范围。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat27-rendered-nav-surface`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.20.0] - 2026-07-22

对应 Compatibility v26 / versionCode `4520339`。

### Fixed

- 修正 V25 在亮色键盘中直接使用深色候选文字 RGB 生成 chip 背景，导致整体明显偏暗的问题。
- 根据 Gboard 二进制 stylesheet 的实际规则实现亮暗表面：亮色键盘使用约 `#4CFFFFFF` 的白色 surface 叠加，暗色键盘使用约 `#1AFFFFFF`，不再使用文字色作为背景色。
- 描边降为亮色主题下约 9% 黑色、暗色主题下约 15% 白色，elevation 从 3dp 降到 2dp并移除额外 translationZ，避免阴影过重。
- 按 Gboard 紧凑 AutoPaste chip 参数调整为 34dp 高、14sp 文本、20dp 图标和 1000dp 完全胶囊圆角。

### Research

- 确认 Gboard chip XML 使用白色 pill shape 作为 ripple background/mask，实际颜色由 `.bg-chip-item-suggestion` stylesheet tag 重写；亮色默认映射到 bordered-key surface，而不是半透明黑色。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat26-gboard-light-chip`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.19.0] - 2026-07-22

对应 Compatibility v25 / versionCode `4520338`。

### Changed

- 完整移除 4–8 位验证码正则及提取分支；剪贴板候选现在始终忠实提交完整原文，仅屏幕摘要保留 18 字符加 `...` 的视觉截断。
- 将 clipboard chip 的主题色填充透明度由约 9% 提升到约 19%，描边透明度提升到约 44%，增强与底层候选栏的层次差异。
- 为圆角 chip 增加 3dp elevation、1dp translationZ 和平台圆角 outline 阴影，使其呈现更接近 Material 按钮的凸起质感。
- 候选 View 回收时同步清除 elevation 和 translationZ，避免普通候选继承阴影。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat25-raised-clipboard-chip`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.18.0] - 2026-07-22

对应 Compatibility v24 / versionCode `4520337`。

### Fixed

- 修复仅将 chip 内部文字设为居中、但单个候选 `SoftKeyView` 仍停靠候选栏左侧的问题：当候选栏中只有剪贴板 chip 时，将整个候选项组水平居中；出现普通候选后恢复原生起始对齐。
- 修复 `AutoSizeTextView` 接收 `16sp` 原始数值后错误计算最小字号比例，导致文字异常放大并被 chip 高度裁切的问题；现在先按 `scaledDensity` 转换为真实像素，再交给旧版自动缩放实现。

### Build

- versionName：`4.5.2.193126728-arm64-v8a-a16compat24-centered-clipboard-chip`。
- APK 已成功重建、完成 zipalign 与 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro；未执行功能测试。

## [0.17.0] - 2026-07-22

对应 Compatibility v23 / versionCode `4520336`。

### Changed

- 剪贴板候选的长文本摘要改为最多显示开头 18 个字符，并使用三个点 `...` 结尾；提交内容仍保持完整。
- 参考 Gboard AutoPaste chip，将剪贴板候选改为单行垂直/水平居中布局、16sp 文本、36dp 最小高度和更紧凑的内边距。
- 在内容外增加随键盘文字颜色变化的半透明圆角填充与描边，并隐藏该项的原生候选分隔线。
- 将剪贴板图标固定为 16dp，放置在文本前并保留 8dp 间距。
- 候选 View 回收时恢复原生背景、字号、padding、分隔线和 drawable，避免普通候选继承 clipboard chip 样式。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat23-clipboard-chip`。

### Build

- V23 APK 已成功重建，通过 zipalign 和 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro。
- 按约定未执行功能测试，视觉效果由项目维护者真机验证。

## [0.16.0] - 2026-07-22

对应 Compatibility v22 / versionCode `4520335`。

### Added

- 将已通过真机最小验证的原生候选栏方案接入系统剪贴板：输入视图启动时读取最近两分钟内的纯文本剪贴板，并在剪贴板变化时刷新候选 model。
- 对 4–8 位独立数字自动提取验证码；其他文本显示并提交原始内容，过长显示文本会截断但不改变提交内容。
- 剪贴板候选参与每轮拼音、英文和手写候选更新，使用原生 `Candidate`、`SoftKeyView`、键盘主题、触摸及可访问性路径。

### Privacy

- 密码、可见密码、网页密码和数字密码输入框不读取或展示剪贴板候选。
- 支持应用通过 `privateImeOptions=disableAutoPaste` 禁用建议，并忽略标记为 `android.content.extra.IS_SENSITIVE` 的剪贴板及非文本内容。
- 仅在输入视图活动期间注册剪贴板监听器；输入视图结束后立即移除监听并清理当前候选。
- 点击后的同一条剪贴板内容在进程生命周期内不再重复建议。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat22-clipboard-candidate`。
- 编码代理继续负责 APK 构建、签名和安装；功能验证及回归测试统一由项目维护者执行。

### Testing

- 原生候选栏静态原型已由项目维护者验证：位置正确、点击可上屏，并可在英文与手写笔画模式正常工作。
- V22 APK 已成功重建，通过 zipalign 和 v1/v2/v3 签名校验，并覆盖安装到 Pixel 10 Pro。
- 动态剪贴板读取、验证码提取、候选合并和隐私过滤尚待项目维护者真机验证。

## [0.15.0] - 2026-07-21

对应 Compatibility v20 / versionCode `4520332`。

### Fixed

- 修复词库持久化成功后立即删除上一份 `_bak` 的问题，改为始终保留一份上一版本滚动备份。
- 修复保存过程中进程终止后主词库缺失时，启动逻辑忽略 `_bak`/`_tmp` 并直接创建空词库的问题：现在优先恢复 `_bak`，无备份时再尝试 `_tmp`。
- 修复原生引擎无法载入主词库时直接注册空词库的问题：现在先隔离不可读主文件，再恢复上一份 `_bak` 并递归重试一次。
- 无可用备份时，将不可读主文件保留为 `_unreadable`，避免在首次降级为空词库时立刻销毁唯一的故障现场。

### Safety

- 恢复逻辑应用于拼音和英文引擎的全部可变词库，包括用户词库、新词库、联系人词库和快捷词库。
- 不改变原生词库格式、50 万条用户词库容量和压缩算法，降低兼容风险。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat20`。

### Testing

- APK 已成功重建、签名并覆盖安装；新增 smali 类及修改后的异常恢复分支均通过 apktool 汇编。
- 正常安装和包信息检查通过。中断写入及损坏词库恢复仍需后续构造场景进行专项验证。

## [0.14.0] - 2026-07-21

对应 Compatibility v19 / versionCode `4520331`。

### Removed

- 移除用户词典设置页中的“词典更新”分类、“词典更新”开关和“词典更新通知”开关。
- 停止向周期任务管理器注册 `new_words_update`，不再创建指向已失效 `https://tools.google.com/service/update?as=pinyinsysdict` 的 `NewWordsUpdateTaskFactory`。
- 移除在线词典更新对应的 INTERNET/ACCESS_NETWORK_STATE 功能权限注册。
- 补充移除遗留的 `daily_ping_task` 周期统计任务注册；保留与在线系统词典无关的本地 English model 周期维护任务。

### Preserved

- 保留用户词典本地导入、导出、快捷词典和用户词典同步入口；本次仅移除失效的系统词典在线更新。
- 保留 v18 的统计、Firebase 和反馈上传清理。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat19`。

### Testing

- APK 已重建、签名并覆盖安装到 Pixel 10 Pro；设置 XML 和 `PinyinIME` 中已无在线系统词典更新入口及任务注册。

## [0.13.0] - 2026-07-21

对应 Compatibility v18 / versionCode `4520330`。

### Removed

- 移除设置“其他”页面中的“发送使用情况统计信息”开关。
- 移除设置菜单中的“发送反馈”入口，以及 Manifest 中的拼音反馈 Activity、Google User Feedback Activities 和上传 Service。
- 移除 Manifest 中的 Firebase Instance ID Receivers、Service 和 Firebase JobDispatcher Receiver，阻止失效的注册、广播及后台任务入口被系统启动。
- 停止在 `PinyinApp` 中创建 `Laym`，不再注册 Clearcut/Primes 的每日 ping、IME 事件和键盘事件统计处理器，也不再创建 Clearcut 上传适配器。

### Preserved

- 保留本地 `IMetrics` 接口供旧框架内部计时和状态逻辑使用，但不挂接任何网络上传处理器。
- 用户词典同步和在线词典更新暂未在本次清理范围内。
- 横向符号/表情分页继续保持 v17 已恢复的原版逻辑。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat18`。

### Testing

- APK 已重建、签名并覆盖安装；Manifest 和设置 XML 中已无 Firebase、User Feedback、使用统计及发送反馈入口。

## [0.12.0] - 2026-07-21

对应 Compatibility v17 / versionCode `4520329`。

### Reverted

- 完整回滚此前所有针对全键盘符号、标点、表情横向分页的修改，包括早期将翻页提交距离从 25 dp 降至 8 dp、移除最低 fling 速度条件，以及 v14-v16 的 touch slop、方向、分页状态桥和强制翻页实验。
- 横向分页器 `lk`、`mq` 及 `PageableSoftKeyListHolderView` 恢复原版 APK 的触摸阈值、释放判定、动画、方向和事件处理。
- 保留已经验证正常的九宫格左侧纵向列表修复、高刷新率请求、Android 16 手写及导航栏兼容补丁。

### Changed

- 为允许覆盖安装已经发布到手机的高 versionCode 测试版，回滚构建使用 versionCode `4520329` 和 versionName `4.5.2.193126728-arm64-v8a-a16compat17`。除横向分页代码恢复原版外，其余功能代码以已验证的 v13 为基线。

### Testing

- 已从 v13 APK 重新解码并重建，签名验证通过，随后成功覆盖安装到 Pixel 10 Pro。

## [0.11.0] - 2026-07-21

对应 Compatibility v13 / versionCode `4520325`。

### Fixed

- 修复静止点击被错误归类为滚动：不再依据子 View 事件坐标位移，因为现代 Android 的事件副本和坐标转换会让同一次静止触摸在不同分派阶段出现较大的局部坐标差。
- 改为在内部 `ScrollView` 完成每个 `MOVE` 后比较实际 `scrollY`。只有列表内容确实移动至少 1 px 才设置滚动状态；静止点击不会取消，快速连续滑动也不再依赖不稳定的事件坐标。
- 保留 v12 的释放时序，内部列表继续先收到原始 `ACTION_UP`，不影响惯性滚动。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat13`。

### Testing

- APK 已重建并签名；安装时手机已从 ADB 断开，等待重新连接后安装。

## [0.10.0] - 2026-07-21

对应 Compatibility v12 / versionCode `4520324`。

### Fixed

- 修复 v11 中普通点击也被取消的问题：现在外层在每次新的 `ACTION_DOWN` 时无条件清除上一手势的滚动状态。
- 恢复滚动惯性：不再提前修改送往内部 `ScrollView` 的释放事件。列表先接收原始 `ACTION_UP` 并计算 fling，随后才把外层自定义按键管线即将处理的事件改为 `ACTION_CANCEL`。
- 避免快速连续滑动时因前一手势状态残留而随机输入符号。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat12`。

### Testing

- 已覆盖安装独立包名版本；等待分别复测单击、慢速拖动和快速甩动。

## [0.9.0] - 2026-07-21

对应 Compatibility v11 / versionCode `4520323`。

### Fixed

- 原版在 Android 16 上可复现同样问题，确认这是旧触摸实现与新系统事件分派之间的兼容问题，而非此前补丁单独引入。
- 旧实现假设在内部 `ScrollView` 修改 `MotionEvent` 后，外层 `SoftKeyboardView` 会看到同一个已修改对象。现代 Android 向子 View 分派经过坐标转换的事件副本，内部副本改为 `ACTION_CANCEL` 后，外层自定义按键管线仍会收到原始 `ACTION_UP`，因而选中滑动起点。
- 新增显式滚动状态桥：内部列表检测到实际纵向移动后记录状态；外层 `SoftKeyboardView` 在处理自己的原始释放事件前读取该状态并将其改为 `ACTION_CANCEL`。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat11`。

### Testing

- 已覆盖安装独立包名版本；官方原版继续保留，可直接切换对比。

## [0.8.0] - 2026-07-21

对应 Compatibility v10 / versionCode `4520322`。

### Changed

- 兼容版应用 ID 改为 `com.google.android.inputmethod.pinyin.compat`，可与官方原版 `com.google.android.inputmethod.pinyin` 并存，方便同机对比触摸行为。
- 同步隔离用户词典 Provider authority，避免与原版冲突。
- 应用中文名及其他语言显示名称保持原样，不添加“改版”或其他后缀。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat10`。

### Testing

- 已在 Pixel 10 Pro 成功安装独立包名版本，并确认系统同时识别两个不同的输入法组件。

## [0.7.0] - 2026-07-21

对应 Compatibility v9 / versionCode `4520321`。

### Fixed

- 根据真机现象修正问题定义：列表本身能够滚动，误选固定发生在松手时，并选择滑动起点处原先按住的候选或标点。
- 不再依赖 `GestureDetector` 的方向判定或外层布局坐标。滚动容器 `awo` 直接记录本次手势的起始 Y 坐标；只要纵向总位移超过系统 touch slop，就在释放进入子按键和外层输入管线前把 `ACTION_UP` 改为 `ACTION_CANCEL`。
- 普通静止点击仍保留原始 `ACTION_UP`。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat9`。

### Testing

- 已重建、签名并覆盖安装到 Pixel 10 Pro；等待九宫格左侧列表真机复测。

## [0.6.0] - 2026-07-21

对应 Compatibility v8 / versionCode `4520320`。

### Fixed

- 确认九宫格左侧误上屏发生在 `ACTION_DOWN`：`TappingActionHelper` 会在手指按下时立即建立并执行 `PRESS` 动作，因此在 `ACTION_UP` 阶段发送取消事件已经太晚。
- 对九宫格左侧面板改用延迟判定：标准 View 事件仍实时交给 `ScrollView`；自定义按键处理管线暂不接收 `DOWN/MOVE`。松手时若发生纵向移动则不生成按键事件；若没有移动则补发完整的 `DOWN/UP` 点击序列。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat8`。

### Testing

- 已重建、签名并覆盖安装到 Pixel 10 Pro；等待九宫格左侧候选及标点列表真机复测。

## [0.5.0] - 2026-07-21

对应 Compatibility v7 / versionCode `4520319`。

### Fixed

- 在 `SoftKeyboardView` 的外层自定义触摸管线增加仅针对九宫格左侧面板的纵向滑动保护。该输入法在标准 View 分派之后还会再次处理同一个事件，解释了仅在内部 `ScrollView` 取消释放仍会上屏的问题。
- 分页器的翻页提交距离从 25 dp 降至 8 dp，并取消“位移达标后还必须同时达到最低 fling 速度”的限制，使慢速短距离滑动也能翻页。

### Changed

- versionName：`4.5.2.193126728-arm64-v8a-a16compat7`。

### Testing

- 已重建、签名并覆盖安装到 Pixel 10 Pro；等待真机交互复测。

## [0.4.0] - 2026-07-21

对应 Compatibility v6 / versionCode `4520318`。

### Fixed

- 九宫格左侧候选/标点滚动容器现在从完整的 `dispatchTouchEvent` 事件流识别滑动，并在事件到达子按键前取消释放，修复滑动结束时内容直接上屏。
- 撤销 v5 对分页容器 `ACTION_UP` 处理顺序的错误修改；该修改会把正常轻扫改成取消事件，导致全键盘标点页必须拖过半页才能翻页。

### Changed

- 在 Android 11+ 为整个输入法窗口显式请求 120 Hz 帧率，改善分页滑动和候选区展开/收回动画的流畅度；系统会按屏幕能力选择最接近的刷新率。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat6`。

### Testing

- 待在 Pixel 10 Pro / Android 16 真机复测九宫格滚动、全键盘标点翻页及输入法窗口实际呈现帧率。

## [0.3.0] - 2026-07-20

对应 Compatibility v5 / versionCode `4520317`。

### Changed

- 首次使用引导在 Android 15+ 更新为 Material Design 3 风格，支持浅色和深色配色。
- 更新引导页的排版、圆角按钮、完成状态容器、页面背景和系统栏颜色。
- 从首次使用流程中移除匿名使用情况选择页面；统计偏好继续保持默认关闭。
- 最终完成按钮和系统返回键现在会关闭整个引导任务，不再露出功能介绍或应用设置。
- 首次启动始终使用完整页面集合，避免输入法启用前后页面指示器从 2 个变成 4 个。
- 使用 MD3 主色和轮廓色明确区分当前页面指示器，并优化已完成步骤的圆形勾选状态。
- 候选与标点翻页列表在滑动结束时先发送取消事件，避免松手误选触点下的内容。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat5`。

### Testing

- APK 已通过 apktool 2.12.1 重建；引导流程及候选/标点滑动修复等待 Android 16 真机复测。

## [0.2.0] - 2026-07-20

对应 Compatibility v4 / versionCode `4520316`。

### Fixed

- 根据 Android 16 真机 logcat 定位手写首次落笔崩溃：旧绘制器调用了系统不再允许的 `Region.Op.REPLACE`。
- 将手写及滑行绘制路径中的 6 处画布裁剪操作改为 `Region.Op.INTERSECT`。
- 使用成对的 `Canvas.save()` / `Canvas.restore()` 隔离每个笔画点的裁剪区，避免裁剪区持续收缩导致笔迹不可见。

### Changed

- versionCode：4520315 → 4520316。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat4`。

### Testing

- 已在 Pixel 10 Pro / Android 16 真机验证：手写笔迹显示、中文识别和候选上屏均正常。

## [0.1.0] - 2026-07-20

对应 Compatibility v3 / versionCode `4520315`。

### Added

- 增加 Android 16 系统导航栏主题适配。
- 根据 Google 拼音键盘主题标识选择浅色 `#ECEFF1` 或深色 `#263238`。
- 浅色主题使用深色系统导航图标，深色主题使用浅色图标。
- Android 28+ 同步导航栏分隔线颜色。
- Android 29+ 关闭系统强制导航栏对比度蒙层。
- 在候选区及扩展区更新后重新应用导航栏主题，避免输入时变黑。
- 增加可复现的 apktool 补丁及构建脚本。

### Changed

- targetSdkVersion：26 → 28。
- versionCode：4520313 → 4520315。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat3`。
- 为输入法服务和 Launcher Activity 显式声明 `android:exported="true"`。
- 为开机初始化 Receiver 显式声明 `android:exported="false"`。

### Known issues

- 手写输入会导致输入法进程崩溃，原因待 logcat/native backtrace 确认。
