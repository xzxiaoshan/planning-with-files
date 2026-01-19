# 示例：基于文件的规划实践

## 示例 1：研究任务

**用户请求：** "研究晨练的好处并写一份总结"

### 循环 1：创建计划
```bash
Write task_plan.md
```

```markdown
# 任务计划：晨练好处研究

## 目标
创建一份关于晨练好处的研究总结。

## 阶段
- [ ] 阶段 1：创建此计划 ✓
- [ ] 阶段 2：搜索并收集资料
- [ ] 阶段 3：综合发现
- [ ] 阶段 4：提交总结

## 关键问题
1. 身体健康的好处是什么？
2. 心理健康的好处是什么？
3. 有哪些科学研究支持这一点？

## 状态
**当前处于阶段 1** - 创建计划
```

### 循环 2：研究
```bash
Read task_plan.md           # 刷新目标
WebSearch "morning exercise benefits"
Write notes.md              # 存储发现
Edit task_plan.md           # 标记阶段 2 完成
```

### 循环 3：综合
```bash
Read task_plan.md           # 刷新目标
Read notes.md               # 获取发现
Write morning_exercise_summary.md
Edit task_plan.md           # 标记阶段 3 完成
```

### 循环 4：提交
```bash
Read task_plan.md           # 验证完成
Deliver morning_exercise_summary.md
```

---

## 示例 2：错误修复任务

**用户请求：** "修复身份验证模块中的登录错误"

### task_plan.md
```markdown
# 任务计划：修复登录错误

## 目标
识别并修复阻止成功登录的错误。

## 阶段
- [x] 阶段 1：理解错误报告 ✓
- [x] 阶段 2：定位相关代码 ✓
- [ ] 阶段 3：识别根本原因（当前）
- [ ] 阶段 4：实施修复
- [ ] 阶段 5：测试和验证

## 关键问题
1. 出现什么错误消息？
2. 哪个文件处理身份验证？
3. 最近有什么更改？

## 已做出的决策
- 身份验证处理程序在 src/auth/login.ts
- 错误发生在 validateToken() 函数中

## 遇到的错误
- [初始] TypeError: Cannot read property 'token' of undefined
  → 根本原因：user 对象未正确等待

## 状态
**当前处于阶段 3** - 找到根本原因，准备修复
```

---

## 示例 3：功能开发

**用户请求：** "在设置页面添加深色模式切换开关"

### 三文件模式实践

**task_plan.md:**
```markdown
# 任务计划：深色模式切换开关

## 目标
在设置中添加功能性的深色模式切换开关。

## 阶段
- [x] 阶段 1：研究现有主题系统 ✓
- [x] 阶段 2：设计实施方案 ✓
- [ ] 阶段 3：实现切换组件（当前）
- [ ] 阶段 4：添加主题切换逻辑
- [ ] 阶段 5：测试和完善

## 已做出的决策
- 使用 CSS 自定义属性作为主题
- 将偏好设置存储在 localStorage 中
- 切换组件在 SettingsPage.tsx 中

## 状态
**当前处于阶段 3** - 构建切换组件
```

**notes.md:**
```markdown
# 笔记：深色模式实现

## 现有主题系统
- 位置：src/styles/theme.ts
- 使用：CSS 自定义属性
- 当前主题：仅浅色

## 需要修改的文件
1. src/styles/theme.ts - 添加深色主题颜色
2. src/components/SettingsPage.tsx - 添加切换开关
3. src/hooks/useTheme.ts - 创建新钩子
4. src/App.tsx - 用 ThemeProvider 包装

## 颜色决策
- 深色背景：#1a1a2e
- 深色表面：#16213e
- 深色文本：#eaeaea
```

**dark_mode_implementation.md：**（交付成果）
```markdown
# 深色模式实现

## 所做的更改

### 1. 添加了深色主题颜色
文件：src/styles/theme.ts
...

### 2. 创建了 useTheme 钩子
文件：src/hooks/useTheme.ts
...
```

---

## 示例 4：错误恢复模式

当某事失败时，不要隐藏它：

### 之前（错误）
```
操作：Read config.json
错误：File not found
操作：Read config.json  # 默默重试
操作：Read config.json  # 再次重试
```

### 之后（正确）
```
操作：Read config.json
错误：File not found

# 更新 task_plan.md：
## 遇到的错误
- config.json 未找到 → 将创建默认配置

操作：Write config.json（默认配置）
操作：Read config.json
成功！
```

---

## 决策前先读取模式

**在做出重大决策之前始终读取你的计划：**

```
[进行了许多工具调用...]
[上下文正在变长...]
[原始目标可能已被遗忘...]

→ Read task_plan.md          # 这会将目标带回注意力中！
→ 现在做决策（目标在上下文中是新鲜的）
```

这就是 Manus 可以处理约 50 次工具调用而不会迷失方向的原因。计划文件充当"目标刷新"机制。
