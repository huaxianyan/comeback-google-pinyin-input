# Gboard 剪贴板建议实现研究

## 样本

- 设备：Pixel 10 Pro
- 包名：`com.google.android.inputmethod.latin`
- versionName：`17.7.5.932364120-release-arm64-v8a`
- versionCode：`175871638`
- targetSdk：37
- 提取方式：从设备的 `base.apk` 和 4 个 split APK 直接 `adb pull`
- 本地研究目录：`work/research/gboard/`（不纳入仓库）
- 反编译工具：apktool 2.12.1

## 核心结论

Gboard 的剪贴板建议**不是向 IME 根视图或键盘区域临时添加覆盖层**。它把剪贴板内容转换成标准的 suggestion model，再交给候选/建议栏自己的宿主渲染。因此位置、触摸分发、主题、动画、可访问性和生命周期都由已有候选栏体系处理。

这解释了 v21/v22 方案为什么方向不对：即使把自建 `TextView` 从 `InputView` 移到 `keyboard_area`，它仍然是候选系统之外的覆盖层，不能可靠继承候选栏的布局坐标、IME touchable region 和键盘 stylesheet。

## 关键类

由于 release APK 经过混淆，类名同时记录反编译名和日志中保留的原始源码名：

- `ewb`：`ClipboardDataHandler`
  - 实现 `ClipboardManager.OnPrimaryClipChangedListener`。
  - 负责监听系统剪贴板、读取和规范化 `ClipData`、维护最近内容及通知建议 helper。
- `eui`：`AutoPasteSuggestionHelper`
  - 负责输入框过滤、内容分类、chip View 创建、建议 model 创建、显示/隐藏及点击处理。
- `euh`：AutoPasteSuggestionHelper 的延迟/状态协调器。
- `ppm`：候选/建议栏统一消费的 suggestion model。
- `ppk`：`ppm` builder。
- `Leuk`：一条结构化剪贴板记录，包含显示文本、提交文本、时间和内容类型。

## 数据与生命周期

1. `ClipboardDataHandler` 在模块启动时异步注册 `OnPrimaryClipChangedListener`。
2. 模块结束时移除监听器，并清理 AutoPasteSuggestionHelper、EditorInfo 和输入会话对象。
3. `onPrimaryClipChanged()` 不直接操作 View，而是刷新结构化的剪贴板数据集合。
4. 只有设置项 `enable_auto_paste_chips` 开启时才创建 `AutoPasteSuggestionHelper`。
5. helper 保存当前 `EditorInfo`、输入会话和候选宿主接口；输入会话结束时统一撤下 suggestion model。
6. 最近项目通过时间戳去重；AutoPasteSuggestionHelper 内还定义了 2 分钟的有效期，并记录最后点击 chip 的时间戳。

## 安全和输入框过滤

Gboard 在创建 suggestion model 前执行多层过滤，而不是只检查几种 password variation：

- 根据 `EditorInfo.inputType` 选择不同的内容过滤器；
- 对密码、数字、电话、邮箱等输入类型采用不同允许类型集合；
- 检查应用通过 EditorInfo private options 提供的 `disableAutoPaste`；
- 检查全局 feature gate 和用户设置；
- 图片建议还检查当前编辑器支持的 MIME type；
- 无可用输入会话、EditorInfo 或候选宿主时不创建建议。

## View 创建方式

`AutoPasteSuggestionHelper.createProactiveSuggestions()` 最多处理 5 项。它不是手写一个全宽 TextView，而是：

1. 根据建议栏 surface 类型选择专用布局；
2. 用 `LayoutInflater` inflate chip；
3. 设置文本、内容类型图标、contentDescription 和 ellipsize；
4. 给整个 chip 根 View 设置 OnClickListener；
5. 把 View 列表放进统一 suggestion model；
6. model 的 source 明确设置为 `clipboard`，category 设置为建议栏支持的类别；
7. 由建议栏宿主决定实际位置、可见性、切换动画和点击区域。

文本 chip 的两个主要布局为：

- `res/layout/APKTOOL_DUMMYVAL_0x7f0e0063.xml`：紧凑候选栏样式，`wrap_content`，图标 + 单行文本；
- `res/layout/APKTOOL_DUMMYVAL_0x7f0e0118.xml`：另一种 suggestion surface，36dp 高，包含主题分隔线和 8dp 垂直 padding。

## 主题处理

Gboard 不读取系统 `Configuration.uiMode`，也不在 Java/smali 中根据系统深浅模式硬编码两套颜色。

- chip 通过 XML style 创建；
- 文本色、图标 tint、背景、ripple、高度和边距使用键盘主题 attr；
- 某些 surface 使用 `ContextThemeWrapper`；
- View tag（例如 `.chip-item-suggestion-text`、`.item-ripple.on-surface.bg-chip-item-suggestion`）会被 Gboard stylesheet 系统继续处理。

进一步解析主题二进制规则后确认：

- chip XML 背景是以纯白、1000dp 圆角 shape 作为 background/mask 的 ripple；
- 默认规则将 `.bg-chip-item-suggestion` 映射到 `default_chip_background_color`；
- 默认亮色规则再将该颜色映射到 `default_bordered_key_color`，基础值约为 `#4CFFFFFF`，即在键盘表面叠加约 30% 白色，而不是用深色文字生成半透明黑色背景；
- 默认暗色 chip 基础值约为 `#1AFFFFFF`；
- Material 3 动态色规则最终映射到 surface/container token；
- 紧凑 AutoPaste chip 使用约 34dp 高度、14sp 文本、20dp 图标、12dp 水平间距和完全胶囊圆角。

因此 chip 自动跟随当前键盘主题，而不是跟随系统主题。兼容版没有 Gboard stylesheet 引擎，需要根据当前候选文字亮度选择上述亮/暗 surface 叠加值，而不能直接把文字 RGB 当作 chip 背景。

## 点击提交

- 点击监听器设置在 chip 的根 View 上，而不是只有内部 TextView 可点；
- 文本点击经输入会话/候选框架提交，不直接依赖一个可能已过期的 service 引用；
- 点击后记录对应剪贴板项目时间戳并撤下 suggestion model；
- 图片内容走 MIME/URI commitContent 路径，文本走文本提交路径；
- 可访问性描述与屏幕显示文本分开设置。

## 对 Google 拼音兼容版的启示

下一版不应继续调整自建 overlay 的 gravity、margin 或硬编码颜色。正确方向是先找出 Google 拼音 4.5.2 中可复用的候选栏入口：

1. 定位 `KeyboardHeaderViewHolder` / 候选键盘的真实宿主和更新接口；
2. 确认是否能以标准候选项、临时候选页或 header extension 的形式注入一个剪贴板项；
3. 使用现有候选布局/style/soft-key 体系，让主题和触摸由框架处理；
4. 点击走框架已有的候选/soft-key action，再由输入法提交文本；
5. 如果旧框架没有 model API，优先在候选栏 XML 内预留受框架管理的容器，而不是挂到 `InputView` 或 `keyboard_area` 顶层。

在完成上述宿主定位和真机坐标/触摸验证前，不再实现新的剪贴板浮层。
