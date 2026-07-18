import Foundation

/// Formats large statistics into short human-readable strings
/// ("2.1 billion", "43.5 million", "12,345").
public enum MetricFormatter {
    public static func compact(_ value: Double, locale: Locale = .autoupdatingCurrent) -> String {
        let absolute = abs(value)
        switch absolute {
        case 1_000_000_000_000...:
            return trimmed(value / 1_000_000_000_000) + " trillion"
        case 1_000_000_000...:
            return trimmed(value / 1_000_000_000) + " billion"
        case 1_000_000...:
            return trimmed(value / 1_000_000) + " million"
        default:
            return Int(value.rounded()).formatted(.number.grouping(.automatic).locale(locale))
        }
    }

    /// One decimal place, dropping a trailing ".0".
    private static func trimmed(_ value: Double) -> String {
        let rounded = (value * 10).rounded() / 10
        if rounded == rounded.rounded() {
            return String(Int(rounded))
        }
        return String(format: "%.1f", rounded)
    }
}
