# Gboard 与 Google 拼音首次使用引导复核

## 范围

本次复核：

- 首次启动页面数组及页面数量；
- 启用输入法、选择输入法、权限、匿名指标和完成页面；
- 页面指示器与 ViewPager 状态；
- 从系统输入法设置和输入法选择器返回后的状态刷新；
- 完成、系统返回键和任务栈关闭行为；
- 明暗主题、系统栏和现有 MD3 资源覆盖；
- 使用独立 application ID 安装引导测试版，避免覆盖已验证的兼容版。

## Google 拼音旧实现

### 页面数组

原版包含三套数组：

- `activation_pages`：启用输入法、选择输入法；
- `first_run_pages`：启用、选择、权限、匿名指标、完成；
- `first_run_pages_without_permission`：启用、选择、匿名指标、完成。

`PinyinFirstRunActivity.a()` 根据 `activation_page` Intent extra 和权限列表选择数组。旧 activation 流程只创建两个页面；切换输入法状态后重新进入完整流程时，页面数和指示器会从 2 变化为 4/5。

### 页面状态

共享基类 `apr` 在页面获得 Window focus 时重新检查：

- 输入法是否已经启用；
- 当前输入法是否已经选中。

未完成时显示操作按钮，完成后隐藏按钮并显示带勾的完成状态。状态变为完成时会 post 页面推进任务。因此从系统设置或输入法选择器返回后，不需要轮询或重建 Activity。

### 起始页

`apy.onCreate()` 根据当前状态决定初始页：

1. 未启用：启用页；
2. 已启用但未选中：选择页；
3. 已选中：选择页的下一页。

这套逻辑要求页面数组中的启用页和选择页顺序稳定。

## 现有兼容补丁

此前补丁已经：

- 从完整数组和无权限数组中删除匿名指标页面；
- 强制使用完整流程，避免 activation 两页与完整流程页数切换；
- 修复 PageIndicator 数量和 selected/enabled 状态；
- 使用 `finishAndRemoveTask()` 处理完成按钮、底部关闭按钮和系统返回键；
- 删除完成页中进入旧功能介绍 Activity 的分支，只保留完成按钮；
- 在 API 35+ 使用独立日间/夜间颜色、圆角按钮、完成状态容器和新指示器资源。

## 当前 Gboard 对照

### 页面结构仍然延续旧架构

当前 Gboard：

- `LatinFirstRunActivity` 仍继承共享 FirstRunActivity；
- 仍使用 `BidiViewPager` 和 `PageIndicatorView`；
- `EnableStepPage` 和 `SelectInputMethodStepPage` 仍共享 StepPage 基类；
- StepPage 仍在 window focus 恢复时检查状态并切换按钮/完成视图；
- Activity 仍按“未启用 → 启用页；未选中 → 选择页；已选中 → 下一页”选择起始页；
- 仍保留 `activation_page` 与完整页面数组的区分。

因此 Google 拼音现有的状态检查和页面推进机制不需要重写。

### 当前标准完整数组只有三个页面

当前 Gboard 数组反编译结果：

- activation array：启用、选择，共 2 页；
- standard full array：启用、选择、完成，共 3 页。

共享框架中仍能看到 permission/user-metrics 的旧映射与类，但它们不再出现在标准完整数组中。权限由实际功能在需要时请求，匿名指标也不再作为标准首次启动步骤。

这说明此前只删除匿名指标、仍可能显示旧权限总览页的 Google 拼音流程还可以进一步收窄。

### 布局与样式

当前 Gboard 的启用和选择页仍使用：

- 顶部品牌 header；
- 居中的步骤标题和说明；
- 48dp 最小高度按钮；
- 操作按钮与“已完成”状态互斥显示；
- 底部 PageIndicator。

Google 拼音现有 API 35+ MD3 覆盖没有改变 View ID 或 StepPage 所需层级，保留了上述行为。它比当前 Gboard 反编译资源使用更明确的硬编码 day/night Material 配色，但没有引入动态颜色；这属于视觉选择，不影响状态逻辑。

## V37 调整

### 三步稳定流程

V37 将正常首次启动固定为：

1. 启用 Google 拼音输入法；
2. 选择 Google 拼音输入法；
3. 完成。

具体调整：

- 从 `first_run_pages` 删除 permission 和 user-metrics；
- `first_run_pages_without_permission` 同样为三页；
- `PinyinFirstRunActivity.a()` 始终返回三页数组；
- 不再读取 `activation_page` 或权限数组来改变页面数量。

保留权限页面类和布局，避免扩大删除范围，但正常流程不再引用它。

### 为什么不照搬 Gboard 的两页 activation array

当前 Gboard 框架已经继续演进，可以在其现代生命周期中处理 activation 流程。Google 拼音旧版 Activity 会在不同入口重新创建静态 pager；此前真机问题正是两页 activation 与后续完整数组不一致。

V37 保留已验证的稳定三页数组，不重新启用两页 activation 分支，只借鉴 Gboard“标准完整流程不含权限和指标页”的结论。

### 完成和返回

继续保留：

