# Android 16/17 兼容性记录

## 基础版本

- 原版 package：`com.google.android.inputmethod.pinyin`
- Compatibility v10+ package：`com.google.android.inputmethod.pinyin.compat`
- versionName：`4.5.2.193126728-arm64-v8a`
- versionCode：`4520313`
- minSdk：17
- targetSdk：26
- 架构：arm64-v8a

## 原生库

| 文件 | AArch64 | LOAD alignment |
|---|---:|---:|
| liben_data_bundle.so | 是 | 64 KiB |
| libgnustl_shared.so | 是 | 64 KiB |
| libhmm_gesture_hwr_zh.so | 是 | 4 KiB |
| libhwrword.so | 是 | 64 KiB |
| libpinyin_data_bundle.so | 是 | 64 KiB |

`libhmm_gesture_hwr_zh.so` 同时包含 HMM、滑行输入和中文手写 JNI。拼音能够工作说明该库至少可以被加载，但不能排除其手写路径存在 16 KiB page-size 或旧 native 实现问题。

## 导航栏问题

旧框架在 `GoogleInputMethodService` 更新候选区/扩展区可见性时，会把导航栏颜色恢复为透明色 `0`。targetSdk 28 下，Android 16 会把该区域呈现为黑色。

补丁在以下时机重新应用主题颜色：

1. `PinyinIME.onStartInputView()` 后；
2. 旧框架调用 `Window.setNavigationBarColor()` 后。

## 滑动事件与高刷新率

九宫格左侧的 `ReadingTextCandidateHolderView` 继承自混淆类 `awo`（`ScrollView`）。旧实现仅在 `onTouchEvent()` 中把事件交给 `GestureDetector`，但手势开始时事件通常由子 `SoftKeyView` 持有，导致检测器漏掉 `DOWN`。此外，`SoftKeyboardView` 在标准 View 分派后还会通过 delegate/motion handler 再处理同一个事件。真机进一步确认列表本身能够滚动，误选固定发生在松手时，并选择手势起点处原先按住的候选或标点；官方原版在 Android 16 上也有完全相同的问题。旧代码隐含假设内部 `ScrollView` 和外层 `SoftKeyboardView` 操作同一个 `MotionEvent` 对象，但现代 Android 在向子 View 做坐标变换和分派时会使用事件副本。结果是内部 `awo` 即使把自己的释放副本改成 `ACTION_CANCEL`，之后运行的外层自定义按键管线仍收到原始 `ACTION_UP`。v11 在 `awo` 检测到超过 touch slop 的纵向位移后通过静态状态桥记录滚动；`SoftKeyboardView` 读取该状态并显式取消外层释放。v12 调整取消时序：内部 `ScrollView` 先接收原始 `ACTION_UP` 以计算 fling，标准 View 分派返回后，才在外层自定义按键处理前改为 `ACTION_CANCEL`。同时每次外层 `ACTION_DOWN` 都清空桥接状态。v13 不再使用事件局部 Y 坐标判断移动，因为现代系统对子事件的坐标变换会造成静止触摸误判；改为在 `ScrollView` 处理完 `MOVE` 后比较实际 `scrollY`，仅当列表内容确实发生位移时才取消外层按键释放。

v5 曾把两个分页容器的取消辅助器提前到父分页器之前执行。这会让分页器把有效的 `ACTION_UP` 当作 `ACTION_CANCEL`，慢速滑动只能依靠超过半页的位移翻页。v6 恢复原始调用顺序；v7 进一步把提交距离从 25 dp 降至 8 dp，并移除最低 fling 速度的附加条件。

Pixel 10 Pro 的屏幕工作在 120 Hz，但旧版输入法没有帧率偏好。v6 曾同时通过窗口 `preferredRefreshRate` 和 `View.setFrameRate()` 固定请求 120 Hz，真机使用中可能妨碍 LTPO/ARR 降频并引起异常发热。v29 对照 Gboard 改用 Window touch boost，但真机确认它不能使 2018 年 Google 拼音的旧 Surface 生成高频帧；v30 实验性的交互期 View vote 也没有带来可感知改善。因此 v31 完全移除 `FrameRateCompat`、Window boost、固定/临时 View vote 及相关生命周期注入，恢复由 Android 系统默认调度帧率。高刷新率将在完成 target API 现代化后，基于新的渲染与帧率接口重新设计。

