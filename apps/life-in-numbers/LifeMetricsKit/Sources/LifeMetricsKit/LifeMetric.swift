import Foundation

/// A single computed statistic, ready for display.
public struct LifeMetric: Identifiable, Equatable, Sendable {
    public enum Kind: String, CaseIterable, Sendable {
        case daysLived
        case weeksLived
        case monthsLived
        case hoursLived
        case secondsLived
        case heartbeats
        case breaths
        case hoursSlept
        case blinks
        case fullMoons
        case kilometersThroughSpace
        case tripsAroundSun
        case lifeProgress
    }

    public let kind: Kind
    public let title: String
    public let value: Double
    public let unit: String?
    public let detail: String
    /// SF Symbol name for the platform UIs.
    public let symbolName: String

    public var id: String { kind.rawValue }

    public init(kind: Kind, title: String, value: Double, unit: String?, detail: String, symbolName: String) {
        self.kind = kind
        self.title = title
        self.value = value
        self.unit = unit
        self.detail = detail
        self.symbolName = symbolName
    }
}
