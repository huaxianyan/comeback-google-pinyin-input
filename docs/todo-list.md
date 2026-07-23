# 兼容性适配 Todo List

## 当前任务：剪贴板候选

- [x] 验证原生候选栏静态原型的位置、点击上屏、英文和手写笔画兼容性
- [x] 接入动态纯文本剪贴板读取和活动输入视图期间的变更监听
- [x] 接入两分钟时效及候选点击后去重；按交互需求移除验证码提取，始终忠实粘贴完整原文
- [x] 过滤密码输入框、`disableAutoPaste`、敏感标记和非文本剪贴板
- [x] 将剪贴板项合并进每轮原生候选首批数据，避免分页重复注入
- [x] 完成长文本摘要、居中布局、圆角边框、前置剪贴板图标和 Material 凸起阴影的 Gboard 风格交互迭代
- [ ] 由项目维护者在真机验证 V25 动态剪贴板候选及视觉效果

## 当前任务：首次使用引导

- [x] 将首次使用引导页面整体更新为 Material Design 3 风格
- [x] 对照当前 Gboard，将标准完整流程收窄为“启用 → 选择 → 完成”三页
- [x] 移除“发送匿名使用情况/反馈信息”和旧权限总览页面
- [x] 统一完整引导流程，修复页面指示器先显示 2 个、重开后显示 4 个
- [x] 修正页面指示器的选中/未选中视觉状态
- [x] 优化已完成步骤的圆形勾选状态
- [x] V38 完成/第一页返回时显式回桌面；其他页面返回上一页，不再露出应用设置
- [x] V38 移除完成勾号的多余圆底；逐页返回和完成退出已通过真机验证
- [x] V39 移除 PageIndicator、禁止触摸滑页，改用上一步/下一步显式导航和完成状态门控
- [ ] 设备恢复 ADB 后安装 V39，并复测按钮布局、禁用状态、无滑页和完整三页流程

## 当前任务：输入面板触摸

- [x] 调整候选与符号翻页容器，在滑动结束前发送取消事件，避免松手误选
- [x] 对照 Gboard 调查 ScrollView、分页候选、RecyclerView、ViewPager 与外层 SoftKeyboardView 的显式滚动取消协议
- [x] V32 将分页辅助类 `aws` 接入 `ScrollTouchCompat` 外层取消桥，保持原生 pager/fling 参数不变
- [x] V32 真机复测未发现误选或点击回归；候选展开与左侧竖向列表滑动正常
- [x] 将全键盘符号/表情横向 pager 手感拆分为独立任务，并对照 Gboard ViewPager2/RecyclerView 调查旧 `lk` 的 slop、25dp fling distance、minimum velocity 与 50% settle
- [x] V33 诊断确认 30 次手势的旧 25dp final-delta 全为 0，fling 分支完全不可达；21 次回弹中 16 次速度已超过 minimum
- [x] V34 真机确认单指可轻松左右翻页且无已知回归；V35 已移除临时诊断，只保留验证通过的局部 fling 修复

## 当前任务：既有功能基础复核

- [x] 对照 Gboard 调查系统虚拟导航键、导航栏颜色、图标明暗、divider、contrast 和 WindowInsets 处理
- [x] V27 确认标准 Drawable 读取被 Google 拼音自定义 `bam` stylesheet wrapper 阻断，所有主题实际进入 fallback
- [x] V28 读取 `bam` 当前 state 的最终 `ColorStateList`，主题名称与硬编码颜色仅保留为早期生命周期 fallback
- [ ] 由项目维护者重新验证内置浅/深及额外彩色主题的导航栏颜色和虚拟键明暗
- [ ] 分别设计三键导航、手势导航、浮动键盘和 bottom frame 的兼容策略
- [x] 对照 Gboard 复核固定 120Hz 请求、触摸 boost、内容速度提示和设备 ARR 能力
- [x] V29 移除固定 120Hz Window/View vote，API 35+ 改用触摸动态 boost，并在 `onFinishInputView()` 对称释放
- [x] V30 交互期 Surface vote 真机无可感知改善；V31 已回滚所有帧率干预，恢复系统默认调度
- [ ] target API 与渲染路径现代化后重新实现高刷新率支持
- [x] 对照 Gboard 复核手写离屏 Bitmap/Canvas、down/move/up clip、save/restore、pressure 与 dirty-rect 路径
- [ ] 真机验证 V36 手写 Canvas 整理：首笔、连续多笔、多字识别、笔迹清除/淡出及候选上屏
- [ ] 继续复核其他已修改功能

## 后续兼容性工作

- [ ] 清理或禁用失效的统计、Firebase 与反馈上传逻辑
- [ ] 回归测试拼音九键、拼音全键盘、英文输入和滑行输入
- [ ] 清理旧账号同步功能及不再需要的权限
- [ ] 分阶段提升 `targetSdkVersion`，逐代处理 Android 行为变更
- [ ] 在真正的 16 KiB page-size 设备上验证原生库
- [ ] 调查并消除 `MetricsProcessorHelper` 的反射参数错误日志

## 测试约定

- 编码代理负责构建、签名和安装 APK；功能验证、真机操作检查和回归测试由项目维护者执行。

## 已完成

- [x] 适配 Android 16 浅色和深色导航栏
- [x] 消除 Android 16 的旧版应用提示
- [x] 修复手写首次落笔崩溃
- [x] 修复手写识别正常但笔迹不可见
- [x] 在 Pixel 10 Pro / Android 16 上验证手写显示、识别与候选上屏
