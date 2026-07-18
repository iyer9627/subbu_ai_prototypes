import SwiftUI

/// Watercolor artwork for the memory icons where one exists, falling back
/// to the SF Symbol. The tiny life-grid cells keep symbols (they stay
/// legible at 25 px); the editor and diary list get the paintings.
enum MemoryIconArt {
    static let assets: [String: String] = [
        "sun.max": "MemoryIcon-sun",
        "figure.walk": "MemoryIcon-walk",
        "backpack": "MemoryIcon-backpack",
        "graduationcap": "MemoryIcon-gradcap",
        "heart": "MemoryIcon-heart",
        "briefcase": "MemoryIcon-briefcase",
        "house": "MemoryIcon-house",
        "airplane": "MemoryIcon-plane",
        "music.note": "MemoryIcon-music",
        "pawprint": "MemoryIcon-paw",
        "trophy": "MemoryIcon-trophy",
        "gift": "MemoryIcon-gift",
    ]
}

struct MemoryIconView: View {
    let symbolName: String

    var body: some View {
        if let asset = MemoryIconArt.assets[symbolName] {
            Image(asset)
                .resizable()
                .scaledToFill()
        } else {
            Image(systemName: symbolName)
                .resizable()
                .scaledToFit()
                .padding(8)
                .foregroundStyle(.white)
        }
    }
}
