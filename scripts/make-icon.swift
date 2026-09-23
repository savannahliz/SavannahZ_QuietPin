import AppKit
import Foundation

let directory = URL(fileURLWithPath: ".build/QuietPin.iconset", isDirectory: true)
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
for size in [16, 32, 128, 256, 512] {
    for scale in [1, 2] {
        let pixels = size * scale
        let image = NSImage(size: NSSize(width: pixels, height: pixels))
        image.lockFocus()
        let p = CGFloat(pixels)
        NSColor(srgbRed: 0.88, green: 0.89, blue: 0.83, alpha: 1).setFill()
        NSBezierPath(roundedRect: NSRect(x: p * 0.06, y: p * 0.06, width: p * 0.88, height: p * 0.88), xRadius: p * 0.2, yRadius: p * 0.2).fill()
        NSColor(srgbRed: 0.28, green: 0.37, blue: 0.31, alpha: 1).setStroke()
        let lines = NSBezierPath()
        lines.lineWidth = p * 0.055
        lines.lineCapStyle = .round
        for (y, end) in [(0.62, 0.72), (0.47, 0.63), (0.32, 0.54)] {
            lines.move(to: NSPoint(x: p * 0.29, y: p * y))
            lines.line(to: NSPoint(x: p * end, y: p * y))
        }
        lines.stroke()
        image.unlockFocus()
        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
        let name = "icon_\(size)x\(size)\(scale == 2 ? "@2x" : "").png"
        try bitmap.representation(using: .png, properties: [:])!.write(to: directory.appendingPathComponent(name))
    }
}
