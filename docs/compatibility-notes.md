# Android 16/17 兼容性记录

## 基础版本

- package：`com.google.android.inputmethod.pinyin`
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
