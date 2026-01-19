# 为新会话初始化规划文件
# 用法：.\init-session.ps1 [项目名称]

param(
    [string]$ProjectName = "project"
)

$DATE = Get-Date -Format "yyyy-MM-dd"

Write-Host "正在为以下项目初始化规划文件：$ProjectName"

# 如果 task_plan.md 不存在则创建
if (-not (Test-Path "task_plan.md")) {
    @"
# 任务计划：[简短描述]

## 目标
[一句话描述最终状态]

## 当前阶段
阶段 1

## 阶段

### 阶段 1：需求与发现
- [ ] 理解用户意图
- [ ] 识别约束
- [ ] 在 findings.md 中记录
- **状态：** 进行中

### 阶段 2：规划与结构
- [ ] 定义方法
- [ ] 创建项目结构
- **状态：** 待处理

### 阶段 3：实现
- [ ] 执行计划
- [ ] 在执行之前写入文件
- **状态：** 待处理

### 阶段 4：测试与验证
- [ ] 验证需求已满足
- [ ] 记录测试结果
- **状态：** 待处理

### 阶段 5：交付
- [ ] 审查输出
- [ ] 交付给用户
- **状态：** 待处理

## 已做出的决策
| 决策 | 理由 |
|----------|-----------|

## 遇到的错误
| 错误 | 解决方案 |
|-------|------------|
"@ | Out-File -FilePath "task_plan.md" -Encoding UTF8
    Write-Host "已创建 task_plan.md"
} else {
    Write-Host "task_plan.md 已存在，跳过"
}

# 如果 findings.md 不存在则创建
if (-not (Test-Path "findings.md")) {
    @"
# 发现与决策

## 需求
-

## 研究发现
-

## 技术决策
| 决策 | 理由 |
|----------|-----------|

## 遇到的问题
| 问题 | 解决方案 |
|-------|------------|

## 资源
-
"@ | Out-File -FilePath "findings.md" -Encoding UTF8
    Write-Host "已创建 findings.md"
} else {
    Write-Host "findings.md 已存在，跳过"
}

# 如果 progress.md 不存在则创建
if (-not (Test-Path "progress.md")) {
    @"
# 进度日志

## 会话：$DATE

### 当前状态
- **阶段：** 1 - 需求与发现
- **开始时间：** $DATE

### 采取的操作
-

### 测试结果
| 测试 | 预期 | 实际 | 状态 |
|------|----------|--------|--------|

### 错误
| 错误 | 解决方案 |
|-------|------------|
"@ | Out-File -FilePath "progress.md" -Encoding UTF8
    Write-Host "已创建 progress.md"
} else {
    Write-Host "progress.md 已存在，跳过"
}

Write-Host ""
Write-Host "规划文件已初始化！"
Write-Host "文件：task_plan.md, findings.md, progress.md"
