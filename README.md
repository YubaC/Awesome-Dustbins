# Awesome-Dustbins

## 你是什么垃圾？

<!-- ~~你是什么垃圾？~~ -->

厌倦了单调乏味的 Windows 回收站？想要更丰富多彩的文件回收系统？没问题！

通过向的桌面添加“可回收垃圾”“不可回收垃圾”“厨余垃圾”“有害垃圾”四个文件夹，你现在可以自由地对你的文件进行分类了———只要你愿意， 你可以把任何文件都扔进去！

你现在可以向你电脑上的任意一个文件或文件夹提出上海阿姨同款灵魂拷问了：

——_“你是什么垃圾？”_

### 自定义你的垃圾桶！

就连四分类的垃圾桶都不能满足你的需求？没问题！

你可以自由地添加、删除、修改你的垃圾桶，让你的垃圾桶变得更加丰富多彩！

只需要打开任意一个版本的安装包文件，向`./dustbins/`文件夹中添加或删除你想要的垃圾桶，然后双击`install.exe`重新安装即可！

**`install.exe`需要管理员权限才能正常运行。**

## 安装

### 使用我们发布的 Release（推荐）

1. 下载最新的 Release
2. 解压到任意位置
3. 双击`install.exe`即可安装

### 从源码编译

1. 下载源码
2. 安装`ps2exe`（在 PowerShell 中运行`Install-Module -Name ps2exe`）
3. 在源码目录下运行：
   ```powershell
   ps2exe recycle.ps1 recycle.exe
   ps2exe install.ps1 install.exe
   ps2exe uninstall.ps1 uninstall.exe
   ```
4. 双击`install.exe`即可安装

默认的安装目录为`%LOCALAPPDATA%\Programs\Recyclebin\`，如果你想要修改安装目录，请修改`install.ps1`和`uninstall.ps1`中的`$installPath`变量。

## 卸载

双击`uninstall.exe`即可卸载，卸载后不会删除桌面上的垃圾桶，只会删除右键菜单中的“你是什么垃圾？”选项和安装目录内的文件。

也可以使用 Geek Uninstaller 等第三方卸载软件卸载。
