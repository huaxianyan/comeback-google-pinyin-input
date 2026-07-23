# Gboard 系统虚拟导航键与导航栏研究

## 范围

本文中的“虚拟键”指 Android 屏幕底部的系统导航区域，包括三键导航按钮、手势导航条、导航栏背景、分隔线和图标明暗，不是输入法内部的 `SoftKeyView`。

研究样本仍为 Gboard `17.7.5.932364120-release-arm64-v8a`，重点类为：

- `qgw`：IME 导航栏状态协调器；
- `qgs`：根据 API、编辑器、键盘 surface 和主题生成并应用状态；
- `qgu` / `qgv`：导航栏状态 builder/model；
- `qgt`：由 IME/InputView 实现的底部 frame 与系统 UI 桥；
- `bmx` / `bmy` / `bmz`：不同 Android API 的 system bar appearance 兼容层；
- `eht`：Gboard IME 生命周期和 InputView 侧协调逻辑。

## Gboard 的状态模型

Gboard 不把导航栏适配简化成“浅色主题写一个颜色、深色主题写另一个颜色”。`qgv` 明确保存五类状态：

1. navigation bar color；
2. navigation bar divider color；
3. 可选的 bottom frame color；
4. 可选的另一个输入视图边缘/frame color；
5. `isLightNavBar`，即是否使用深色系统导航图标。

`qgu` builder 要求颜色、divider 和 icon appearance 都已提供，否则拒绝生成状态。这说明 Gboard 将系统栏视为键盘 surface 的一部分，而不是一次性的 Window 修补。

## 颜色来源

Gboard 的正常路径从当前 `SoftKeyboardView`/stylesheet context 取得实际颜色 token，再传给 `qgs`：

- 优先读取当前键盘 surface 对应的 `ColorStateList`；
- 只接受 alpha 为 255 的最终导航栏颜色；
- 透明或不存在的 token 会进入当前 surface、浮动键盘和 API 版本对应的 fallback；
- Android 28 有单独兼容分支，可使用白色导航栏和约 `#FFE0E0E0` divider；
- Android 29+ 使用当前键盘 surface 的真实主题色，而不是根据主题名称猜测；
- 浮动模式可选择透明导航栏，并同步处理底部 frame。

这和 Gboard chip 研究得到的结论一致：颜色来自键盘 stylesheet 的最终 surface token，不来自系统 `uiMode`，也不依靠名字包含 `light`/`dark`。

## 图标明暗兼容

Gboard 为不同 API 选择不同实现：

- 旧 API 使用 `decorView.systemUiVisibility`；
- Android 30+ 使用 `WindowInsetsController.setSystemBarsAppearance()`；
- Android 35+ 走单独实现，但 appearance bit 仍明确按 mask 设置；
- 在应用 Window 状态后，还会把兼容 system UI flag 同步给 InputView 侧。

导航栏图标和背景颜色属于同一个 model，避免出现浅背景配浅色按钮或深背景配深色按钮。

## 三键导航、手势导航和可见性

Gboard 还处理以下状态，而当前 Google 拼音补丁没有覆盖：

- `FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS` 的启用/撤销；
- API 34+ 通过 `WindowInsetsController` 显示或隐藏 navigation bars；
- 浮动键盘是否使用透明导航栏；
- `setNavigationBarContrastEnforced()` 与 InputView/edge-to-edge 状态联动；
- 键盘 bottom frame 与系统导航区域颜色同步；
- `com.android.systemui` 编辑器和 Android 28 的特殊兼容分支；
- Window、EditorInfo、InputView 或 theme surface 变化后重新计算 model，而不是盲目重复写常量。

## Google 拼音原始实现

Google 拼音 4.5.2 的 `GoogleInputMethodService` 在 header/body/extension 可见性变化时执行以下逻辑：

1. 首次记录 Window 原有的 navigation bar color 到字段 `d`；
2. 根据键盘区域是否可见，在原色和透明色 `0` 之间切换；
3. 不管理 divider；
4. 不管理浅色导航图标；
5. 不理解现代手势导航、contrast enforcement 或 WindowInsetsController。

在 targetSdk 28 + Android 16 上，旧框架写入透明色后会出现黑色导航区域，这是早期兼容补丁要解决的直接问题。

## 当前 `NavigationBarCompat` 评估

### 已正确解决的部分