## 失效网络组件清理

Compatibility v18 停止创建 `Laym`，因此不再实例化 `Lazr` Clearcut 适配器、Primes 监控或向 `Lalh` 注册每日 ping、IME 事件和键盘事件上传处理器。本地 `IMetrics` 调用仍可作为旧框架内部的空处理/计时接口存在。

同时从 Manifest 移除 Firebase Instance ID、Firebase JobDispatcher 和 Google User Feedback 的所有系统入口，并从设置 XML 移除使用情况统计开关及发送反馈菜单。相关库代码暂保留为不可达代码，避免在缺少完整源码和 shrinker 的 smali 重建流程中误删共享依赖。

Compatibility v19 继续移除失效的系统词典在线更新：删除设置分类，不再注册 `new_words_update` 或创建访问 `tools.google.com/service/update?as=pinyinsysdict` 的任务工厂，并移除对应的网络权限功能声明。遗留的 `daily_ping_task` 注册也一并删除。用户词典导入、导出、快捷词典及用户词典同步保持不变。

## 用户词库防丢失

Compatibility v20 为可变词库文件增加恢复层。原版持久化按 `主文件 → _bak`、`_tmp → 主文件` 的顺序轮换，但成功后会删除 `_bak`，并且启动注册词库时完全不检查 `_bak` 或 `_tmp`。如果进程在两个 rename 之间终止，下一次启动会把缺失主文件误判为首次使用并注册空词库。

当前补丁在加载前执行以下恢复顺序：

1. 主文件存在时正常加载。
2. 主文件缺失时优先将 `_bak` 恢复为主文件。
3. 没有 `_bak` 时尝试恢复 `_tmp`。
4. 原生加载主文件失败时，将主文件隔离为 `_unreadable`，恢复 `_bak` 并重试一次。
5. 每次持久化成功后保留上一份 `_bak`，下次保存时才由新一轮轮换替换。

补丁不改变原生 Trie 格式、用户词库 `500000` 条容量或压缩至 90% 容量的策略。若主文件和备份都无法加载，输入法仍会降级到空词库以保证可用，但至少保留第一份不可读文件供后续分析。

## target SDK 策略

当前只提升到 28。后续提升前需要处理：

- target 31+：所有 PendingIntent 必须声明 immutable/mutable；
- target 31+：所有带 intent-filter 的组件必须显式 exported；
- target 33/34+：动态 Receiver 注册 flags；
- target 35+：Activity edge-to-edge 和旧设置 UI；
- 废弃存储、账号、同步、Firebase 和反馈服务。

## 手写崩溃

Android 16 真机日志确认，首次落笔时崩溃并非原生库或页面大小问题，而是 Java 异常：

```text
java.lang.IllegalArgumentException: Invalid Region.Op - only INTERSECT and DIFFERENCE are allowed
    at android.graphics.Canvas.clipRect(Canvas.java:874)
    at ayc.drawPenDown(PG:38)
```

旧绘制器使用 `Region.Op.REPLACE` 裁剪画布。当前 Android 版本只允许
`INTERSECT` 和 `DIFFERENCE`。Compatibility v4 将手写及滑行绘制路径中的 6 处
`REPLACE` 改为 `INTERSECT`，避免首次落笔立即终止输入法进程。由于
`INTERSECT` 会累积缩小离屏 Canvas 的裁剪区，手写渲染器还需要在每个点绘制前后
配对调用 `Canvas.save()` / `Canvas.restore()`；否则识别正常但笔迹几乎完全不可见。

手写路径随后会调用：

- `WordRecognizerJNI.initJNICompiledInputToolsNativePointer`
- `WordRecognizerJNI.startRecognition`
- `WordRecognizerJNI.addStroke`
- `WordRecognizerJNI.decode`

已在 Pixel 10 Pro / Android 16（系统报告 4 KiB page size）上验证笔迹显示、
中文识别和候选上屏均正常，未发现后续 JNI 或模型兼容问题。16 KiB page-size
设备仍需单独验证。
