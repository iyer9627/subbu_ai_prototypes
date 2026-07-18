import Foundation

/// The one flavor of content a user picks to tailor quotes and number
/// facts across the app. Single-select by design — keeps choices simple.
public enum Interest: String, CaseIterable, Codable, Sendable, Identifiable {
    case books = "Books"
    case popCulture = "Pop culture"
    case sports = "Sports"
    case movies = "Movies"
    case tv = "TV shows"
    case music = "Music"
    case tech = "Tech"

    public var id: String { rawValue }

    public var symbolName: String {
        switch self {
        case .books: "book"
        case .popCulture: "sparkles"
        case .sports: "figure.run"
        case .movies: "film"
        case .tv: "tv"
        case .music: "music.note"
        case .tech: "cpu"
        }
    }
}