- 在 `onStartInputView()` 后重新设置导航栏；
- 在旧框架候选/header 更新并改写导航栏后重新应用；
- API 26+ 能同步浅色/深色导航图标；
- API 28+ 同步 divider；
- API 29+ 关闭系统强制对比度蒙层；
- 内置 Material Light (`#FFECEFF1`) 和 Material Dark (`#FF263238`) 与原资源颜色一致；
- 已在当前测试设备和内置浅/深主题下解决黑色导航栏问题。

### 基础层面的不足

1. **通过 cache key 名称猜主题。**
   当前代码查找 `light`、`white`、`dark`、`black`、`holo_blue`。Google 拼音还提供 red、pink、green、cyan、blue grey、deep purple、Google blue 等额外 stylesheet。比如 red theme 使用白色标签和红色 surface，但名称不含 `dark`，当前逻辑会错误设置浅灰导航栏和深色虚拟键。

2. **背景只有两个硬编码值。**
   额外彩色主题、bordered theme、无背景主题和未来动态 surface 都无法匹配。Gboard 使用当前 View stylesheet 的实际最终颜色。

3. **divider 被设置成与导航栏完全相同。**
   这能隐藏接缝，但不是 Gboard 的独立 divider model；亮色三键导航下可能需要轻微分隔色。

4. **只使用旧 `systemUiVisibility`。**
   Android 30+ 仍通常兼容该 flag，但 Gboard 已使用 `WindowInsetsController` 并按 mask 修改 appearance，现代实现更明确，也更不容易覆盖其他 system UI bit。

5. **无导航模式和浮动状态。**
   当前代码不区分三键导航、手势导航、浮动键盘和透明 bottom frame。

6. **无 bottom frame 同步。**
   只写 Window navigation bar，未将键盘底部实际 View surface 纳入同一个状态；在 edge-to-edge 或手势区域策略变化时可能出现接缝。

7. **无条件关闭 contrast enforcement。**
   当前设备上可避免系统灰黑蒙层，但 Gboard 会根据 InputView/edge-to-edge 状态动态决定。无条件关闭不是最稳妥的通用规则。

8. **更新机制是补写而非状态协调。**
   目前依赖 `onStartInputView` 和旧私有方法中的一个插桩点。主题、Window attach、导航模式或其他 surface 改变时没有统一的 model 和去重逻辑。

## 结论

当前补丁是一个针对 Pixel 10 Pro、Android 16 和内置 Material Light/Dark 的有效修复，但还不能评价为“已经按 Gboard 思路实现得很好”。它解决了已观察到的黑栏问题，却没有建立 Gboard 那种以实际键盘 surface 为来源的系统栏状态模型。最大的潜在未知问题是额外彩色主题会被错误分类。

## 建议的后续重构顺序

1. [V27 已实现第一阶段] 从当前已渲染 keyboard body View 解析**实际 surface color**；body 暂不可用时读取 keyboard area，并仅在两者都无法给出不透明颜色时回退到 cache key 名称；
2. 用背景颜色亮度计算 `isLightNavBar`，并让图标 appearance 与颜色作为一个状态更新；
3. 独立计算 divider color；
4. API 30+ 改用 `WindowInsetsController.setSystemBarsAppearance()`，旧 API 保留 `systemUiVisibility` fallback；
5. 识别三键/手势导航和浮动键盘，只在合适模式处理透明度与 contrast enforcement；
6. 同步键盘 bottom frame，消除 Window 导航区和输入 View 之间的接缝；
7. 将更新集中到一个有缓存、可重复调用的 state coordinator，并覆盖 input start、theme/surface 改变和旧框架可见性更新。

V27 的首次真机主题切换结果仍只出现两套兜底颜色。进一步确认 Google 拼音 stylesheet 不会直接改写 XML `GradientDrawable` 的 solid color，而是用自定义 `bam` Drawable 包装原背景，并将最终主题 tint 保存在其公开 `ColorStateList` 中。V27 未识别该包装类型，因此 body 和 keyboard area 都返回无效颜色，确实全部进入了名称 fallback。

V28 已优先读取 `bam` 当前 state 对应的最终颜色，之后才处理 Android 标准 Drawable；名称判断仍只作为真正的早期生命周期 fallback。当前仅替换颜色来源和图标亮度输入，divider、WindowInsets、导航模式与 contrast enforcement 尚未改变。
