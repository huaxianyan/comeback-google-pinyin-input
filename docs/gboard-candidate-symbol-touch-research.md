# Gboard 候选、符号与表情触摸/滚动研究

## 范围

本次对照：

- 当前 Google 拼音补丁：`ScrollTouchCompat`、`awo`、`SoftKeyboardView`；
- Google 拼音原生分页辅助类：`aws`；
- Gboard `17.7.5.932364120-release-arm64-v8a` 的候选、ScrollView、RecyclerView、ViewPager 与外层软键盘事件管线。

本阶段只调查和记录，不修改现有触摸补丁。

## Google 拼音当前事件模型

Google 拼音不是只依赖标准 Android View 点击分发。`SoftKeyboardView.dispatchTouchEvent()` 先把事件交给标准 View 树，之后又把同一个外层事件交给自定义 delegate/按键管线。因此，滚动容器即使已经取消其子 View，外层自定义管线仍可能在 `ACTION_UP` 选择最初按住的 SoftKey。

现代 Android 向子 View 分派坐标变换后的 `MotionEvent` 副本。子容器修改自己收到的副本，不再保证外层 `SoftKeyboardView` 持有的原始事件也被修改。这是旧版在 Android 16 上出现“列表滚动正常，但松手选择起点按键”的核心原因。

### 左侧竖向列表 `awo`

原版 `awo`：

- 继承 `ScrollView`；
- 使用 `GestureDetector` 判断纵向滚动；
- 在自己的 `onTouchEvent()` 中把 UP 改成 CANCEL；
- 该修改只作用于子层事件副本，不能可靠取消外层按键管线。

当前兼容补丁：

- 在 `awo.dispatchTouchEvent()` 记录初始 `scrollY`；
- MOVE 后只有实际 `scrollY` 改变才标记全局 scrolling；
- `SoftKeyboardView` 先完成标准分派，让 ScrollView 收到原始 UP 并计算 fling；
- 标准分派结束后，`ScrollTouchCompat.cancelOuterRelease()` 再把外层 UP 改成 CANCEL；
- 由此保留 fling，同时阻止松手误选。

### 分页候选与全键盘符号 `aws`

`PageableCandidatesHolderView` 与 `PageableSoftKeyListHolderView` 都使用 `aws`：

- 使用 `ViewConfiguration.getScaledPagingTouchSlop()`；
- 按配置选择 X 或 Y 方向；
- MOVE/UP 超过 slop 后，把自己收到的事件改成 CANCEL；
- holder 的调用顺序是先执行 pager 的 `super.onTouchEvent()`，再执行 `aws.a(event)`，以免过早 CANCEL 破坏翻页/fling。

但 `aws` 仍只修改分页 holder 收到的事件副本，没有像当前 `awo` 补丁一样显式通知外层 `SoftKeyboardView`。因此它在现代 Android 上仍存在与旧 `awo` 相同的结构性风险。

## Gboard 的统一取消协议

Gboard 没有依赖“子 View 修改 MotionEvent 后外层自然看到变化”。它定义了明确的滚动取消回调：

- `rzb`：回调接口，方法 `a()`；
- `rzc`：可注册回调的滚动 View 接口，方法 `gs(rzb)`；
- 外层 `SoftKeyboardView` 实现 `rzb`；
- 建立/扫描键盘 View 树时，外层会为所有实现 `rzc` 的后代注册自己。

子滚动组件检测到拖动后调用 `rzb.a()`。外层只把布尔字段 `T` 设为 true。标准 View 分派返回后，`SoftKeyboardView` 检查 `T`，再将送往自定义按键管线的外层事件改为 `ACTION_CANCEL`。

这与当前 `ScrollTouchCompat` 静态状态桥的核心方向一致：**滚动状态必须显式从子容器传回外层，不能依赖 MotionEvent 对象身份。**

## Gboard 各容器的检测方式

### `ScrollViewInSoftKeyboard`

- 构造时读取 `getScaledTouchSlop()`；
- DOWN 记录本地 Y 并清空 dragging；
- MOVE 的 `abs(currentY - downY)` 超过 touch slop 后进入 dragging；
- dragging 期间每个 MOVE 都调用外层取消回调；
- UP/CANCEL 重置状态；
- 先调用 `ScrollView.onTouchEvent()`，再检测和回调，因此不破坏系统滚动与 fling。

Gboard 按“手指位移超过 slop”判断意图，并不要求 `scrollY` 已经实际变化。因此即使列表位于顶部/底部、发生 over-scroll，仍会取消按键点击。

### `PageableCandidatesHolderView` + `ohc`

`ohc` 是 Google 拼音 `aws` 的现代演进版本：

- 同样使用 `getScaledPagingTouchSlop()`；
- 同样按 X/Y 方向检测位移；
- 不再调用 `MotionEvent.setAction(CANCEL)`；
- 超过 slop 后调用注册的 `rzb.a()`；
- holder 仍保持“先 pager super、后检测器”的顺序。

这直接证明 Google 拼音 `aws` 当前缺少的不是 slop 算法，而是将“已滑动”显式通知外层软键盘的机制。

### `RecyclerViewInSoftKeyboard`

- 让 RecyclerView 自己处理 slop、拖动、速度和 fling；
- `onTouchEvent()` 后检查 RecyclerView scroll state；
- 状态为 `SCROLL_STATE_DRAGGING` 时调用外层取消回调。

Gboard 不重复实现 RecyclerView 的手势识别，只桥接已经确认的 dragging 状态。

### `BidiViewPager`

