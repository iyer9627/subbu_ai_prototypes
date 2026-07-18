import Foundation

/// A personal memory pinned to one month of a life — the unit of the
/// life-in-months diary. Kept deliberately simple: an icon, a short title,
/// and an optional note, all editable to the month.
public struct LifeEvent: Codable, Identifiable, Equatable, Sendable {
    public var id: UUID
    /// Months since the birth month (0 = the month of birth).
    public var monthIndex: Int
    public var title: String
    /// SF Symbol shown in the grid cell and diary list.
    public var symbolName: String
    public var note: String?

    public init(id: UUID = UUID(), monthIndex: Int, title: String, symbolName: String, note: String? = nil) {
        self.id = id
        self.monthIndex = monthIndex
        self.title = title
        self.symbolName = symbolName
        self.note = note
    }
}

extension LifeEvent {
    /// Approximate common milestones used to pre-seed a new diary, placed at
    /// typical ages. Only milestones the user has already lived past are
    /// returned — every one is meant to be moved to its real month.
    public static func starterEvents(monthsLived: Int) -> [LifeEvent] {
        let candidates: [(months: Int, title: String, symbol: String)] = [
            (0, "The day I was born", "sun.max"),
            (12, "First words", "bubble.left"),
            (14, "First steps", "figure.walk"),
            (66, "Started school", "backpack"),
            (156, "First crush", "heart"),
            (216, "Finished school", "graduationcap"),
            (264, "First job", "briefcase"),
        ]
        return candidates
            .filter { $0.months <= monthsLived }
            .map { LifeEvent(monthIndex: $0.months, title: $0.title, symbolName: $0.symbol) }
    }
}
