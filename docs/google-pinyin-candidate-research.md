# Google 拼音 4.5.2 候选栏注入研究

## 目标

寻找一种不使用 `InputView`/`keyboard_area` 覆盖层、而是复用 Google 拼音原生候选栏来呈现剪贴板建议的方法。静态原型已完成真机验证，V22 开始接入动态剪贴板实现。

## 输入视图结构

`res/layout-v21/ims_input_view.xml` 的层级为：

```text
InputView (FrameLayout)
└─ keyboard_area (FrameLayout, bottom gravity)
   └─ keyboard_holder (vertical LinearLayout)
      ├─ header_group_view
      │  ├─ extension_header_view_holder
      │  └─ keyboard_header_view_holder
      └─ body_group_view
         ├─ keyboard_body_view_holder
         └─ extension_body_view_holder
```

`KeyboardViewHolder` 不是普通容器：它保存当前 keyboard view，并在 `dispatchTouchEvent()` 中将坐标转换后直接派发给当前 view。这说明把额外 View 加在 holder 之外或作为 holder 的非当前子项，都可能绕过框架的触摸分发。这正是外部 overlay 方案不可靠的根本原因之一。

## 原生候选栏一直存在于 PrimeKeyboard header

拼音全键盘配置 `res/xml/keyboard_zh_cn_pinyin_qwerty.xml` 使用：

```xml
<view layout="@layout/keyboard_prime_header" type="header">
```

`res/layout/keyboard_prime_header.xml` 同时 include：

- `keyboard_prime_header_inner`：普通工具栏；
- `keyboard_candidates_header_inner`：候选栏。

候选控制器不是临时创建浮层，而是在同一个 header view 内切换：

- `header_area`：普通 header；
- `heading_candidates_area`：候选 header。

混淆类 `asq`（`ICandidatesViewController` 实现）的 `b(boolean)` 会同步切换这两个区域，并调用 `maybeShowKeyboardView(HEADER)`。因此候选栏天然处于正确坐标、IME touchable region 和 `KeyboardViewHolder.dispatchTouchEvent()` 路径内。

## 标准候选数据链

完整路径为：

```text
IIme / decode processor
  → IImeDelegate.appendTextCandidates(...)
  → InputBundle.appendTextCandidates(...)
  → active IKeyboard.appendTextCandidates(...)
  → PrimeKeyboard
  → ICandidatesViewController (asq)
  → FixedSizeCandidatesHolderView / PageableCandidatesHolderView
  → SoftKeyView
```

关键公开入口：

```text
InputBundle.appendTextCandidates(List<Candidate>, Candidate selected, boolean hasMore)
InputBundle.textCandidatesUpdated(boolean)
InputBundle.commitText(CharSequence, boolean, int)
```

当前活动的 `InputBundle` 可以通过 `GoogleInputMethodService.a()` 取得。该方法返回 `InputBundleManager` 的 active bundle，而不是 previous/last bundle。

## Candidate 模型

`com.google.android.apps.inputmethod.libs.framework.core.Candidate` 已经具备实现剪贴板候选需要的字段：

- 主显示文本 `CharSequence`；
- 辅助文本/说明；
- content description 字符串；
- `Candidate$b` 类型；
- 任意 `Object` payload；
- 可删除、选中等状态位。

`Candidate$a` 是 builder。可使用独立 payload 类型标记剪贴板候选，而不需要修改 Candidate 枚举。

候选绑定类 `avp` 会把 Candidate 转换成原生 `SoftKeyDef`：

1. 创建 `PRESS` action；
2. action keycode 为 `-0x2712`，payload 就是 Candidate；
3. 将 Candidate 主文本绑定到候选 label；
4. 将 Candidate 说明绑定到 content description；
5. 使用现有候选 layout 和背景 attr 创建 `SoftKeyView`。

因此不需要自行实现 OnClickListener，也不需要直接操作 InputConnection。

## 原生布局、主题和交互

候选 header 使用：

```text
FixedSizeCandidatesHolderView
candidate_layout = @layout/softkey_candidate
candidate_background = @attr/BgCandidate
last_column_candidate_background = @attr/BgCandidateLastColumn
```

`softkey_candidate.xml` 已包含：

- 候选背景；
- 分隔线；
- 自动缩放的单行文本；
- ordinal/deletable 辅助标签；
- 原生按压、选中和可访问性状态。

候选绑定器通过当前 keyboard theme context 解析 `BgCandidate`、`BgCandidateLastColumn`、`ColorLabelCandidate` 等属性。这里没有读取系统 `uiMode`，也没有硬编码浅色/深色颜色。因此只要进入这条原生路径，主题问题会自然解决。

候选项最终是 `SoftKeyView`，其点击由 `SoftKeyboardView`/`ICandidatesViewController` 处理，触摸坐标由 `KeyboardViewHolder` 转换。这会自然解决 overlay 无法点击的问题。

