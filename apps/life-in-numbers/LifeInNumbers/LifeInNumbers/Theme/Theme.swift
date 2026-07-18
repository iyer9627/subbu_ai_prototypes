import SwiftUI

/// Watercolor-storybook palette: warm paper, ink, and muted pigments
/// (terracotta, dusty blue, sage) inspired by a Parisian watercolor sketch.
enum Theme {
    static let paper = Color(light: Color(red: 0.97, green: 0.95, blue: 0.90),
                             dark: Color(red: 0.15, green: 0.14, blue: 0.12))
    static let card = Color(light: Color(red: 1.0, green: 0.99, blue: 0.96),
                            dark: Color(red: 0.20, green: 0.19, blue: 0.17))
    static let ink = Color(light: Color(red: 0.23, green: 0.21, blue: 0.18),
                           dark: Color(red: 0.92, green: 0.90, blue: 0.85))
    static let inkSecondary = Color(light: Color(red: 0.45, green: 0.43, blue: 0.38),
                                    dark: Color(red: 0.70, green: 0.68, blue: 0.62))
    /// Muted rose — from the painted grid squares and the red beret, kept
    /// soft and neutral rather than orange.
    static let terracotta = Color(light: Color(red: 0.69, green: 0.47, blue: 0.44),
                                  dark: Color(red: 0.78, green: 0.56, blue: 0.53))
    static let dustyBlue = Color(light: Color(red: 0.45, green: 0.54, blue: 0.64),
                                 dark: Color(red: 0.56, green: 0.65, blue: 0.76))
    static let sage = Color(light: Color(red: 0.55, green: 0.60, blue: 0.44),
                            dark: Color(red: 0.62, green: 0.68, blue: 0.50))
    static let faded = Color(light: Color(red: 0.85, green: 0.82, blue: 0.75),
                             dark: Color(red: 0.30, green: 0.29, blue: 0.26))

    /// Pigments cycled across the metric cards — slate blue leads, keeping
    /// the app's overall cast neutral like the watercolor skies.
    static let pigments: [Color] = [dustyBlue, sage, terracotta]

    static func pigment(at index: Int) -> Color {
        pigments[index % pigments.count]
    }
}

extension Color {
    /// A color that adapts between light and dark appearance on both platforms.
    init(light: Color, dark: Color) {
        #if os(macOS)
        self = Color(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return NSColor(isDark ? dark : light)
        })
        #else
        self = Color(uiColor: UIColor { traits in
            UIColor(traits.userInterfaceStyle == .dark ? dark : light)
        })
        #endif
    }
}

/// Card container with the look of a scrap torn from a sketchbook: deckled
/// edges, warm paper fill, a faint pencil-line border.
struct PaperCard: ViewModifier {
    /// Stable per-card so the tear doesn't shimmer on re-render.
    @State private var seed = UInt64.random(in: 1...UInt64.max)

    func body(content: Content) -> some View {
        let shape = TornPaperShape(seed: seed)
        return content
            .background(
                shape
                    .fill(Theme.card)
                    .shadow(color: .black.opacity(0.10), radius: 5, y: 3)
            )
            .overlay(
                shape
                    .stroke(Theme.faded, lineWidth: 1)
            )
    }
}

extension View {
    func paperCard() -> some View { modifier(PaperCard()) }
}
