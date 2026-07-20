# Changelog

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
