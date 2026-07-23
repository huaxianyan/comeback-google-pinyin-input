# Gboard 与 Google 拼音手写 Canvas 兼容研究

## 范围

本次复核以下路径：

- Google 拼音 `HandwritingOverlayView` 的离屏 Bitmap/Canvas 生命周期；
- 笔迹渲染器 `ayc` 的 pen down/move/up；
- 手写状态管理器 `aye` 的清屏；
- Android 16 禁止 `Region.Op.REPLACE` 后的现有兼容补丁；
- Gboard 当前 `HandwritingOverlayView` 与渲染器 `nnr`；
- MotionEvent、历史采样、pressure、多指和 JNI 识别路径是否受到补丁影响。

本阶段只调查，不修改已经通过真机验证的手写行为。

## 原始崩溃

Pixel 10 Pro / Android 16 首次落笔时的实际异常为：

```text
java.lang.IllegalArgumentException:
Invalid Region.Op - only INTERSECT and DIFFERENCE are allowed
    at android.graphics.Canvas.clipRect(Canvas.java:874)
    at ayc.drawPenDown(PG:38)
```

旧代码使用 `Canvas.clipRect(..., Region.Op.REPLACE)`。现代 Android 不再允许通过该 API 使用 REPLACE、UNION、XOR 等操作，只允许 INTERSECT 和 DIFFERENCE。

这不是：

- 原生识别库崩溃；
- 16 KiB page-size 问题；
- 手写模型损坏；
- 硬件加速 Canvas 不支持 Paint；
- MotionEvent 坐标异常。

崩溃发生在第一个点进入 JNI 识别之前的 Java 绘制阶段。

## Google 拼音旧渲染架构

### 离屏画布

`HandwritingOverlayView`：

1. 按 View 宽高创建 `Bitmap.Config.ALPHA_8` Bitmap；
2. 使用 `new Canvas(bitmap)` 创建软件离屏 Canvas；
3. `ayc` 将笔迹逐点画入该 Bitmap；
4. `invalidate(dirtyRect)` 只重绘受影响区域；
5. View 的 `onDraw()` 将整个离屏 Bitmap 贴到最终 View Canvas。

最终 View Canvas 可以是硬件加速的，但实际可变宽度笔迹是在 Bitmap-backed 软件 Canvas 上生成。当前补丁没有切换 layer type，也没有改变硬件加速策略。

### Pen down/move/up

`ayc` 实现 `IStrokeRenderer`：

- down：计算压力相关宽度和 dirty RectF，画圆形起点；
- move：根据前后点和压力计算宽度，用二次 Path 绘制平滑线段；
- up：完成最后线段并画圆形端点；
- 每次返回 dirty RectF，供 OverlayView 局部 invalidate。

Paint 使用：

- anti-alias；
- ROUND cap/join；
- `PorterDuff.Mode.SRC`；
- pressure/width scale；
- STROKE/FILL 按阶段切换。

### 识别与绘制分离

`HandwritingMotionEventHandler`：

- 复制并转换 MotionEvent 到 Overlay 坐标系；
- 维护 active pointer id；
- 读取 historical X/Y、event time 和 pressure；
- 将同一批点送给绘制器和 Stroke 数据结构；
- 后续由 WordRecognizer/HMM JNI 处理 Stroke。

因此“识别正常但笔迹不可见”可以发生：Stroke/JNI 数据仍然完整，只是离屏 Canvas 的 clip 被错误缩小。

## 当前兼容补丁的六处 REPLACE

补丁将六处 `Region.Op.REPLACE` 改成 `INTERSECT`：

1. `ayc.drawPenDown()`；
2. `ayc.drawPenMove()`；
3. `ayc.drawPenUp()`；
4. `aye` 全画布清屏；
5. `HandwritingOverlayView` 清屏并重放旧 strokes；
6. `GestureOverlayView$a` 滑行轨迹局部清理。

第 1–3 处还在每次 clip/draw 前后增加 `Canvas.save()` / `Canvas.restore()`。

## 为什么仅替换成 INTERSECT 会导致笔迹不可见

REPLACE 的旧语义是“本次 clip 替换此前 clip”。每个点都可以使用自己的 dirty rect。

INTERSECT 的语义是“本次 clip 与此前 clip 取交集”。如果连续执行：

```text
clip(point1Rect)
clip(point2Rect)
clip(point3Rect)
```

clip 会不断缩小；相邻 dirty rect 一旦没有交集，后续 clip 为空，识别继续但 Bitmap 上几乎不再出现笔迹。

当前 `ayc` 补丁把每次操作隔离为：

```text
save
clipRect(INTERSECT)
draw
restore
```

每个点都从 Canvas 原有完整 clip 开始，恢复了旧 REPLACE 在该使用场景下的有效语义。

## Gboard 当前实现

### 整体架构仍然相似

Gboard 当前 `HandwritingOverlayView` 将绘制委托给 `nnr`：

