# QuietPin

[简体中文](README.md) · [English](README.en.md)

A small desktop Inbox for fleeting thoughts. Capture an idea without breaking your flow, then keep only your three most important items in sight.

![QuietPin product overview (Chinese)](docs/images/quietpin-cover.png)

When you are juggling AI tools and parallel tasks, a new idea can interrupt the work in front of you. QuietPin opens a quick-capture bar with a global shortcut. Write it down, send it to your Inbox, and return to what you were doing.

QuietPin is available for macOS and Windows. Notes stay on your device; no account, cloud sync, or AI service is required.

If QuietPin helps you, a ⭐️ on the [GitHub repository](https://github.com/savannahliz/SavannahZ_QuietPin) is appreciated.

## Features

- **Quick capture:** Open the centered input bar with a global shortcut. Press Enter to save to Inbox or Esc to cancel. The capture shortcut and submit key are configurable. New items are unpinned by default; the cancel button appears on hover.
- **Three pins:** Keep up to three items pinned. Pinning a fourth asks which current pin to replace; the replaced item remains in Inbox.
- **Three display states:** Full Inbox, pinned items only, or a slim single-line strip. Drag, resize, keep on top, or tuck the window against either side of the screen.
- **Personal appearance:** Choose a background color, save favorite colors, and adjust the opacity of the note at rest, on interaction, and during quick capture.
- **Completed items:** Restore completed items or clear them all. The first clear asks for confirmation, which you can choose not to see again.
- **Local persistence:** Notes, window position, and settings are restored after restarting.

## Download and use

Download installers from [Releases](https://github.com/savannahliz/SavannahZ_QuietPin/releases/tag/v1.0.2). The source-code archives are not runnable apps.

| Platform | File | Default capture shortcut |
| --- | --- | --- |
| macOS 13+, Apple Silicon / Intel | `QuietPin-1.0.2-macOS-universal.dmg` | Option + Space |
| Windows 10/11 x64 | `QuietPin-1.0.2-Windows-x64.exe` | Ctrl + Alt + Space |

On Mac, open the DMG, drag QuietPin into Applications, and launch it. The app lives in the menu bar, not the Dock. On Windows, run the EXE; no separate .NET installation is needed. The app is available from the system tray.

Changing a color applies it immediately. To reuse it later, click Save Color in the color panel or settings. Click a saved swatch to restore it, or right-click one to remove it.

### macOS says “QuietPin” Not Opened

The current DMG is not signed with an Apple Developer ID or notarized. macOS may show “Apple could not verify ‘QuietPin’ is free of malware,” with **Move to Trash** and **Done** buttons. This is not a malware detection, but it is also not a safety certification. First verify that your installer came from this repository's Releases page. If you cannot verify its source, do not proceed.

If you trust the source, follow [Apple's official instructions](https://support.apple.com/en-us/102445):

1. Click **Done**, not **Move to Trash**.
2. Open **System Settings → Privacy & Security**, then scroll down to **Security**.
3. Find the notice for QuietPin and click **Open Anyway**.
4. Confirm **Open** when prompted and authenticate if required. You should then be able to launch it normally.

Changing “Allow applications downloaded from” to “App Store and identified developers” alone does **not** replace **Open Anyway** for this unsigned release. You do not need to disable Gatekeeper or run a Terminal command. Eliminating this first-launch warning requires a future release signed with Developer ID and notarized by Apple.

The Windows installer is also not formally code-signed and may display a security warning on first launch.

## Local data

- macOS: `~/Library/Application Support/QuietPin/inbox.json`; settings are stored in UserDefaults.
- Windows: `%LOCALAPPDATA%\QuietPin\inbox.json`; notes and settings are stored in the same file.

There is no cross-device sync or Mac/Windows data-format interoperability yet. Quit the app before backing up the data file. On Mac, appearance and window preferences need a separate backup of system preferences.

## Build from source

### macOS

Requires macOS 13+ and Xcode Command Line Tools. The app uses SwiftUI, AppKit, and Carbon, with no third-party code dependencies.

```sh
bash scripts/test-macos.sh
bash scripts/build-macos.sh
```

The build produces `dist/QuietPin.app` and a DMG in `dist/`. The script compiles Apple Silicon and Intel binaries and combines them into a universal app.

### Windows

Requires the .NET 10 SDK. The Windows app uses WPF and Win32 and publishes as a self-contained x64 EXE.

```powershell
dotnet run --project windows/Tests/CoreChecks.csproj -c Release
dotnet publish windows/QuietPin.Windows.csproj -c Release -r win-x64 --self-contained true -o dist/windows-x64
```

On macOS, you can also point `DOTNET_BIN` to the .NET 10 SDK and run `bash scripts/build-windows.sh` to cross-compile the Windows package.

## Verification status

The macOS data model, saved colors, window modes, screen-edge behavior, and quick capture have automated tests. The Windows app has passed cross-compilation and data-model checks, but its UI, global shortcuts, multi-monitor behavior, and launch-on-login have not yet been tested on a physical Windows machine. Intel Mac, full-screen apps, and multiple desktops have not all been tested individually either.

Please report reproducible issues through GitHub Issues, including your OS version and steps to reproduce. Check logs and screenshots for private notes before sharing them.

## License

QuietPin is released under [GNU GPL v3.0](LICENSE) (version 3 only).
