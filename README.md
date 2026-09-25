# QuietPin

[简体中文](README.md) · [English](README.en.md)

一个常驻桌面的轻量 Inbox：随时记下一件事，只让最重要的三件事留在眼前。

![QuietPin 产品介绍：闪念即存，写完即消失](docs/images/quietpin-cover.png)

并行处理任务时，突然冒出的想法很容易打断当前心流；不记下来，又怕转眼就忘。QuietPin 让你用快捷键唤出中央输入条，写完即收进 Inbox，再回到手头的事。

QuietPin 提供 macOS 和 Windows 版本。记录保存在本机，不需要账号，也没有云同步或 AI 功能。

如果 QuietPin 对你有帮助，欢迎到 [GitHub 项目主页](https://github.com/savannahliz/SavannahZ_QuietPin) 点个 ⭐️ 支持作者。

## 它能做什么

- **快速记录**：按全局快捷键，屏幕中央弹出输入条；按 Enter 保存到 Inbox，Esc 取消。快捷键和保存键均可在设置中调整。新记录默认不置顶；取消键在鼠标移入输入区域时出现。
- **三条 Pin**：最多置顶三条事项。第四条需要选择替换对象，原事项仍留在 Inbox。
- **三种显示状态**：完整 Inbox、只显示 Pin、单行细条。窗口可拖动、缩放、置顶，也能贴到屏幕左右边缘；鼠标离开后收成唤回边条。
- **外观自定义**：调节背景颜色、收藏常用颜色，并分别设置便签闲置、交互及快速输入时的透明度。
- **完成事项**：可以恢复已完成事项；“清空”会删除全部已完成事项，首次清空会确认，也可选择以后不再提示。
- **本地保存**：记录、窗口位置和设置在重启后恢复。

## 下载与使用

安装包发布在仓库的 [Releases 页面](https://github.com/savannahliz/SavannahZ_QuietPin/releases/tag/v1.0.2)，源代码压缩包不能直接当作应用运行。

| 平台 | 下载文件 | 默认快速记录快捷键 |
| --- | --- | --- |
| macOS 13+，Apple Silicon / Intel | `QuietPin-1.0.2-macOS-universal.dmg` | Option + Space |
| Windows 10/11 x64 | `QuietPin-1.0.2-Windows-x64.exe` | Ctrl + Alt + Space |

Mac：打开 DMG，将 QuietPin 拖进“应用程序”，双击启动。它显示在屏幕顶部菜单栏，不显示在 Dock。Windows：双击 EXE 即可运行，无需另装 .NET；可在系统托盘找到应用。

选择颜色后会立即应用。若想以后再次使用该颜色，在调色窗口或设置中点击“保存颜色”；点击收藏色块可恢复，右键可删除收藏。

### macOS 首次打开提示“QuietPin 无法打开”

当前 DMG 尚未使用 Apple Developer ID 签名和公证，macOS 可能显示“Apple 无法验证 QuietPin 是否不含恶意软件”，并提供“移到废纸篓 / 完成”按钮。这并不等于已经检测到恶意软件，也不代表应用已经通过安全检查。请先确认安装包来自本仓库的 Releases；如果无法确认来源，不要继续打开。

确认来源可信后，按 [Apple 官方说明](https://support.apple.com/zh-cn/102445) 操作：

1. 在提示框中点“完成”，不要点“移到废纸篓”。
2. 打开 Mac 的“系统设置”→“隐私与安全性”，向下滚动到“安全性”。
3. 找到 QuietPin 的拦截提示，点“仍要打开”（英文系统为 **Open Anyway**）。
4. 再次确认时点“打开”，按系统要求输入密码或使用 Touch ID。之后可正常双击启动。

仅将“允许从以下位置下载的应用”改为“App Store 和已识别的开发者”，**不能替代**上面的“仍要打开”操作，因为当前版本还不是已识别开发者签名并公证的应用。无需关闭 Gatekeeper 或运行终端命令。彻底消除这类首次打开警告，需要未来版本完成 Developer ID 签名与 Apple 公证。

Windows 安装包目前也未进行正式代码签名，首次运行时可能显示系统安全提示。

## 本地数据

- macOS：`~/Library/Application Support/QuietPin/inbox.json`；设置由系统 UserDefaults 保存。
- Windows：`%LOCALAPPDATA%\QuietPin\inbox.json`，记录和设置保存在同一文件。

目前没有跨设备同步或 Mac/Windows 数据格式互通。备份前先退出应用，再复制对应数据文件；Mac 的外观和窗口设置还需另外备份系统偏好设置。

## 从源码构建

### macOS

需要 macOS 13+ 和 Xcode Command Line Tools。项目使用 SwiftUI、AppKit 与 Carbon，无第三方代码依赖。

```sh
bash scripts/test-macos.sh
bash scripts/build-macos.sh
```

构建完成后，应用位于 `dist/QuietPin.app`，DMG 位于 `dist/`。脚本分别编译 Apple Silicon 和 Intel 版本，再合并为通用应用。

### Windows

需要 .NET 10 SDK。Windows 版使用 WPF 和 Win32；发布为自带运行库的 x64 EXE。

```powershell
dotnet run --project windows/Tests/CoreChecks.csproj -c Release
dotnet publish windows/QuietPin.Windows.csproj -c Release -r win-x64 --self-contained true -o dist/windows-x64
```

在 macOS 上也可设置 `DOTNET_BIN` 指向 .NET 10 SDK，然后运行 `bash scripts/build-windows.sh` 交叉编译 Windows 包。

## 当前验证范围

macOS 的数据模型、颜色收藏、窗口模式、贴边行为和快速输入已有自动测试。Windows 已通过交叉编译与数据模型测试，但尚未在 Windows 真机验证界面、全局快捷键、多显示器和登录启动。Intel Mac、全屏应用与多个桌面的行为也尚未逐一实机验证。

欢迎通过 Issues 反馈复现步骤、系统版本和截图；提交日志或截图前请检查其中是否包含私人记录。

## 许可证

QuietPin 以 [GNU GPL v3.0](LICENSE) 发布（仅第 3 版）。
