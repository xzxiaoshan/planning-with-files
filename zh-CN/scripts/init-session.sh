#!/bin/bash
# 为新会话初始化规划文件
# 用法：./init-session.sh [项目名称]

set -e

PROJECT_NAME="${1:-project}"
DATE=$(date +%Y-%m-%d)

echo "正在为以下项目初始化规划文件：$PROJECT_NAME"

# 如果 task_plan.md 不存在则创建
if [ ! -f "task_plan.md" ]; then
    cat > task_plan.md << 'EOF'
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
EOF
    echo "已创建 task_plan.md"
else
    echo "task_plan.md 已存在，跳过"
fi

# 如果 findings.md 不存在则创建
if [ ! -f "findings.md" ]; then
    cat > findings.md << 'EOF'
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
EOF
    echo "已创建 findings.md"
else
    echo "findings.md 已存在，跳过"
fi

# 如果 progress.md 不存在则创建
if [ ! -f "progress.md" ]; then
    cat > progress.md << EOF
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
EOF
    echo "已创建 progress.md"
else
    echo "progress.md 已存在，跳过"
fi

echo ""
echo "规划文件已初始化！"
echo "文件：task_plan.md, findings.md, progress.md"
