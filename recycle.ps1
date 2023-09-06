$sourcePath = $args[0..($args.Count - 3)]
$dustbinsInstallPath = $args[$args.Count - 2]
$dustbinName = $args[$args.Count - 1]

$destinationPath = Join-Path $dustbinsInstallPath $dustbinName

Write-Host "你是什么垃圾？"
Write-Host "$dustbinName！"

Write-Host "回收中..."
# 剪切文件或文件夹

foreach ($path in $sourcePath) {
    Move-Item -Path $path -Destination $destinationPath -Force
}

Write-Host "回收完成！"

Write-Host "10秒后自动关闭. 按任意键立刻退出..."
$timeout = New-TimeSpan -Seconds 10
$sw = [Diagnostics.Stopwatch]::StartNew()
while ($sw.Elapsed -lt $timeout) {
    if ($Host.UI.RawUI.KeyAvailable) {
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        break
    }
    Start-Sleep -Milliseconds 50
}