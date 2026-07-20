# Comeback Google Pinyin Input

为停止维护的 Google 拼音输入法 4.5.2 arm64 版本提供可复现的 Android 16/17 兼容补丁。

> 本仓库只保存补丁、构建脚本和研究文档，不包含 Google 的原始 APK、反编译资源、词库或原生库。使用者需要自行合法取得原版 APK。

## 当前版本

**Compatibility v4**

- 基础版本：Google Pinyin Input `4.5.2.193126728`，`arm64-v8a`
- 原包名：`com.google.android.inputmethod.pinyin`
- `targetSdkVersion`：26 → 28
- `versionCode`：`4520316`
- 修复 Android 16 上开始手写时因旧版 `Canvas` 裁剪操作导致的崩溃和笔迹不可见问题
- 适配 Pixel 10 Pro / Android 16 的浅色和深色导航栏
- 防止输入及候选区刷新时导航栏被旧框架重置为黑色
- 补全关键组件的 `android:exported` 声明
- 已消除 Android 16 的“专为旧版 Android 打造”提示

## 已知问题

- `libhmm_gesture_hwr_zh.so` 是旧式 4 KiB ELF 布局；它在 16 KiB page-size 设备上的兼容性仍需调查。
- Firebase、账号同步、反馈及旧权限尚未清理。
- 尚未直接提升到 target SDK 35/36；直接跨越多个 target SDK 会同时启用多代行为变更。

## 仓库结构

```text
patches/
  smali/NavigationBarCompat.smali  导航栏兼容代码
scripts/
  apply_patches.py                 对 apktool 输出应用 v4 补丁
  build.ps1                        Windows 构建示例
docs/
  compatibility-notes.md           调查和兼容性记录
CHANGELOG.md
```

## 构建

准备：

- Java 11+
- apktool 2.12.1
- uber-apk-signer 1.3.0，或 Android SDK `apksigner`/`zipalign`
- Google 拼音 4.5.2 arm64-v8a 原始 APK
- 自己的签名证书

PowerShell 示例：

```powershell
./scripts/build.ps1 `
  -ApkPath ./original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk `
  -ApktoolJar ./tools/apktool.jar `
  -SignerJar ./tools/uber-apk-signer.jar `
  -Keystore ./signing.p12 `
  -KeyAlias google-pinyin-local `
  -StorePassword 'your-password' `
  -KeyPassword 'your-password'
```

修改版不能使用 Google 的私钥签名。第一次安装修改版前必须卸载官方版；之后只要保留并使用同一签名证书，就可以覆盖升级。

## 原始 APK 校验信息

本项目研究所用的 arm64 原版 APK：

```text
SHA-256 980fd0f4695f683648e6f7ab9a15a24732e8957b5b14b25d49af931176574bd7
```

请勿将原始 APK、修改 APK、Google 词库或原生库提交到本仓库。
