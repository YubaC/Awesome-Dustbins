# 常量
$installPath = "$env:LOCALAPPDATA\Programs\recyclebin"
$regFileName = "uninstall.reg"

# 检查当前用户是否为管理员
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# 如果当前用户不是管理员，则以管理员身份重新启动脚本
if (!$isAdmin) {
    Start-Process "$installPath\uninstall.exe" "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 进入安装目录
Set-Location $installPath

# 为注册表生成将\转义为\\后的变量
$installPath = $installPath.Replace("\", "\\")

# 开始卸载操作

# 删除注册表
Write-Host "Uninstalling registry..."
try {
    regedit /s "$installPath\$regFileName"
    Write-Host "Registry uninstalled successfully."
}
catch {
    Write-Host "Failed to uninstall registry."
}

# 删除安装文件夹
Write-Host "Deleting installation folder..."
try {
    # 以下代码删除不了自己，因为自己正在运行
    # Remove-Item -Path $installPath -Recurse -Force
    # 所以换了劲大的
    # 删除当前文件夹下除了自己的所有文件
    Get-ChildItem -Path $installPath | Where-Object { $_.Name -ne $MyInvocation.MyCommand.Name } | Remove-Item -Recurse -Force
    # 开一个新的cmd窗口，以管理员身份删除当前文件夹，
    # CMD应该有1s的延迟，以免在自己还没退出的时候就开始删除，导致删除失败
    # 删除完成后等待用户按任意键退出
    # CMD的命令为：@echo off & timeout 1 & rmdir /s /q "文件夹路径" & pause
    $cmdCommands = @(
        '@echo off',
        'timeout 1',
        "rmdir /s /q `"$installPath`"",
        "echo 卸载成功",
        'pause'
    )
    Start-Process cmd -ArgumentList "/c $($cmdCommands -join " & ")" -Verb RunAs
    Write-Host "Installation folder deleted successfully."
}
catch {
    Write-Host "Failed to delete installation folder."
}

# # 等待用户按任意键退出
# Write-Host "Press any key to exit..."
# $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null