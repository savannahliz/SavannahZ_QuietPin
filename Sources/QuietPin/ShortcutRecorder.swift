import AppKit
import SwiftUI
import Carbon

struct ShortcutRecorder: View {
    @ObservedObject var store: Store
    var body: some View {
        HStack {
            Text("全局快捷键")
            Spacer()
            RecorderButton(store: store).frame(width: 190, height: 28)
        }
    }
}

private struct RecorderButton: NSViewRepresentable {
    let store: Store
    func makeNSView(context: Context) -> KeyRecorderButton {
        let button = KeyRecorderButton()
        button.bezelStyle = .rounded
        button.store = store
        button.target = button
        button.action = #selector(KeyRecorderButton.beginRecording)
        button.title = store.preferences.shortcutLabel
        button.setAccessibilityLabel("录制自定义快捷键")
        return button
    }
    func updateNSView(_ button: KeyRecorderButton, context: Context) {
        if !button.recording { button.title = store.preferences.shortcutLabel }
    }
}

private final class KeyRecorderButton: NSButton {
    var store: Store!
    var recording = false
    override var acceptsFirstResponder: Bool { true }

    override func mouseDown(with event: NSEvent) {
        beginRecording()
    }

    @objc func beginRecording() {
        recording = true
        store.recordingShortcut = true
        title = "请按组合键 · Esc 取消"
        window?.makeFirstResponder(self)
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if recording { keyDown(with: event); return true }
        return super.performKeyEquivalent(with: event)
    }

    override func keyDown(with event: NSEvent) {
        guard recording else { super.keyDown(with: event); return }
        if event.keyCode == 53 { finish(); return }
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        guard !flags.intersection([.command, .option, .control]).isEmpty else {
            title = "请包含 ⌘、⌥ 或 ⌃"
            return
        }
        var carbon: UInt32 = 0
        var label = ""
        for (flag, mask, text) in [(NSEvent.ModifierFlags.control, controlKey, "⌃"),
                                   (.option, optionKey, "⌥"), (.shift, shiftKey, "⇧"), (.command, cmdKey, "⌘")] {
            if flags.contains(flag) { carbon |= UInt32(mask); label += text }
        }
        let names: [UInt16: String] = [49: "Space", 36: "Return", 48: "Tab", 51: "Delete", 123: "←", 124: "→", 125: "↓", 126: "↑"]
        let key = names[event.keyCode] ?? event.charactersIgnoringModifiers?.uppercased() ?? "Key \(event.keyCode)"
        store.preferences.customKeyCode = UInt32(event.keyCode)
        store.preferences.customModifiers = carbon
        store.preferences.customKeyLabel = label + " " + key
        finish()
    }

    override func resignFirstResponder() -> Bool { finish(); return super.resignFirstResponder() }
    private func finish() {
        recording = false
        store.recordingShortcut = false
        title = store.preferences.shortcutLabel
    }
}
