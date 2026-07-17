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
    static let terracotta = Color(light: Color(red: 0.77, green: 0.40, blue: 0.31),
                                  dark: Color(red: 0.85, green: 0.48, blue: 0.38))
    static let dustyBlue = Color(light: Color(red: 0.44, green: 0.54, blue: 0.66),
                                 dark: Color(red: 0.55, green: 0.65, blue: 0.78))
    static let sage = Color(light: Color(red: 0.55, green: 0.60, blue: 0.44),
                            dark: Color(red: 0.62, green: 0.68, blue: 0.50))
    static let faded = Color(light: Color(red: 0.85, green: 0.82, blue: 0.75),
                             dark: Color(red: 0.30, green: 0.29, blue: 0.26))

    /// Pigments cycled across the metric cards.
    static let pigments: [Color] = [terracotta, dustyBlue, sage]

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

/// Card container with the soft, hand-drawn look used across the app.
struct PaperCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Theme.card)
                    .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Theme.faded, lineWidth: 1)
            )
    }
}

extension View {
    func paperCard() -> some View { modifier(PaperCard()) }
}
