import AppKit
import SwiftUI
import Combine

struct SavedColorShelf: View {
    @ObservedObject var store: Store
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(store.currentColorIsSaved ? "已保存" : "保存颜色") { store.saveCurrentColor() }
                .disabled(store.currentColorIsSaved)
                .frame(width: 86)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 26), spacing: 5)], spacing: 5) {
                    ForEach(store.preferences.savedColors ?? [], id: \.paletteKey) { color in
                        Button { store.preferences.background = color } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(color.color)
                                .frame(height: 26)
                                .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(
                                    color.paletteKey == store.preferences.background.paletteKey ? Color.accentColor : Color.gray.opacity(0.5),
                                    lineWidth: color.paletteKey == store.preferences.background.paletteKey ? 2 : 1))
                        }
                        .buttonStyle(.plain)
                        .help("使用 \(color.paletteKey) · 右键删除")
                        .accessibilityLabel("收藏颜色 \(color.paletteKey)")
                        .contextMenu {
                            Button("删除保存的颜色", role: .destructive) { store.removeSavedColor(color) }
                        }
                    }
                }
                if (store.preferences.savedColors ?? []).isEmpty {
                    Text("保存后显示在这里\n点击使用 · 右键删除")
                        .font(.caption).foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(height: 88)
        }
    }
}

struct PaletteButton: NSViewRepresentable {
    let store: Store
    func makeCoordinator() -> Coordinator { Coordinator(store: store) }
    func makeNSView(context: Context) -> NSButton {
        let button = NSButton(title: "打开系统调色盘…", target: context.coordinator, action: #selector(Coordinator.open))
        button.bezelStyle = .rounded
        return button
    }
    func updateNSView(_ button: NSButton, context: Context) {}

    @MainActor final class Coordinator: NSObject {
        let store: Store
        private var subscription: AnyCancellable?
        private var syncingColor = false
        init(store: Store) { self.store = store }
        @objc func open() {
            let panel = NSColorPanel.shared
            panel.title = "背景颜色 · QuietPin"
            panel.showsAlpha = true
            panel.isContinuous = true
            panel.color = store.preferences.background.nsColor
            panel.setTarget(self)
            panel.setAction(#selector(changed(_:)))
            let accessory = NSHostingView(rootView: VStack(alignment: .leading, spacing: 8) {
                Text("QuietPin 收藏色").font(.headline)
                SavedColorShelf(store: store)
            }.padding(12))
            accessory.frame = NSRect(x: 0, y: 0, width: 330, height: 140)
            accessory.autoresizingMask = [.width]
            panel.accessoryView = accessory
            panel.level = .floating
            subscription = store.$preferences.sink { [weak self, weak panel] prefs in
                guard let self, let panel, BackgroundColor(panel.color).paletteKey != prefs.background.paletteKey else { return }
                self.syncingColor = true
                panel.color = prefs.background.nsColor
                self.syncingColor = false
            }
            panel.makeKeyAndOrderFront(nil)
        }
        @objc private func changed(_ panel: NSColorPanel) {
            guard !syncingColor else { return }
            let color = BackgroundColor(panel.color)
            if color != store.preferences.background { store.preferences.background = color }
        }
    }
}
