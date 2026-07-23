# Gboard 与 Google 拼音 IME 高刷新率研究

## 范围

对照以下实现：

- 当前兼容补丁：`patches/smali/FrameRateCompat.smali`；
- Gboard `17.7.5.932364120-release-arm64-v8a`；
- Pixel 10 Pro / Android 16 当前显示能力与 frame-rate category。

本研究最初只复核策略；Compatibility v29 已根据结论完成第一轮修正。

## 当前兼容补丁

`FrameRateCompat.apply()` 在每次 `PinyinIME.onStartInputView()` 后执行：

1. 将 IME Window 的 `WindowManager.LayoutParams.preferredRefreshRate` 固定为 `120.0f`；
2. Android 30+ 再对 decor view 调用 `View.setFrameRate(120, FRAME_RATE_COMPATIBILITY_DEFAULT)`；
3. 两条路径覆盖同一 IME surface，且都没有对应的 clear/release；
4. 所有异常被 `Throwable` 捕获并忽略。

该补丁最初用于避免 2018 年应用在现代高刷屏上被归入普通 60Hz 类别。它在目标 Pixel 上能表达明确的 120Hz 偏好，但属于固定帧率请求，不是按交互动态提升。

## Gboard 的实际实现

### 没有固定请求 120Hz

完整搜索 Gboard 四个 dex 后，没有发现业务代码设置：

- `WindowManager.LayoutParams.preferredRefreshRate`；
- `preferredDisplayModeId`；
- `View.setFrameRate(120, ...)`；
- `SurfaceControl.Transaction.setFrameRate()`。

APK 中出现的 `View.setFrameRate`/`SurfaceControl.setFrameRate` 符号只存在于 API outline 或通用支持库桥，不构成 Gboard IME 的固定帧率策略。

### Android 35+ 使用触摸帧率提升

Gboard 在 `GoogleInputMethodService.onConfigureWindow()` 中：

1. 反射检查 Window 是否存在 `setFrameRateBoostOnTouchEnabled(boolean)`；
2. 仅在 API 35+ 调用；
3. 通过专用 API outline 执行 `Window.setFrameRateBoostOnTouchEnabled(...)`；
4. 捕获 RuntimeException 并记录失败。

这是一种系统管理的“触摸期间提升、空闲后回落”机制，而不是让 IME Window 在整个可见期间固定保持 120Hz。

### 内容速度提示

Gboard 包含 `View.setFrameContentVelocity(float)` 的兼容桥。实际调用主要来自 AndroidX `NestedScrollView`/滚动组件及通用支持代码，用于让系统根据内容运动速度选择刷新率；它不是给整个 IME 固定设置 fps。

## Pixel 10 Pro / Android 16 显示能力

当前设备报告：

- 物理/默认 render frame rate：约 120Hz；
- frame-rate category：`normal=60Hz`，`high=90Hz`；
- ARR 支持：是；
- 可用 render rates 包括 120、60、40、30、24、20、15、10、5、2、1Hz；
- 120Hz 与 60Hz 对应同一分辨率下的显示模式/ARR 路径。

这说明现代系统已经区分“普通”“高”类别，并支持在空闲时降到很低的刷新率。固定 120Hz 会绕过一部分动态分类收益。

## 当前实现的优点

- 简单且效果确定；
- 对目标 120Hz Pixel 明确请求最高刷新率；
- Window hint 覆盖整个输入法，而不只某个候选 View；
- IME Window 不可见时其 surface 通常不参与显示合成，因此不会在键盘完全隐藏后继续直接驱动屏幕刷新；
- 不支持 120Hz 的设备通常由系统匹配可用模式，而不是直接失败。

## 当前实现的风险和不足

1. **固定写死 120Hz。** 90Hz、144Hz 或其他屏幕不能表达“使用当前设备高刷新类别”，只表达最接近 120 的精确偏好。
2. **空闲时仍保留偏好。** 输入法可见但用户未触摸时，Window 和 decor view 仍声明 120Hz，不利于 LTPO/ARR 降频。
3. **两条重复请求。** Window `preferredRefreshRate` 和 decor `setFrameRate` 同时设置，缺少证据证明必须叠加。
4. **没有释放。** `onFinishInputView()` 没有将 `preferredRefreshRate` 和 View frame rate 清回 0；Window 对象复用时状态会一直保留。
5. **使用 DEFAULT compatibility。** 它没有声明 fixed-source 等语义，但也没有利用现代 high category 或 touch boost 策略。
6. **与 Gboard 策略不一致。** Gboard 当前选择由系统在触摸期间 boost，并让滚动组件报告内容速度。
7. **可能增加键盘可见期间的功耗。** 尤其是停留在输入框但没有输入时。
8. **异常完全静默。** 无法区分 API 不支持、View 未 attach 或厂商拒绝请求。

## 不能直接照搬 Gboard 的原因

- `Window.setFrameRateBoostOnTouchEnabled()` 是较新的 API，Gboard只在 API 35+ 使用；
- Google 拼音兼容版还需要覆盖 Android 11–14，没有同等 Window touch-boost API；
- 旧 Google 拼音滚动和动画代码不会像现代 AndroidX 组件一样全面报告 `setFrameContentVelocity`；
- 直接删除 120Hz 请求可能让旧应用重新落回 60Hz，破坏已经获得的流畅度。

因此不建议仅因为 Gboard 没有固定 120Hz，就立即删除当前补丁。

## 建议的迭代方向

### 第一阶段：低风险生命周期修正

1. 保留输入视图活动期间的 120Hz 请求；
2. 在 `onFinishInputView()` 明确调用 `FrameRateCompat.clear()`：
   - `preferredRefreshRate = 0f`；
   - Android 30+ `decorView.setFrameRate(0f, DEFAULT)`；
3. 避免 Window 长期复用时遗留固定偏好。

这一阶段不改变用户已感知的输入流畅度，是最适合优先实施的基础修正。

### 第二阶段：消除重复请求实验

分别验证：

- 只使用 Window preferredRefreshRate；
- 只使用 decor view setFrameRate；
- 两者同时使用。

根据 SurfaceFlinger/DisplayManager 的实际 frame-rate vote 决定保留哪一条，而不是继续假设必须叠加。

### 第三阶段：现代动态策略

- API 35+ 调查并采用 `setFrameRateBoostOnTouchEnabled(true)`，让空闲时回落；
- 对滚动候选、符号列表等真正有速度的 View，考虑报告 `setFrameContentVelocity`；
- Android 30–34 在没有 touch boost API 时，再决定是否保留固定 120Hz fallback；
- 如系统提供稳定的 high frame-rate category API，优先表达“高”而不是写死具体 fps。

## V29 实施结果

考虑到目标设备已经出现疑似持续高刷导致的异常发热，V29 不再保留输入视图活动期间的固定 120Hz：

1. `apply()` 先将旧版 Window `preferredRefreshRate` 和 decor `setFrameRate` vote 清为 0；
2. API 35+ 通过反射确认并启用 `Window.setFrameRateBoostOnTouchEnabled(true)`；
3. Android 30–34 只清除固定 vote，由系统默认刷新率策略接管；
4. `onFinishInputView()` 调用 `clear()`，关闭 touch boost，并再次清除 Window/View vote；
5. 不再写死 120Hz，因此 90Hz、120Hz、144Hz 和 LTPO 设备均可由系统按能力调度。

这是从“整个输入会话固定最高刷新率”切换到“触摸时动态提升、空闲时允许降频”的策略。后续是否对特定滚动 View 报告 `setFrameContentVelocity`，应在确有流畅度问题时单独评估。
