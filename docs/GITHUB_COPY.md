# QuietPin · GitHub 发布文案

以下文字可以直接复制到 GitHub 的仓库设置和首个 Release。发布前检查版本号与安装包文件名是否一致。

## 仓库名称

`SavannahZ_QuietPin`

## Description / About

`闪念即存，重要的事留在眼前。快捷键随时记录想法，自动收进本地 Inbox；最多置顶三条。支持 macOS 和 Windows。`

## Topics

`macos` `windows` `desktop-app` `productivity` `note-taking` `swiftui` `wpf`

## 首个 Release

**Tag：** `v1.0.0`

**标题：** `QuietPin v1.0.0 · 首个公开预览版`

**正文：**

> QuietPin 是一款轻量桌面 Inbox。按全局快捷键快速记下一件事，最多将三条重要事项 Pin 在屏幕上；窗口可折叠成细条、贴边隐藏，并可调整颜色和透明度。记录保存在本机，无需账号。
>
> 为不打断当前任务的心流，中央输入条会快速弹出，记录后自动消失；鼠标移入时才显示取消键。
>
> ### 下载
>
> - macOS 13+（Apple Silicon / Intel）：`QuietPin-1.0.0-macOS-universal.dmg`，打开后将应用拖入“应用程序”。
> - Windows 10/11 x64：`QuietPin-1.0.0-Windows-x64.exe`，双击运行，无需另装 .NET。
>
> ### 主要功能
>
> - 自定义全局快捷键快速记录，Enter 或组合键保存，Esc 取消。
> - 单一 Inbox，最多三条 Pin，支持替换和拖动排序。
> - 完整列表、三条 Pin、细条和屏幕边缘唤回条。
> - 透明度、颜色、收藏色与窗口置顶设置。
> - 已完成事项可恢复，也可批量清空并记住确认偏好。
>
> ### 当前限制
>
> 安装包尚未正式代码签名。Windows 版通过交叉编译和数据测试，但尚未完成 Windows 真机界面验证；Intel Mac 也尚未实机验证。首次安装请确认文件来自此仓库的 Release。
>
> 源码以 GNU GPL v3.0（仅第 3 版）发布。问题与使用反馈请提交 Issue。

将 DMG 和 EXE 作为 Release assets 上传；如希望附带说明，可同时上传 `QuietPin-1.0.0-Windows-x64.zip`。仓库根目录的 `dist/` 已被忽略，安装包不会随源码提交。
