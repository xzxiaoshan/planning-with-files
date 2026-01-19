---
name: planning-with-files
version: "2.3.0"
description: 实现 Manus 风格的基于文件的复杂任务规划。创建 task_plan.md、findings.md 和 progress.md。用于启动复杂的多步骤任务、研究项目或任何需要超过 5 次工具调用的任务。现在支持 /clear 后的自动会话恢复。
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - WebFetch
  - WebSearch
hooks:
  PreToolUse:
    - matcher: "Write|Edit|Bash|Read|Glob|Grep"
      hooks:
        - type: command
          command: "cat task_plan.md 2>/dev/null | head -30 || true"
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "echo '[planning-with-files] 文件已更新。如果此操作完成了一个阶段，请更新 task_plan.md 的状态。'"
  Stop:
    - hooks:
        - type: command
          command: |
            if command -v pwsh &> /dev/null && [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OS" == "Windows_NT" ]]; then
              pwsh -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/check-complete.ps1" 2>/dev/null || powershell -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/check-complete.ps1" 2>/dev/null || bash "${CLAUDE_PLUGIN_ROOT}/scripts/check-complete.sh"
            else
              bash "${CLAUDE_PLUGIN_ROOT}/scripts/check-complete.sh"
            fi
---

# 基于文件的规划

像 Manus 一样工作：使用持久的 markdown 文件作为你的"磁盘工作记忆"。

## 第一步：检查上一次会话（v2.2.0）

**开始工作之前**，检查上一次会话中未同步的上下文：

```bash
# Claude Code 用户
python3 ~/.claude/skills/planning-with-files/scripts/session-catchup.py "$(pwd)"

# Codex 用户
python3 ~/.codex/skills/planning-with-files/scripts/session-catchup.py "$(pwd)"

# Cursor 用户
python3 ~/.cursor/skills/planning-with-files/scripts/session-catchup.py "$(pwd)"
```

如果同步报告显示有未同步的上下文：
1. 运行 `git diff --stat` 查看实际的代码更改
2. 读取当前的规划文件
3. 根据同步报告和 git diff 更新规划文件
4. 然后继续任务

## 重要：文件存放位置

**模板位置（根据你的 IDE）：**
- Claude Code: `~/.claude/skills/planning-with-files/templates/`
- Codex: `~/.codex/skills/planning-with-files/templates/`
- Cursor: `~/.cursor/skills/planning-with-files/templates/`

**你的规划文件**放在**你的项目目录**中

| 位置 | 内容 |
|----------|-----------------|
| 技能目录 (`~/.claude/skills/planning-with-files/` 或 `~/.codex/skills/planning-with-files/`) | 模板、脚本、参考文档 |
| 你的项目目录 | `task_plan.md`、`findings.md`、`progress.md` |

## 快速开始

在任何复杂任务之前：

1. **创建 `task_plan.md`** — 参考 [templates/task_plan.md](templates/task_plan.md)
2. **创建 `findings.md`** — 参考 [templates/findings.md](templates/findings.md)
3. **创建 `progress.md`** — 参考 [templates/progress.md](templates/progress.md)
4. **在做决定前重读计划** — 刷新注意力窗口中的目标
5. **每个阶段后更新** — 标记完成，记录错误

> **注意：** 规划文件放在你的项目根目录中，而不是技能安装文件夹中。

## 核心模式

```
上下文窗口 = 内存（易失、有限）
文件系统 = 磁盘（持久、无限）

→ 任何重要内容都会写入磁盘。
```

## 文件用途

| 文件 | 用途 | 何时更新 |
|------|---------|----------------|
| `task_plan.md` | 阶段、进度、决策 | 每个阶段之后 |
| `findings.md` | 研究、发现 | 任何发现之后 |
| `progress.md` | 会话日志、测试结果 | 整个会话期间 |

## 关键规则

### 1. 首先创建计划
绝不要在没有 `task_plan.md` 的情况下开始复杂任务。这是不可商量的。

### 2. 双操作规则
> "每进行 2 次查看/浏览/搜索操作后，立即将关键发现保存到文本文件。"

这可以防止视觉/多模态信息丢失。

### 3. 决策前先读取
在做重大决策之前，读取计划文件。这可以保持目标在你的注意力窗口中。

### 4. 操作后更新
完成任何阶段后：
- 标记阶段状态：`in_progress` → `complete`
- 记录遇到的任何错误
- 注明创建/修改的文件

### 5. 记录所有错误
每个错误都要记录在计划文件中。这可以积累知识并避免重复。

```markdown
## 遇到的错误
| 错误 | 尝试次数 | 解决方案 |
|-------|---------|------------|
| FileNotFoundError | 1 | 创建默认配置 |
| API 超时 | 2 | 添加重试逻辑 |
```

### 6. 绝不重复失败
```
如果操作失败：
    下一个操作 ≠ 相同操作
```
跟踪你尝试过的操作。改变方法。

## 三次错误协议

```
尝试 1：诊断并修复
  → 仔细阅读错误
  → 识别根本原因
  → 应用针对性修复

尝试 2：替代方法
  → 还是同样的错误？尝试不同的方法
  → 不同的工具？不同的库？
  → 绝不重复完全相同的失败操作

尝试 3：更全面的重新思考
  → 质疑假设
  → 搜索解决方案
  → 考虑更新计划

3 次失败后：升级给用户
  → 解释你尝试了什么
  → 分享具体错误
  → 请求指导
```

## 读写决策矩阵

| 情况 | 操作 | 原因 |
|-----------|--------|--------|
| 刚写入文件 | 不要读取 | 内容仍在上下文中 |
| 查看了图片/PDF | 立即写入发现 | 多模态 → 文本，以免丢失 |
| 浏览器返回数据 | 写入文件 | 截图不会持久保存 |
| 开始新阶段 | 读取计划/发现 | 如果上下文陈旧则重新定位 |
| 发生错误 | 读取相关文件 | 需要当前状态来修复 |
| 间隔后恢复 | 读取所有规划文件 | 恢复状态 |

## 五问题重启测试

如果你能回答这些问题，说明你的上下文管理很稳固：

| 问题 | 答案来源 |
|----------|---------------|
| 我在哪里？ | task_plan.md 中的当前阶段 |
| 我要去哪里？ | 剩余的阶段 |
| 目标是什么？ | 计划中的目标陈述 |
| 我学到了什么？ | findings.md |
| 我做了什么？ | progress.md |

## 何时使用此模式

**用于：**
- 多步骤任务（3 步以上）
- 研究任务
- 构建/创建项目
- 跨越大量工具调用的任务
- 任何需要组织的任务

**跳过：**
- 简单问题
- 单文件编辑
- 快速查找

## 模板

复制这些模板以开始：

- [templates/task_plan.md](templates/task_plan.md) — 阶段跟踪
- [templates/findings.md](templates/findings.md) — 研究存储
- [templates/progress.md](templates/progress.md) — 会话日志

## 脚本

用于自动化的辅助脚本：

- `scripts/init-session.sh` — 初始化所有规划文件
- `scripts/check-complete.sh` — 验证所有阶段已完成
- `scripts/session-catchup.py` — 从上一次会话恢复上下文（v2.2.0）

## 高级主题

- **Manus 原则：** 参见 [reference.md](reference.md)
- **真实示例：** 参见 [examples.md](examples.md)

## 反模式

| 不要做 | 应该做 |
|-------|------------|
| 使用 TodoWrite 进行持久化 | 创建 task_plan.md 文件 |
| 陈述一次目标后就忘记 | 在决策前重读计划 |
| 隐藏错误并默默重试 | 将错误记录到计划文件 |
| 把所有东西塞进上下文 | 将大内容存储在文件中 |
| 立即开始执行 | 首先创建计划文件 |
| 重复失败的操作 | 跟踪尝试，改变方法 |
| 在技能目录中创建文件 | 在你的项目中创建文件 |
