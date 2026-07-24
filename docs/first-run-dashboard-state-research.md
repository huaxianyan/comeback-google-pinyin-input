# 首次引导重复与键盘布局选择状态调查

## 现象

在多次卸载、重新安装测试包后可能出现：

1. 已走完“启用 → 选择输入法 → 完成”，第一次准备输入时又回到一次完成页面；再次点击完成后不再出现。
2. 第一次弹出键盘时直接进入 26 键，而不是原版的四布局 Dashboard。
3. 后来手动打开键盘切换界面时，才显示“请选择您常用的键盘布局”首次提示。

三个现象来自同一组安装状态，而不是词典导入本身。

## 原始状态链路

### 引导完成状态

共享 `apy` 使用默认 SharedPreferences 中的整数：

```text
HAD_FIRST_RUN
```

`PinyinFirstRunActivity.b(Context)` 在 `SettingsActivity` 和 `PinyinIME.d()` 两处调用。只要值不等于资源中的 first-run version，就会以 `FLAG_ACTIVITY_NEW_TASK` 启动首次引导。

旧框架在 `apy.onCreate()` 一进入 Activity 就写 `HAD_FIRST_RUN`，并通过 `Lamx.a(String,int)` 最终调用 `SharedPreferences.Editor.apply()`；最后“完成”按钮本身只负责启动 Home 并 `finishAndRemoveTask()`，没有同步的最终完成事务。

因此原始状态表达的是“引导 Activity 创建过”，不是“用户点击完成且任务已退出”。IME 服务又会在第二步被选中时启动并独立检查相同状态，形成 Activity/IME 生命周期交叉。

### 键盘布局状态

四选一页面不是 Activity 引导的一页，而是输入法内部的 `Dashboard` InputBundle。是否自动进入 Dashboard 由：

```text
USER_SELECTED_KEYBOARD
```

控制：

- `false`：`GoogleInputMethodService.shouldSwitchToDashboard()` 对普通软键盘文本字段返回 true；
- 用户从 Dashboard 切换到具体布局后，`GoogleInputMethodService.g()` 将其写为 true；
- Dashboard 在 false 时显示 `hint_text_choose_keyboard_layout`，即“请选择您常用的键盘布局”。

如果 IME 服务在引导第二步就已初始化，它可能先持有普通 26 键 InputBundle；原始代码没有“最终完成后，在第一个合适输入框重新执行 Dashboard 选择”的明确事务。因此可以出现“先显示 26 键，手动切换后才在 Dashboard 弹首次提示”。

## BackupAgent 影响

应用声明的自定义 `BackupAgent` 使用：

```text
SharedPreferencesBackupHelper(<package>_preferences)
```

备份整个默认偏好文件。其恢复排除数组为空，所以以下安装本地状态也会随卸载重装/设备恢复返回：

```text
HAD_FIRST_RUN
USER_SELECTED_KEYBOARD
ACTIVE_IME.SOFT.*
```

这解释了为何问题在多次重新安装审计包时更容易出现：恢复的数据可能来自不同测试阶段，而旧框架把一次性引导状态、布局是否已选择、当前布局和普通可迁移设置混在同一个默认偏好文件中。备份配置本身不应决定新安装是否完成系统输入法启用步骤。

正式本地词典备份使用独立 `dictionary_local_backup_preferences`，不参与这个问题；用户词典导入也不会写上述键。

## 修复设计

### 1. 安装本地完成标记

新增未注册到 BackupAgent 的：

```text
first_run_local_state
  guide_complete
  dashboard_pending
```

最后一页点击“完成”时：

1. 使用同步 `commit()` 写 `guide_complete=true`；
2. 写 `dashboard_pending=true`；
3. 同步重置 `USER_SELECTED_KEYBOARD=false`；
4. 然后才执行 Home + `finishAndRemoveTask()`。

`PinyinFirstRunActivity.b(Context)` 优先检查安装本地 `guide_complete`，避免任务移除和 IME 启动之间再次排队引导 Intent。旧 `HAD_FIRST_RUN` 检查保留，兼容已经完成引导但尚无新标记的升级用户。

### 2. 不恢复一次性安装状态

`BackupAgent.onRestore()` 在原生恢复后只移除：

```text
HAD_FIRST_RUN
USER_SELECTED_KEYBOARD
```

其他主题、输入偏好、当前布局等仍按原有 BackupAgent 恢复。新安装或新设备仍需完成 Android 系统层面的启用/选择步骤，不应被旧备份直接判定为完成。

### 3. 第一个合适文本字段显示 Dashboard

`PinyinIME.onStartInputView()` 检查 `dashboard_pending`：

- 继续复用原生 `shouldSwitchToDashboard()`，因此密码、数字、硬键盘、TV 或只有单一布局的场景不会被强制切换；
- 对第一个符合原生条件的普通文本字段调用现有 `InputBundleManager.b("dashboard")`；
- 成功请求后消费 pending；
- 如果用户已经主动选择了布局，则直接消费 pending，不覆盖用户选择。

没有修改 Dashboard 的四项内容、截图、触摸、提示气泡或 `USER_SELECTED_KEYBOARD` 的原生完成语义。

## 隔离验证范围

测试包使用：

```text
com.google.android.inputmethod.pinyin.guideaudit
```

需要验证：

1. 新安装完整走完三步后，准备输入时不再出现第二次完成页；
2. 第一个普通文本输入框自动显示四布局 Dashboard；
3. “请选择您常用的键盘布局”在 Dashboard 中正常出现；
4. 选择 9 键或 26 键后进入对应键盘，后续不再自动打开 Dashboard；
5. 第一个字段若是密码/数字，不强制 Dashboard；随后第一个普通文本字段仍显示；
6. 卸载重装并发生系统偏好恢复后仍重复 1–5；
7. 正式包 `com.google.android.inputmethod.pinyin.compat` 的数据和默认输入法不受隔离包安装影响。