## 未布局时也支持排队

`asq.appendTextCandidates()` 已考虑 input view 尚未完成测量的情况：

- 若 `FixedSizeCandidatesHolder` 还没 ready，会缓存候选列表、selected candidate 和 hasMore；
- 同时请求显示候选 header；
- `asr.onReady()` 在 holder 有尺寸后自动重新 append。

所以未来的静态原型可以在 `onStartInputView` 后提交一个标准 Candidate，无需 post 固定延迟，也不需要猜测候选栏坐标。

## 点击路径与必须处理的风险

候选点击并非只有一条路径：

1. 一部分选择会调用 `InputBundle.selectTextCandidate()`；
2. SoftKey action 也可能通过 `dispatchSoftKeyEvent()` 进入 `InputBundle` 的内部 Event 分派，再直接调用当前 `IIme.selectTextCandidate()`；
3. 物理键/方向键选中也会生成包含 Candidate 的 `-0x2712` Event。

普通拼音 Candidate 的 payload 是 HMM candidate index。若把自定义 payload 直接交给 HMM，`HmmEngineWrapper.selectCandidate()` 会因 payload 不是 `Integer` 抛出 `IllegalArgumentException`。

因此未来实现必须在所有 `-0x2712` Candidate 进入 IIme 之前识别剪贴板 payload，并改走：

```text
InputBundle.commitText(suggestion, ...)
```

不能只给 View 设置点击监听器，也不能只拦截 `InputBundle.selectTextCandidate()` 一个方法。

另一个可研究方向是构造 `APP_COMPLETION` Candidate，让已有 AppCompletionsHelper 提交文本。但这条路径受 EditorInfo completion 模式、异步 IME 和不同语言 IME 实现影响，作为通用剪贴板机制风险高于显式 payload 拦截。

## 与原生候选流合并

直接在 input start 时 append 一个剪贴板 Candidate 可以在空闲状态显示，但正常输入开始后，IME 会调用：

```text
textCandidatesUpdated(true)
requestCandidates(...)
appendTextCandidates(...)
```

候选控制器会清空并重建候选。因此正式实现不能只在启动时 append 一次。

较稳妥的模型是：

1. helper 只维护当前允许展示的 Clipboard Candidate model，不拥有任何 View；
2. 在 `InputBundle.appendTextCandidates()` 的**每个新候选周期首批数据**中装饰候选列表，将 Clipboard Candidate 放到合适位置；
3. 后续分页 append 不重复插入；
4. `textCandidatesUpdated(false)`、输入会话结束、点击成功或过期时撤销；
5. clipboard 更新后触发一次受控的候选刷新，而不是直接改 holder；
6. 在有拼音 composing 时避免破坏当前 selected/raw Candidate；
7. 点击后通过 payload 标记提交并让候选控制器进入正常清理流程。

需要额外维护“本轮候选是否已注入”的状态，并在 `textCandidatesUpdated(...)` 时重置。否则多批 `appendTextCandidates()` 会产生重复 clipboard candidate。

## 可行性判断

### 已确认可复用

- 原生候选 header；
- 拼音全键盘使用 `PrimeKeyboard`，九宫格/笔画的 `T9Keyboard` 和手写的 `HandwritingPrimeKeyboard` 都继承 `PrimeKeyboard`，因此共享同一候选控制器；
- Candidate builder；
- FixedSize/Pageable candidate holder；
- SoftKey 触摸和可访问性；
- 键盘主题属性；
- holder 未 ready 时的排队机制；
- InputBundle 的 commitText 通道。

### 尚需验证

- 空闲状态注入后普通 header 与候选 header 的切换体验；
- 全键盘、九宫格、手写和英文主键盘已确认走 PrimeKeyboard/asq，但符号键盘 `SymbolsKeyboard` 直接继承基础 `Keyboard`；切到符号/表情页时应继续保留、暂时隐藏还是返回主键盘后恢复，仍需真机确定；
- composing 期间剪贴板候选应放首位、末位还是暂时隐藏；
- 物理键候选选择时的 payload 拦截覆盖率；
- 点击提交后应调用哪些候选状态清理方法，才能不影响 HMM composing；
- 验证码提取结果与完整剪贴板文本的 dismissed key 应分开保存。

## 静态原型验证结果

项目维护者已在真机完成最小静态原型验证：

- `123456` 候选显示位置正确；
- 点击可正常上屏；
- 英文模式正常；
- 手写笔画模式正常。

因此 V22 已进入动态实现阶段：接入 `ClipboardManager`、两分钟时效、敏感剪贴板与密码输入框过滤、候选周期合并，以及输入视图结束时的监听器清理。早期版本曾包含验证码提取，但 V25 已按产品需求完整移除；候选现在只做显示摘要截断，上屏内容始终忠实使用完整剪贴板原文。后续真机测试统一由项目维护者执行。
