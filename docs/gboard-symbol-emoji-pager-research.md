# Gboard 与 Google 拼音全键盘符号/表情横向 Pager 手感研究

## 范围

本任务与 V32 的“滑动后取消误选”分离，只研究：

- Google 拼音全键盘符号、表情和颜文字的横向分页为何容易回弹；
- 当前目标页、fling、touch slop 与速度判定；
- Gboard 当前符号/表情容器的实现；
- 是否存在不影响候选分页和点击稳定性的局部改进。

当前阶段只调查，不修改 pager 参数。

## Google 拼音实际界面路径

手机布局中的三个界面分别为：

- `keyboard_non_prime_symbol_body.xml`；
- `keyboard_non_prime_smiley_body.xml`；
- `keyboard_non_prime_emoticon_body.xml`。

三者都使用：

`PageableRecentSubCategorySoftKeyListHolderView`
→ `PageableSoftKeyListHolderView`
→ 混淆基类 `lk`
→ `ViewGroup`

`lk` 日志名称为 `FourDirectionalView`，本质是 Google 输入法旧框架中的多方向 ViewPager 实现。它负责手势拦截、拖动、VelocityTracker、目标页计算、Scroller 动画和 edge effect。

V32 修改的 `aws` 只在 `lk.onTouchEvent()` 完整处理事件之后运行。因此 V32 会取消外层按键释放，但不会改变 `lk` 已经计算出的目标页。

## 当前 `lk` 的手势参数

### 开始拖动

- 使用 `ViewConfiguration.getScaledPagingTouchSlop()`；
- 水平位移必须大于 paging touch slop；
- 水平位移还必须大于垂直位移；
- 满足后 pager 才进入 dragging。

### 松手目标页

UP 时先使用 VelocityTracker 计算当前指针速度。

若同时满足：

1. 从初始触点到松手位置的绝对距离大于 `25dp`；
2. 绝对速度大于系统 `getScaledMinimumFlingVelocity()`；

则按速度方向切换到相邻页。

否则进入位置判定：

- 当前页偏移超过约 50% 才进入下一页；
- 未超过 50% 就回弹到原页。

这与真机现象一致：慢速单指滑动如果没有越过半页，很容易回弹；只有明确、快速的 fling 才能用较短距离换页。

## 与候选展开列表的差异

展开候选列表“滑起来轻松”不能直接证明同一 pager 参数正常：

- 部分候选区域是连续 ScrollView/候选容器，不需要跨过整页 settle 阈值；
- 即使使用 `PageableCandidatesHolderView`，页面尺寸、方向、内容布局和用户手势速度也不同；
- 全键盘符号/表情每页接近整个输入区域宽度，50% 位置阈值在视觉和手指距离上更明显。

## Gboard 当前实现

### 表情分页

Gboard `PageableEmojiListHolderView` 不再使用旧 `FourDirectionalView`。它 inflate 的页面容器是：

`androidx.viewpager2.widget.ViewPager2`

布局明确设置水平 orientation，并配置：

- RecyclerView-backed pager；
- offscreen page limit；
- page margin；
- AndroidX 的触摸、velocity、snap 和 child-CANCEL 管线。

因此现代 Gboard 表情分页手感来自 ViewPager2/RecyclerView 的整体实现，不是对旧 `lk` 单个常量的修改。

### Rich Symbols

现代 Gboard Rich Symbols 使用：

- `CategoryViewPager` 负责大类导航；
- `RichSymbolRecyclerView` / BindingRecyclerView 展示符号网格；
- 手机和 tablet 有独立 keyboard/controller 实现。

其内容浏览更多依赖 RecyclerView 与类别切换，不再等价于 Google 拼音“每屏固定网格、整页横向翻动”的旧模型。

### 旧候选 pager

Gboard 中仍保留的旧候选 pager `ckq` 可以看到与 `lk` 相同的：

- 25dp fling distance；
- 系统 minimum fling velocity；
- 非 fling 时约 50% settle。

这说明不能以“Gboard旧候选 pager 也使用 50%”推导出现代符号/表情仍应使用旧手感；Gboard 已经把真正的表情/富符号界面迁移到 RecyclerView/ViewPager2。

## 可选改进及风险

### 方案 A：直接降低 50% settle

例如仅对符号/表情改为 35%。

优点：慢速拖动更容易换页。

风险：

- 缺少 Gboard 对应常量证据；
- 轻微横向移动更容易意外翻页；
- 必须保证只作用于 `PageableRecentSubCategorySoftKeyListHolderView`，不能影响候选 pager；
- `lk` 的目标页方法是 private，局部覆写不直接可用，需要在共享基类加入类型分支。

当前不建议首先采用。

### 方案 B：只改善 fling 判定

保留 50% 位置阈值，但让明确快速滑动更容易进入 velocity 路径，例如只针对符号/表情重新评估 25dp 额外距离门槛。

优点：

- 慢速小位移仍回弹，不容易误翻；
- 更接近 ViewPager2/RecyclerView 以 fling + snap 为主的交互；
- 变更可限定在符号/表情 subclass。

风险：仍需确认真机失败手势究竟是速度不足、25dp 距离不足，还是 pager 没有进入 dragging。没有诊断数据时直接改阈值仍属于猜测。

### 方案 C：迁移 ViewPager2/RecyclerView

最接近现代 Gboard，但对当前项目不是小补丁：

- 原 APK 没有现成 AndroidX ViewPager2 集成路径；
- 需要重做 adapter、页面缓存、类别状态、最近使用项、SoftKeyView listener、无障碍和生命周期；
- smali 层回归面过大；
- 更适合 target API 与渲染框架现代化阶段。

当前不实施。

## 推荐下一步：先做诊断版

在不改变行为的前提下，只针对 `PageableRecentSubCategorySoftKeyListHolderView` 记录一次 UP 决策所需数据：

- 是否进入 dragging；
- 总水平位移；
- X velocity；
- minimum fling velocity；
- 当前页面偏移比例；
- 最终目标页。

由维护者分别复现“成功翻页”和“回弹”手势，再根据数据决定：

- 若经常未进入 dragging：调查方向竞争和 paging touch slop；
- 若位移超过 25dp 但速度不足：不应降低 distance，应评估 velocity；
- 若速度足够但距离不足：可考虑只移除符号/表情的 25dp 双重门槛；
- 若两者都不足且偏移常在 35%–50%：才考虑局部降低 settle 阈值。

这样可以避免凭手感猜常量，也避免影响已经通过 V32 验证的点击取消与候选分页。

## V33 诊断版

V33 已实现上述无行为修改的诊断：

- 只在 `lk` 的 UP 目标页计算路径插入只读调用；
- `PagerDiagnosticsCompat` 通过 `instanceof PageableRecentSubCategorySoftKeyListHolderView` 排除候选 pager 和其他 `lk` 使用者；
- 不修改任何 `lk` 字段、MotionEvent、阈值、velocity、target 或 Scroller 调用；
- 日志 tag 为 `GPPagerDiag`；
- 每次有效拖动松手记录 current、target、changed、offset、distance、25dp threshold、velocity、minimum velocity、fling 与最终 page/snap_back。

APK 安装后已清空 Logcat。维护者需要在全键盘符号/表情界面分别复现数次成功翻页和回弹，然后由编码代理读取 `GPPagerDiag` 数据。
