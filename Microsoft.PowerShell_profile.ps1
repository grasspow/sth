# powershell初始化加载 PSReadLine 模块
Import-Module PSReadLine
# 使用历史记录进行脚本提示
Set-PSReadLineOption -PredictionSource History

function Use-AcceptSuggestionOrComplete {
    $currentCommand = $PSReadLine
    # 尝试接受建议
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()

    # 检查命令行是否发生了变化
    Start-Sleep -Milliseconds 10 # 给系统一点时间来更新命令行内容
    $newCommand = $PSReadLine

    if ($newCommand -eq $currentCommand) {
        # 如果命令行没有变化，执行补全
        [Microsoft.PowerShell.PSConsoleReadLine]::Complete()
    }
}

# 设置 Tab 键调用自定义函数
Set-PSReadLineKeyHandler -Key Shift+Tab -Function Complete
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Use-AcceptSuggestionOrComplete }

# OhMyPosh
$previousOutputEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [Text.Encoding]::UTF8
try{
  oh-my-posh init pwsh --config "E:/workspace/patch/ohmyposh/steeef.omp.json" | Invoke-Expression
}finally {
  [Console]::OutputEncoding = $previousOutputEncoding
}

# alias
Remove-Item alias:ls
Set-Alias lls Get-ChildItem

function replace-ls {eza --icons --color=always}
Set-Alias ls replace-ls

function replace-l {exa -lbah --icons}
function replace-ll {eza -lbg --icons}
function replace-la {eza -labgh --icons}
function replace-tree {eza -lTabgh}
Set-Alias l replace-l
Set-Alias ll replace-ll
Set-Alias la replace-la
Set-Alias tree replace-tree

function up1 {cd ..}
function up2 {cd ../..}
function up3 {cd ../../..}
function up4 {cd ../../../..}
Set-Alias .. up1
Set-Alias ... up2
Set-Alias .... up3
Set-Alias ..... up4