- 完成按钮 `finishAndRemoveTask()`；
- Activity 系统返回键 `finishAndRemoveTask()`；
- 不启动旧 `PinyinFeatureActivity`；
- 不落回启动引导前的设置页。

## 独立测试包

构建脚本新增可选 `ApplicationId` 参数。默认正式兼容包仍是：

```text
com.google.android.inputmethod.pinyin.compat
```

V37 引导测试版使用：

```text
com.google.android.inputmethod.pinyin.guideaudit
```

同步隔离：

- manifest package；
- 用户词典 Provider authority；
- `user_dictionary_authority` 字符串；
- 代码中的 application package 常量；
- app data、SharedPreferences、`HAD_FIRST_RUN` 和词典目录。

因此安装测试版不会覆盖 V36，也不会复用 V36 的首次启动完成状态或用户词典。系统“已启用输入法/当前输入法”是设备级状态，测试过程中选择测试输入法会临时改变系统当前输入法，但不会修改 V36 的应用数据。

## V37 真机反馈与 V38 修正

V37 的启用、选择和完成三步基本功能正常，但真机发现三项问题：

1. 已完成状态同时显示外层容器、圆形 check 背景和勾号，形成多余的双层底色；
2. 完成和返回只调用 `finishAndRemoveTask()` 仍会露出启动引导的应用设置页；返回键也缺少逐页后退；
3. 暗色模式指示器需要更明确的“当前页亮、其他页暗”层级。

V38 对应调整：

- 删除 check 自身的圆形 background，保留 24dp 勾号并按 `onPrimaryContainer` 着色，直接放在外层完成容器上；
- 返回键读取当前 `BidiViewPager` 页码：大于 0 时调用原生 pager 返回前一页，第一页才退出；
- 新增统一 `exitGuide()`：先启动 `ACTION_MAIN + CATEGORY_HOME`，再 `finishAndRemoveTask()`，确保完成或退出后显示桌面而不是应用设置；
- 指示器不再复用 primary/outline，改用独立 day/night 色。暗色 selected 为 `#E8F0FE`，unselected 为 `#5F6368`。

## V39 显式按钮导航

V38 返回和完成逻辑通过真机验证，但 PageIndicator 在设备上仍表现为当前项更暗。由于旧 `PageIndicatorView` 的 enabled-state、Drawable state 和现代资源着色组合已经没有继续保留的必要，V39 按维护者决定改为显式导航：

- 删除首次引导 footer 中的 PageIndicator；
- 使用 `NonSwipeableFirstRunViewPager` 阻止手指滑动翻页；
- footer 左下角为“上一步”，右下角为“下一步”；
- 第一页隐藏上一步，最后一页隐藏下一步；
- 两个按钮继承当前 `FirstRunPageButton` 的圆角、尺寸、字体和明暗主题；
- 当前 Enable/Select 功能未完成时禁用下一步；
- 点击页面主操作按钮并从系统界面返回后，保留当前页，只把下一步改为可用，不再自动推进；
- 系统返回键仍按 V38 逻辑返回前一页，第一页退出到桌面。

禁止滑动仅覆盖 first-run 专用 subclass 的 `onInterceptTouchEvent()` 与 `onTouchEvent()`，没有修改共享 `BidiViewPager`，也不影响符号、候选、功能介绍或其他 pager。

## V40 完成按钮统一

V39 的显式按钮导航视觉效果通过初步验证。V40 将最后一页中央的完成按钮移到与前两页下一步完全相同的右下角位置：

- 完成页内容区只保留完成标题；
- footer 右按钮在第一页、第二页显示“下一步”；
- footer 右按钮在最后一页显示“完成”；
- 从最后一页返回后，按钮文字恢复“下一步”；
- 最后一页点击右按钮调用 `exitGuide()`，前两页仍调用原生 pager 下一页；
- 最后一页左下角继续保留“上一步”。

这样三个页面都使用同一套固定 footer，不再混用内容区中央操作和 footer 导航。

## 待验证项目

1. 新测试包首次打开为三页流程且底部没有圆点指示器；
2. 第一页点击按钮能进入系统输入法设置；
3. 启用 guideaudit 输入法并返回后显示已完成状态，并自动进入第二页；
4. 第二页打开输入法选择器；
5. 选择 guideaudit 输入法后进入完成页；
6. 手指左右滑动不能切换页面；
7. 第一页只有右下角下一步，第二页有上一步/下一步，最后一页有上一步/完成；
8. Enable/Select 未完成时下一步呈禁用状态且不能点击；完成后停留当前页并解锁下一步；
9. 不出现权限总览页或匿名指标页；
10. 浅色和深色模式下标题、说明、按钮、禁用状态、完成状态和系统栏可读；
11. 最后一页中央不再有按钮，右下角完成按钮直接退出到桌面；
12. 完成或第一页返回时不暴露旧功能介绍页或设置页；
13. 第二/第三页按系统返回键回到前一页，第一页按返回键才退出到桌面；
14. 已安装的 `com.google.android.inputmethod.pinyin.compat` V36 数据和版本保持不变。
