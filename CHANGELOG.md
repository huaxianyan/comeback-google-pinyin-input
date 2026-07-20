# Changelog

## [0.2.0] - 2026-07-20

对应 Compatibility v4 / versionCode `4520316`。

### Fixed

- 根据 Android 16 真机 logcat 定位手写首次落笔崩溃：旧绘制器调用了系统不再允许的 `Region.Op.REPLACE`。
- 将手写及滑行绘制路径中的 6 处画布裁剪操作改为 `Region.Op.INTERSECT`。
- 使用成对的 `Canvas.save()` / `Canvas.restore()` 隔离每个笔画点的裁剪区，避免裁剪区持续收缩导致笔迹不可见。

### Changed

- versionCode：4520315 → 4520316。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat4`。

### Testing

- 已在 Pixel 10 Pro / Android 16 真机验证：手写笔迹显示、中文识别和候选上屏均正常。

## [0.1.0] - 2026-07-20

对应 Compatibility v3 / versionCode `4520315`。

### Added

- 增加 Android 16 系统导航栏主题适配。
- 根据 Google 拼音键盘主题标识选择浅色 `#ECEFF1` 或深色 `#263238`。
- 浅色主题使用深色系统导航图标，深色主题使用浅色图标。
- Android 28+ 同步导航栏分隔线颜色。
- Android 29+ 关闭系统强制导航栏对比度蒙层。
- 在候选区及扩展区更新后重新应用导航栏主题，避免输入时变黑。
- 增加可复现的 apktool 补丁及构建脚本。

### Changed

- targetSdkVersion：26 → 28。
- versionCode：4520313 → 4520315。
- versionName：`4.5.2.193126728-arm64-v8a-a16compat3`。
- 为输入法服务和 Launcher Activity 显式声明 `android:exported="true"`。
- 为开机初始化 Receiver 显式声明 `android:exported="false"`。

### Known issues

- 手写输入会导致输入法进程崩溃，原因待 logcat/native backtrace 确认。
