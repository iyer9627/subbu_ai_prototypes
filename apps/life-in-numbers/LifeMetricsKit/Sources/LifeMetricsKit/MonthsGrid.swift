import Foundation

/// Data for the "life in months" grid: one cell per month of the expected
/// lifespan, 12 columns per row so each row is exactly one year of life.
public struct MonthsGrid: Equatable, Sendable {
    public static let columnsPerRow = 12

    public let totalMonths: Int
    public let monthsLived: Int

    public var rows: Int { Int((Double(totalMonths) / Double(Self.columnsPerRow)).rounded(.up)) }
    public var monthsRemaining: Int { max(0, totalMonths - monthsLived) }
    public var fractionLived: Double {
        guard totalMonths > 0 else { return 1 }
        return min(1, Double(monthsLived) / Double(totalMonths))
    }

    public func isLived(month index: Int) -> Bool { index < monthsLived }
    public func isCurrent(month index: Int) -> Bool { index == monthsLived && index < totalMonths }

    public init(profile: LifeProfile, asOf date: Date, calculator: LifeCalculator = LifeCalculator()) {
        self.totalMonths = profile.lifeExpectancyYears * Self.columnsPerRow
        self.monthsLived = min(totalMonths, calculator.monthsLived(for: profile, asOf: date))
    }

    // MARK: - Month index <-> date

    /// First day of the month `index` months after the birth month.
    public static func date(forMonthIndex index: Int, birthDate: Date, calendar: Calendar) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: birthDate)
        let startOfBirthMonth = calendar.date(from: comps) ?? birthDate
        return calendar.date(byAdding: .month, value: index, to: startOfBirthMonth) ?? startOfBirthMonth
    }

    /// Months between the birth month and `date`'s month (0 for the birth month).
    public static func monthIndex(for date: Date, birthDate: Date, calendar: Calendar) -> Int {
        let birth = calendar.dateComponents([.year, .month], from: birthDate)
        let target = calendar.dateComponents([.year, .month], from: date)
        guard let start = calendar.date(from: birth), let end = calendar.date(from: target) else { return 0 }
        return calendar.dateComponents([.month], from: start, to: end).month ?? 0
    }
}
