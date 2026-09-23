import SwiftUI

struct AppearancePreview: View {
    @ObservedObject var store: Store
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("实时预览").font(.system(size: 12, weight: .medium))
            HStack(spacing: 10) {
                note("便签 · 闲置", opacity: store.preferences.fadeOnLeave ? store.preferences.idleOpacity : store.preferences.activeOpacity)
                note("便签 · 交互", opacity: store.preferences.activeOpacity)
            }
            Text("快速输入").font(.system(size: 10)).foregroundStyle(.secondary)
            ZStack {
                checkerboard
                HStack(spacing: 6) {
                    HStack(spacing: 7) {
                        Image(systemName: "square.and.pencil")
                        Text("记下此刻的想法…").font(.system(size: 11))
                        Spacer()
                    }
                    .padding(.horizontal, 12).frame(height: 36)
                    .background(Capsule().fill(store.preferences.background.color))
                    Image(systemName: "xmark").font(.system(size: 11))
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(store.preferences.background.color))
                }
                .padding(9)
                .foregroundStyle(store.preferences.background.isDark ? Color.white : Color.black)
                .opacity(store.preferences.captureOpacity ?? 0.95)
            }.frame(height: 56).clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.vertical, 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("实时透明度预览")
        .accessibilityValue("便签闲置 \(Int((store.preferences.fadeOnLeave ? store.preferences.idleOpacity : store.preferences.activeOpacity) * 100))%，交互 \(Int(store.preferences.activeOpacity * 100))%，快速输入 \(Int((store.preferences.captureOpacity ?? 0.95) * 100))%")
    }

    private func note(_ label: String, opacity: Double) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.system(size: 10)).foregroundStyle(.secondary)
            ZStack {
                checkerboard
                VStack(alignment: .leading, spacing: 6) {
                    Text("Inbox").font(.system(size: 11, weight: .semibold))
                    Label("一件要记住的事", systemImage: "circle").font(.system(size: 10))
                }
                .frame(maxWidth: .infinity, alignment: .leading).padding(10)
                .foregroundStyle(store.preferences.background.isDark ? Color.white : Color.black)
                .background(RoundedRectangle(cornerRadius: 9).fill(store.preferences.background.color))
                .padding(7).opacity(opacity)
            }.frame(height: 70).clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var checkerboard: some View {
        Canvas { context, size in
            for row in 0...Int(size.height / 8) {
                for column in 0...Int(size.width / 8) {
                    context.fill(Path(CGRect(x: column * 8, y: row * 8, width: 8, height: 8)),
                                 with: .color((row + column).isMultiple(of: 2) ? Color(white: 0.93) : Color(white: 0.80)))
                }
            }
        }
    }
}
