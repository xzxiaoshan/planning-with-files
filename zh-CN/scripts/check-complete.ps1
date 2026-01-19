# 检查 task_plan.md 中的所有阶段是否完成
# 完成则退出 0，未完成则退出 1
# 由 Stop 钩子使用以验证任务完成

param(
    [string]$PlanFile = "task_plan.md"
)

if (-not (Test-Path $PlanFile)) {
    Write-Host "错误：未找到 $PlanFile"
    Write-Host "没有任务计划无法验证完成情况。"
    exit 1
}

Write-Host "=== 任务完成检查 ==="
Write-Host ""

# 读取文件内容
$content = Get-Content $PlanFile -Raw

# 按状态统计阶段数
$TOTAL = ([regex]::Matches($content, "### Phase")).Count
$COMPLETE = ([regex]::Matches($content, "\*\*Status:\*\* complete")).Count
$IN_PROGRESS = ([regex]::Matches($content, "\*\*Status:\*\* in_progress")).Count
$PENDING = ([regex]::Matches($content, "\*\*Status:\*\* pending")).Count

Write-Host "总阶段数：       $TOTAL"
Write-Host "已完成：        $COMPLETE"
Write-Host "进行中：        $IN_PROGRESS"
Write-Host "待处理：        $PENDING"
Write-Host ""

# 检查完成情况
if ($COMPLETE -eq $TOTAL -and $TOTAL -gt 0) {
    Write-Host "所有阶段已完成"
    exit 0
} else {
    Write-Host "任务未完成"
    Write-Host ""
    Write-Host "在所有阶段完成之前不要停止。"
    exit 1
}
