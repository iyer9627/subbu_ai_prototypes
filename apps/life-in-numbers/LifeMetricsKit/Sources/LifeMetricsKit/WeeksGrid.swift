import Foundation

/// Data for the "your life in weeks" grid: one cell per week of the expected
/// lifespan, 52 columns per row so each row is roughly one year.
public struct WeeksGrid: Equatable, Sendable {
    public static let columnsPerRow = 52

    public let totalWeeks: Int
    public let weeksLived: Int

    public var rows: Int { Int((Double(totalWeeks) / Double(Self.columnsPerRow)).rounded(.up)) }
    public var weeksRemaining: Int { max(0, totalWeeks - weeksLived) }
    public var fractionLived: Double {
        guard totalWeeks > 0 else { return 1 }
        return min(1, Double(weeksLived) / Double(totalWeeks))
    }

    public func isLived(week index: Int) -> Bool { index < weeksLived }
    public func isCurrent(week index: Int) -> Bool { index == weeksLived && index < totalWeeks }

    public init(profile: LifeProfile, asOf date: Date, calculator: LifeCalculator = LifeCalculator()) {
        self.totalWeeks = profile.lifeExpectancyYears * Self.columnsPerRow
        self.weeksLived = min(totalWeeks, calculator.weeksLived(for: profile, asOf: date))
    }
}
