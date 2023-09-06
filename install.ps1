# 常量
$programName = "Awesome Dustbins"
$programVersion = "1.0.0"
$programPublisher = "Yuba Technology"
$programUrl = "https://github.com/Yuba-Technology/awesome-dustbins"
$programExeName = "recycle.exe"
$installPath = "$env:LOCALAPPDATA\Programs\Recyclebin"
$programExePath = "$installPath\recycle.exe"
$dustbinsInstallPath = "$env:userprofile\desktop"
$uninstallPath = "$installPath\uninstall.exe"
$regFileName = "recycle.reg"
$uninstallRegFileName = "uninstall.reg"

# 为注册表生成将\转义为\\后的变量
$programExePath = $programExePath.Replace("\", "\\")
$installPath = $installPath.Replace("\", "\\")
$dustbinsInstallPath = $dustbinsInstallPath.Replace("\", "\\")
$uninstallPath = $uninstallPath.Replace("\", "\\")

# 开始安装操作

# # 为$installPath 新建文件夹
New-Item -Path $installPath -ItemType Directory -Force | Out-Null

# 读取./dustbins的子文件夹，获取垃圾桶列表
$dustbins = Get-ChildItem -Path ./dustbins -Directory

Write-Host "Installing..."

# 写入注册表，先写一个reg文件，再导入到注册表
$regFileContent = "Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$programName]
`"DisplayIcon`"=`"$programExePath`"
`"DisplayName`"=`"$programName`"
`"DisplayVersion`"=`"$programVersion`"
`"Publisher`"=`"$programPublisher`"
`"UninstallString`"=`"$uninstallPath`"
`"InstallPath`"=`"$installPath`"
`"ExeName`"=`"$programExeName`"
`"URLInfoAbout`"=`"$programUrl`"

[HKEY_CLASSES_ROOT\*\shell\你是什么垃圾？]

`"position`"=`"`"

`"subcommands`"=`"$($dustbins.Name -join ";")`"

[HKEY_CLASSES_ROOT\Folder\shell\你是什么垃圾？]

`"position`"=`"`"

`"subcommands`"=`"$($dustbins.Name -join ";")`"
"
$uninstallRegFileContent = "Windows Registry Editor Version 5.00

[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$programName]

[-HKEY_CLASSES_ROOT\*\shell\你是什么垃圾？]

[-HKEY_CLASSES_ROOT\Folder\shell\你是什么垃圾？]
"

# 将./dustbins内的文件夹及其内容复制到$dustbinsInstallPath
foreach ($dustbin in $dustbins) {
    $sourcePath = $dustbin.FullName
    $destinationPath = Join-Path $dustbinsInstallPath $dustbin.Name
    Write-Host "Copying folder $($dustbin.Name) to $($destinationPath)..."

    # 复制文件夹及其内容，并保留文件夹的自定义样式
    $options = "/E /I /Y /Q /H /K /O /J /C"
    $command = "xcopy `"$sourcePath`" `"$destinationPath`" $options"

    try {
        Invoke-Expression $command
        Write-Host "Folder $($dustbin.Name) copied successfully."
    }
    catch {
        Write-Host "Failed to copy folder $($dustbin.Name)."
    }

    $regFileContent += "
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($dustbin.Name)]
@=`"$($dustbin.Name)`"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($dustbin.Name)\command]
@=`"\`"$programExePath\`" \`"%L\`" \`"$dustbinsInstallPath\`" \`"$($dustbin.Name)\`"`"
"
    $uninstallRegFileContent += "
[-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\$($dustbin.Name)]
"
}

$regFileContent | Out-File -FilePath "$installPath\\$regFileName" -Encoding UTF8 -Force

$uninstallRegFileContent | Out-File -FilePath "$installPath\\$uninstallRegFileName" -Encoding UTF8 -Force

# 安装注册表
Write-Host "Installing registry..."
try {
    regedit /s "$installPath\\$regFileName"
    Write-Host "Registry installed successfully."
}
catch {
    Write-Host "Failed to install registry."
}

# 复制recycle.exe和uninstall.exe到安装目录
Write-Host "Copying files to installation folder..."
try {
    Copy-Item -Path .\recycle.exe -Destination $installPath -Force
    Copy-Item -Path .\uninstall.exe -Destination $installPath -Force
    Write-Host "Files copied successfully."
}
catch {
    Write-Host "Failed to copy files."
}

# # 复制当前文件夹下除了自己的所有文件到安装目录
# Write-Host "Copying files to installation folder..."
# try {
#     Get-ChildItem -Path .\* | Where-Object { $_.Name -ne $MyInvocation.MyCommand.Name } | Copy-Item -Destination $installPath -Recurse -Force
#     Write-Host "Files copied successfully."
# }
# catch {
#     Write-Host "Failed to copy files."
# }

# 等待用户按任意键退出
Write-Host "Press any key to exit..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null