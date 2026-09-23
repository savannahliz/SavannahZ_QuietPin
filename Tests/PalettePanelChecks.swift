import AppKit

@main
struct PalettePanelChecks {
    @MainActor static func main() {
        let app = NSApplication.shared
        app.setActivationPolicy(.accessory)
        let suite = "QuietPin.PalettePanelTest.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        let store = Store(directory: FileManager.default.temporaryDirectory.appendingPathComponent(suite), defaults: defaults)
        let coordinator = PaletteButton.Coordinator(store: store)
        store.saveCurrentColor()
        store.preferences.background = BackgroundColor(NSColor(srgbRed: 0.7, green: 0.8, blue: 0.9, alpha: 0.8))
        store.saveCurrentColor()
        coordinator.open()
        store.preferences.background = store.preferences.savedColors![0]
        precondition(BackgroundColor(NSColorPanel.shared.color).paletteKey == store.preferences.background.paletteKey)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withExtendedLifetime(coordinator) {
                let panel = NSColorPanel.shared
                let view = panel.contentView!
                view.layoutSubtreeIfNeeded()
                precondition(panel.accessoryView!.frame.height >= 130)
                let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds)!
                view.cacheDisplay(in: view.bounds, to: bitmap)
                try! bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: ".build/palette-panel.png"))
                print("PASS: native color panel accessory layout and saved-color synchronization")
                panel.orderOut(nil)
                defaults.removePersistentDomain(forName: suite)
                app.terminate(nil)
            }
        }
        app.run()
    }
}
