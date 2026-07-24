# Google 拼音输入法 Android 16/17 兼容版

这是 Google 拼音输入法 4.5.2 的非商业兼容维护项目，目标是在尽量保持原始输入体验、候选逻辑、词库格式和主题行为的前提下，使这款已经停止更新的输入法能够继续用于 Android 16/17。

## 下载

正式兼容版请从项目的 [Releases](https://github.com/huaxianyan/comeback-google-pinyin-input/releases) 页面下载。

仓库同时保存用于复现构建的原始官方 APK：

[`original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk`](original/google-pinyin-input-4.5.2.193126728-arm64-v8a.apk)

## 版本信息

### 原始版本

| 项目 | 内容 |
| --- | --- |
| 产品名称 | Google Pinyin Input / Google 拼音输入法 |
| 原始版本 | `4.5.2.193126728` |
| 原始包名 | `com.google.android.inputmethod.pinyin` |
| 架构 | `arm64-v8a` |
| 原始 target SDK | 26 |
| 原始 APK SHA-256 | `980fd0f4695f683648e6f7ab9a15a24732e8957b5b14b25d49af931176574bd7` |
| 签名主体 | `OU=Google, Inc, O=Google, Inc, L=Mountain View, ST=CA, C=US` |
| 签名证书 SHA-256 | `3D:7A:12:23:01:9A:A3:9D:9E:A0:E3:43:6A:B7:C0:89:6B:FB:4F:B6:79:F4:DE:5F:E7:C2:3F:32:6C:8F:99:4A` |

Google 拼音输入法最初由 Google 发布并通过 Google Play 等官方 Android 分发渠道提供。本仓库中的原始 APK 用于软件保存、兼容性研究和可复现构建，其文件哈希与签名信息列于上表，便于独立校验来源和完整性。

### 兼容版本

| 项目 | 内容 |
| --- | --- |
| 项目版本 | `1.0.0` |
| 应用版本名 | `4.5.2` |
| versionCode | `4520360` |
| 兼容版包名 | `com.google.android.inputmethod.pinyin.compat` |
| target SDK | 28 |
| 主要测试设备 | Pixel 10 Pro / Android 16 |

兼容版使用独立包名和项目测试证书签名，可以与 Google 原始版本同时安装。以后升级兼容版时必须继续使用同一签名证书；它不能覆盖由 Google 官方证书签名的原始应用。

## 主要兼容改进

- 修复 Android 16 手写首笔因旧 `Canvas.clipRect(..., Region.Op.REPLACE)` 导致的崩溃。
- 保持原有 `ALPHA_8` 离屏手写画布、压感宽度、路径平滑和原生识别流程。
- 修复候选、标点、符号和表情列表滚动后外层键盘错误触发点击的问题。
- 修复全键盘符号/表情分页中失效的滑动距离门槛，同时保留原有翻页、吸附和动画参数。
- 增加与原生候选管线融合的剪贴板候选，点击后提交完整剪贴板文本。
- 根据实际键盘主题表面调整 Android 导航栏颜色和明暗图标。
- 移除持续固定 120 Hz 的旧兼容请求，由 Android 的 LTPO/ARR 调度刷新率。
- 将首次使用引导整理为“启用 → 选择输入法 → 完成”，使用明确的上一步/下一步导航。
- 加固用户词典持久化：滚动 `_bak`、中断 `_tmp` 恢复、失败主文件隔离、进程级保存锁和显式清理保护。
- 增加本地用户词典自动备份，固定保存到：

  ```text
  Documents/GooglePinyinBackup
  ```

- 支持 1/3/7/14/30 天备份间隔、3/5/10/20/30 个保留版本、立即备份和手动导入。
- 备份使用 Google 拼音原生 UTF-16LE 用户词典导出/导入格式；不使用云端、不自动恢复、不依赖网络。
- 清理失效的 Clearcut/Primes、Firebase、反馈上传和在线词典更新组件。
- 补全现代 Android 要求的关键 `android:exported` 声明。

更完整的实现记录、Gboard 对照研究和测试结论位于 [`docs/`](docs/) 与 [`CHANGELOG.md`](CHANGELOG.md)。

## 本地词典灾难恢复

启用“自动备份用户字典”后，备份会发布到公共 Documents 目录，因此清除应用数据或卸载兼容版不会删除这些文本文件。

恢复步骤：

1. 安装兼容版并启用输入法。
2. 打开“设置 → 字典”。
3. 点击“导入本地备份”。
4. 首次恢复时按系统提示授予文件权限。
5. 选择所需备份并确认导入。

导入采用原生合并/更新语义，不会自动覆盖或回滚当前词典。卸载重装后若系统媒体数据库暂时不显示旧文件，也可以在文件管理器中打开或分享备份 `.txt` 到 Google 拼音。

## 仓库结构

```text
original/
  google-pinyin-input-4.5.2.193126728-arm64-v8a.apk  原始官方安装包
patches/
  java/                                               兼容辅助代码源码
  smali/                                              构建时注入的 smali
  res/                                                兼容资源
scripts/
  apply_patches.py                                    可复现补丁流程
  build.ps1                                           Windows 构建脚本
docs/                                                 调查、设计与测试记录
CHANGELOG.md                                          版本变更记录
```

## 构建

所需工具：

- Java 11+
- Python 3
- apktool 2.12.1
- uber-apk-signer 1.3.0，或 Android SDK 的 `apksigner`/`zipalign`
- PKCS#12/JKS 签名证书

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

补丁脚本会从原始 APK 解码、应用资源及 smali 改动、修改为独立包名，然后重建、对齐并签名。

## 来源、版权与非商业声明

- **Google Pinyin Input、Google 拼音输入法、Google 名称、标志、原始程序、资源、词库和相关商标的版权及其他权利归 Google LLC、Google Inc. 或其各自权利人所有。**
- 本项目维护者不拥有 Google 原始软件及商标，也不代表、不隶属于且未获得 Google 官方背书。
- 本项目中的兼容补丁、研究记录和构建脚本由项目贡献者以个人、非商业的软件保存、互操作性研究和旧设备兼容维护为目的提供。
- 原始 APK 保持其原有版权状态；兼容构建不会改变原始作品的权利归属。使用者应遵守所在地法律、原软件条款及相关权利要求。
- 本项目不收费，不出售应用，不接入广告，也不以 Google 品牌或原始程序牟利。
- 如相关权利人认为仓库内容需要调整，可通过 GitHub Issues 或仓库所有者联系方式提出说明。
