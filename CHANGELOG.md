# Changelog

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
