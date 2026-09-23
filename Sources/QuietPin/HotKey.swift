import AppKit
import Carbon

extension Preferences {
    var shortcutSafeIndex: Int { HotKey.labels.indices.contains(shortcut) ? shortcut : 0 }
    var shortcutLabel: String { customKeyLabel ?? HotKey.labels[shortcutSafeIndex] }
}

final class HotKey {
    static let labels = ["⌥ Space", "⌃ ⌥ Space", "⌘ ⇧ Space"]
    private var reference: EventHotKeyRef?
    private var handler: EventHandlerRef?
    var action: (() -> Void)?

    init() {
        var type = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { _, _, data in
            guard let data else { return OSStatus(eventNotHandledErr) }
            let owner = Unmanaged<HotKey>.fromOpaque(data).takeUnretainedValue()
            owner.action?()
            return noErr
        }, 1, &type, Unmanaged.passUnretained(self).toOpaque(), &handler)
    }

    @discardableResult
    func register(preferences: Preferences) -> OSStatus {
        unregister()
        let modifiers = [UInt32(optionKey), UInt32(controlKey | optionKey), UInt32(cmdKey | shiftKey)]
        let safe = preferences.shortcutSafeIndex
        return RegisterEventHotKey(preferences.customKeyCode ?? UInt32(kVK_Space), preferences.customModifiers ?? modifiers[safe],
            EventHotKeyID(signature: 0x5150494E, id: 1), GetApplicationEventTarget(), 0, &reference)
    }

    func unregister() {
        if let reference { UnregisterEventHotKey(reference); self.reference = nil }
    }

    deinit {
        if let reference { UnregisterEventHotKey(reference) }
        if let handler { RemoveEventHandler(handler) }
    }
}
