import SwiftUI
import CoreText

/// EB Garamond (SIL OFL) — a mystical, bookish serif kept deliberately
/// large so it stays legible for older readers. Sizes scale with Dynamic
/// Type via `relativeTo`.
enum AppFont {
    static func serif(_ style: Font.TextStyle, _ weight: Font.Weight = .regular) -> Font {
        .custom(fontName(for: weight), size: baseSize(for: style), relativeTo: style)
    }

    static func serifItalic(_ style: Font.TextStyle) -> Font {
        .custom("EBGaramond-Italic", size: baseSize(for: style), relativeTo: style)
    }

    private static func fontName(for weight: Font.Weight) -> String {
        switch weight {
        case .semibold, .bold, .heavy, .black: "EBGaramond-SemiBold"
        case .medium: "EBGaramond-Medium"
        default: "EBGaramond-Regular"
        }
    }

    /// A touch larger than the system defaults — Garamond runs small, and
    /// legibility beats density here.
    private static func baseSize(for style: Font.TextStyle) -> CGFloat {
        switch style {
        case .largeTitle: 38
        case .title: 32
        case .title2: 26
        case .title3: 23
        case .headline: 20
        case .body: 19
        case .callout: 18
        case .subheadline: 17
        case .footnote: 15
        case .caption: 14
        case .caption2: 13
        @unknown default: 19
        }
    }

    /// Registers the bundled EB Garamond faces. Call once at launch.
    static func registerFonts() {
        for name in ["EBGaramond-Regular", "EBGaramond-Medium", "EBGaramond-SemiBold", "EBGaramond-Italic"] {
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