- 仍维护离屏 Bitmap 和 Bitmap-backed Canvas；
- 手写模式仍使用 `Bitmap.Config.ALPHA_8`；
- onDraw 仍把离屏 Bitmap 贴到 View Canvas；
- Bitmap 扩容时仍保留旧内容；
- down/move/up 仍返回 dirty RectF 并局部 invalidate。

因此当前 Google 拼音的 Bitmap Canvas 架构本身并不是需要删除的过时错误。

### Gboard 不使用 Region.Op.REPLACE

Gboard `nnr` 的 down/move/up 都采用：

```text
canvas.save()
canvas.clipRect(dirtyRect)   // 默认 INTERSECT，无 Region.Op 参数
canvas.drawCircle/drawPath(...)
canvas.restore()
```

对应位置：

- `nnr.l()`：pen down；
- `nnr.m()`：pen move；
- `nnr.n()`：pen up。

这与当前 Google 拼音补丁对 `ayc` 的 save/clip/draw/restore 结构完全一致。现有修复不是临时猜测，而是在旧渲染器上回移了当前 Gboard 的 Canvas 状态隔离方式。

### 清屏

Gboard `nnr.e()` 清空离屏 Bitmap 时也使用：

```text
save
clipRect(fullBounds)
drawColor(CLEAR)
restore
```

当前 Google 拼音 `aye` 和 `HandwritingOverlayView` 的两处 full-bounds 清屏虽然已将 REPLACE 改成 INTERSECT，但没有配对 save/restore。由于 `ayc` 每点现在都会恢复状态，正常情况下这两处 clip 等同于完整 Canvas bounds，不会继续缩小，真机也未发现问题；不过 Canvas 状态管理仍不如 Gboard 对称。

### 现代 stylus 低延迟路径

Gboard另有 `LowLatencyHandwritingOverlayView`，用于现代 stylus/系统手写场景，采用独立的低延迟绘制路径。它不等同于键盘内部用手指书写的 `HandwritingOverlayView`，不能在当前 smali 补丁中直接替换旧架构。是否采用该路径应留到 target API 与 stylus 功能现代化阶段。

## 当前补丁审计结论

### 已确认正确

1. 崩溃根因定位准确：`Region.Op.REPLACE`。
2. `ayc` 三个绘制入口都已覆盖，没有遗漏 down/move/up。
3. save/restore 的位置正确：clip 之前 save、绘制之后 restore。
4. 三条路径没有在 save 与 restore 之间提前 return 或正常分支跳出。
5. Gboard 当前实现使用相同的 save/default-INTERSECT/draw/restore 模式。
6. ALPHA_8 离屏 Bitmap、局部 invalidate 和 pressure-based width 与 Gboard仍一致。
7. 补丁不修改 MotionEvent、历史点、pointer id、Stroke 数据或 JNI 调用。
8. 真机已经验证笔迹显示、中文识别和候选上屏。

### 可改进但非故障

1. `ayc` 仍调用带 `Region.Op.INTERSECT` 参数的 deprecated overload；Gboard 使用无 Region.Op 的 `clipRect(RectF)`。
2. `aye` 与 `HandwritingOverlayView` 两处 full-bounds clear 没有 save/restore，虽当前 clip 为完整 bounds，状态管理不完全对称。
3. 第六处 `GestureOverlayView$a` 属于滑行轨迹而非手写；它原本已有 save/restore，只需保留 INTERSECT 替换。
4. 16 KiB page-size 只关系后续 JNI/native 库验证，与 Canvas 修复无关。

## 风险评估

当前手写补丁风险较低：核心三处与 Gboard 现行实现一致，并已真机验证。

不建议：

- 改成硬件 Canvas 直接逐点绘制；
- 强制 `setLayerType(SOFTWARE)`；
- 替换 Bitmap.Config；
- 重写 pressure、Path 平滑或 dirty rect 算法；
- 引入 Gboard stylus 低延迟层；
- 修改 JNI Stroke 数据。

这些变更回归面大，且没有解决当前已知问题的必要性。

## 建议下一步

建议做一个非常窄的 Canvas 状态整理版：

1. 将 `ayc` 三处 `clipRect(RectF, INTERSECT)` 改为 Gboard 同款 `clipRect(RectF)`，保留现有 save/restore；
2. 为 `aye` 全画布 clear 增加 save/restore，并改用不带 Region.Op 的 `clipRect(FFFF)`；
3. 为 `HandwritingOverlayView` 清屏/重放路径增加 save/restore，仅包围 full-bounds clip + CLEAR，再执行旧 stroke 重放；
4. 不修改 gesture overlay、绘制算法、Bitmap、MotionEvent 或 JNI。

但因为当前版本已经稳定，这一整理的收益主要是移除 deprecated Region.Op API 和实现 Canvas 状态对称，并非修复用户可见故障。可选择直接冻结现有补丁，也可制作独立小版本验证清屏、重放和连续多字书写。