- 使用标准 ViewPager 处理触摸与分页；
- 页面开始产生滚动位置变化时调用外层取消回调；
- 注册回调时还扫描动态子 View，把同一回调传给内部可滚动组件。

### 表情分页

现代 Gboard 的 `PageableEmojiListHolderView` 使用 AndroidX `ViewPager2`，内部基于 RecyclerView；分页、slop、velocity 和 child CANCEL 主要由 AndroidX 实现。Gboard 的软键盘级回调协议仍用于阻止外层自定义按键管线把拖动解释成点击。

## 与当前补丁的对照结论

### 已经正确的部分

1. 当前补丁识别到了真正问题：现代 Android 的子事件副本与外层事件不是同一对象。
2. 当前补丁把取消动作放在标准 View 分派之后，保留 ScrollView 的 UP/fling；顺序与 Gboard 一致。
3. `ScrollTouchCompat` 显式桥接子滚动状态到外层，架构上与 Gboard 的 `rzc -> rzb -> SoftKeyboardView.T` 协议一致。
4. 没有向界面叠加额外触摸层，不改变原生布局、点击、主题和无障碍结构。

### 当前缺口

1. **只桥接了 `awo`。** 分页候选和全键盘符号使用的 `aws` 仍只修改自己的事件副本。
2. **`awo` 以实际 `scrollY` 变化作为判据。** 位于边界时即使手指明显拖动，`scrollY` 可能不变，外层点击仍可能未取消；Gboard 使用 touch slop 位移。
3. **全局布尔值只支持单一活动手势。** 对当前单指软键盘场景通常足够，但没有 pointer-id 隔离；Gboard 的外层管线本身维护多指状态。
4. **当前在 UP 才最终修改外层事件。** Gboard 在拖动 MOVE 阶段就向自定义管线发送 CANCEL，使按键状态更早结束。当前实现依靠 scrolling 持续到 UP，行为更保守，但按键视觉状态可能保持更久。
5. **没有独立覆盖 RecyclerView/ViewPager2。** Google 拼音目前主要使用旧 pager/ScrollView，不应为了模仿 Gboard而引入 AndroidX；只需覆盖实际存在的 `awo` 和 `aws`。

## 建议的最小修正方向

### 第一项：把 `aws` 接入现有状态桥

在 `aws` 确认超过 paging touch slop 时：

- 保留其现有 `setAction(CANCEL)`，避免改变 holder 内部行为；
- 同时调用 `ScrollTouchCompat.markScrolling()`；
- 让现有 `SoftKeyboardView` 在标准分派后取消外层自定义事件。

这会同时覆盖：

- 展开候选列表分页；
- 全键盘符号/表情分页；
- 所有复用 `PageableCandidatesHolderView` / `PageableSoftKeyListHolderView` 的布局。

### 第二项：谨慎评估 `awo` 判据

Gboard 证据支持使用 touch slop，而不是等待 `scrollY` 变化。若修改，建议使用不受子 View 坐标变换影响的 raw Y 位移：

- DOWN 保存 `getRawY()`；
- MOVE 比较 `abs(rawY - downRawY)` 与 `getScaledTouchSlop()`；
- 超过阈值后标记 scrolling。

但当前 `scrollY` 方案已经通过真机验证且左侧列表表现流畅。应先只修正明确缺失的 `aws` 桥接，再根据边界拖动测试决定是否改变 `awo`，避免一次扩大两个变量。

### 第三项：不重写 pager/fling

不建议自行实现速度追踪、页码阈值或 fling：

- 旧 pager 本身已经处理这些逻辑；
- Gboard 也让 ScrollView、RecyclerView、ViewPager 负责滚动动力学；
- 兼容层只应负责把“已经进入拖动”通知外层按键管线。

## V32 实施

V32 已按最小方案修改 `aws`：

- `aws` 在 MOVE 或 UP 确认超过 paging touch slop 时，额外调用 `ScrollTouchCompat.markScrolling()`；
- 保留原有 `MotionEvent.setAction(CANCEL)`；
- 不修改 `PageableCandidatesHolderView` 与 `PageableSoftKeyListHolderView` 的 `super -> aws detector` 顺序；
- 不修改 touch slop、方向、速度、翻页阈值、页码和 fling；
- 不调整已经通过真机验证的 `awo`/左侧竖向列表判据。

现有 `SoftKeyboardView` 会在标准 View 分派完成后读取桥接状态，并取消送往自定义按键管线的外层 UP。

## V32 真机结果

维护者完成 1–8 项简要回归后确认：

- 展开候选列表滑动不误选；
- 短距离点击、分页、fling、符号/表情点击均未发现新增问题；
- 左侧竖向符号列表保持轻松、流畅；
- 展开候选列表也容易滑动；
- 全键盘符号与表情的横向单指分页仍较吃力，经常回弹到原页。

最后一项不是 V32 外层取消桥造成：holder 会先完整执行 `lk.onTouchEvent()` 的 UP/velocity/settle，再由 `aws` 标记外层取消。V32 的状态桥发生在 pager 已决定目标页之后。

旧 `lk` 的目标页判定是：拖动距离超过 25dp 且速度超过系统 minimum fling velocity 时跨页；否则必须越过约 50% 页面才进入下一页。Gboard 的旧候选 pager `ckq` 保留了相同的 25dp、minimum velocity 和 50% settle 规则，但现代 Gboard 表情分页已经迁移到 AndroidX `ViewPager2`/RecyclerView。仅把 50% 猜测性降低会偏离现有 Gboard 证据，并可能造成轻微横移时意外翻页。

因此 V32 的误选修复可以独立保留；横向分页手感应作为旧 pager 现代化的独立任务，不与点击取消补丁混合。
