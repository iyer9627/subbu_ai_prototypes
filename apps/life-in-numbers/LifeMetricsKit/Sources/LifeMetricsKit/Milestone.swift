import Foundation

/// A notable round-number moment in a life, past or upcoming.
public struct Milestone: Identifiable, Equatable, Sendable {
    public let title: String
    public let detail: String
    public let date: Date
    public let symbolName: String

    public var id: String { "\(title)-\(date.timeIntervalSinceReferenceDate)" }

    public init(title: String, detail: String, date: Date, symbolName: String) {
        self.title = title
        self.detail = detail
        self.date = date
        self.symbolName = symbolName
    }
}

/// Generates upcoming round-number milestones from a profile.
public struct MilestoneGenerator: Sendable {
    public let calendar: Calendar
    private let calculator: LifeCalculator

    public init(calendar: Calendar = .current) {
        self.calendar = calendar
        self.calculator = LifeCalculator(calendar: calendar)
    }

    /// Upcoming milestones sorted by date, soonest first.
    public func upcomingMilestones(for profile: LifeProfile, asOf date: Date = Date(), limit: Int = 8) -> [Milestone] {
        var milestones: [Milestone] = []
        milestones.append(contentsOf: roundNumberDays(for: profile, asOf: date))
        milestones.append(contentsOf: roundNumberWeeks(for: profile, asOf: date))
        milestones.append(contentsOf: billionSeconds(for: profile, asOf: date))
        if let birthday = nextBirthday(for: profile, asOf: date) {
            milestones.append(birthday)
        }
        if let halfway = halfwayPoint(for: profile, asOf: date) {
            milestones.append(halfway)
        }
        return Array(milestones.sorted { $0.date < $1.date }.prefix(limit))
    }

    /// Next multiples of 1,000 days (10,000th day, 11,000th day, ...).
    func roundNumberDays(for profile: LifeProfile, asOf date: Date, count: Int = 3) -> [Milestone] {
        let lived = calculator.daysLived(for: profile, asOf: date)
        let start = calendar.startOfDay(for: profile.birthDate)
        return (1...count).compactMap { step in
            let target = ((lived / 1_000) + step) * 1_000
            guard let when = calendar.date(byAdding: .day, value: target, to: start) else { return nil }
            return Milestone(
                title: "Day \(target.formatted(.number.grouping(.automatic)))",
                detail: "Your \(ordinal(target)) day on Earth",
                date: when,
                symbolName: "sun.max"
            )
        }
    }

    /// Next multiples of 500 weeks.
    func roundNumberWeeks(for profile: LifeProfile, asOf date: Date, count: Int = 2) -> [Milestone] {
        let lived = calculator.weeksLived(for: profile, asOf: date)
        let start = calendar.startOfDay(for: profile.birthDate)
        return (1...count).compactMap { step in
            let target = ((lived / 500) + step) * 500
            guard let when = calendar.date(byAdding: .day, value: target * 7, to: start) else { return nil }
            return Milestone(
                title: "Week \(target.formatted(.number.grouping(.automatic)))",
                detail: "Your \(ordinal(target)) week — box \(target.formatted(.number.grouping(.automatic))) in the grid",
                date: when,
                symbolName: "square.grid.3x3"
            )
        }
    }

    /// Next whole billion seconds (1 billion ≈ 31.7 years).
    func billionSeconds(for profile: LifeProfile, asOf date: Date, count: Int = 1) -> [Milestone] {
        let lived = calculator.secondsLived(for: profile, asOf: date)
        let billion = 1_000_000_000.0
        return (1...count).map { step in
            let target = (floor(lived / billion) + Double(step)) * billion
            let when = profile.birthDate.addingTimeInterval(target)
            let n = Int(target / billion)
            return Milestone(
                title: "\(n.formatted(.number.grouping(.automatic))) Billion Seconds",
                detail: "A billion seconds is about 31.7 years",
                date: when,
                symbolName: "stopwatch"
            )
        }
    }

    func nextBirthday(for profile: LifeProfile, asOf date: Date) -> Milestone? {
        let age = calculator.ageYears(for: profile, asOf: date)
        guard let when = calendar.date(byAdding: .year, value: age + 1, to: profile.birthDate) else { return nil }
        return Milestone(
            title: "Birthday \(age + 1)",
            detail: "Completing your \(ordinal(age + 1)) trip around the Sun",
            date: when,
            symbolName: "birthday.cake"
        )
    }

    /// The midpoint of the expected lifespan, if it is still ahead.
    func halfwayPoint(for profile: LifeProfile, asOf date: Date) -> Milestone? {
        let end = calculator.expectedEndDate(for: profile)
        let halfway = profile.birthDate.addingTimeInterval(end.timeIntervalSince(profile.birthDate) / 2)
        guard halfway > date else { return nil }
        return Milestone(
            title: "Halfway Point",
            detail: "Half of a \(profile.lifeExpectancyYears)-year expected lifespan",
            date: halfway,
            symbolName: "chart.pie"
        )
    }

    private func ordinal(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)th"
    }
}
