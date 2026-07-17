import Foundation

/// Computes life statistics from a profile at a given moment.
///
/// All physiological figures use well-known population averages, documented in
/// `Rates`. Every function takes an explicit `asOf` date and `Calendar` so
/// results are deterministic and testable.
public struct LifeCalculator: Sendable {
    /// Population-average rates behind the estimated metrics.
    public enum Rates {
        /// Average resting heart rate, beats per minute.
        public static let heartbeatsPerMinute = 70.0
        /// Average respiratory rate, breaths per minute.
        public static let breathsPerMinute = 14.0
        /// Average sleep per day, in hours.
        public static let sleepHoursPerDay = 8.0
        /// Average blink rate while awake, blinks per minute.
        public static let blinksPerAwakeMinute = 15.0
        /// Length of a lunar synodic month, in days.
        public static let synodicMonthDays = 29.530589
        /// Distance Earth travels around the Sun per year, in kilometers.
        public static let orbitKilometersPerYear = 940_000_000.0
    }

    public let calendar: Calendar

    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    // MARK: - Elapsed time

    public func secondsLived(for profile: LifeProfile, asOf date: Date) -> Double {
        max(0, date.timeIntervalSince(profile.birthDate))
    }

    public func daysLived(for profile: LifeProfile, asOf date: Date) -> Int {
        let start = calendar.startOfDay(for: profile.birthDate)
        let end = calendar.startOfDay(for: date)
        return max(0, calendar.dateComponents([.day], from: start, to: end).day ?? 0)
    }

    public func weeksLived(for profile: LifeProfile, asOf date: Date) -> Int {
        daysLived(for: profile, asOf: date) / 7
    }

    public func monthsLived(for profile: LifeProfile, asOf date: Date) -> Int {
        max(0, calendar.dateComponents([.month], from: profile.birthDate, to: date).month ?? 0)
    }

    public func ageYears(for profile: LifeProfile, asOf date: Date) -> Int {
        max(0, calendar.dateComponents([.year], from: profile.birthDate, to: date).year ?? 0)
    }

    /// Fraction of the expected lifespan already lived, clamped to 0...1.
    public func lifeProgress(for profile: LifeProfile, asOf date: Date) -> Double {
        let expected = expectedEndDate(for: profile)
        let total = expected.timeIntervalSince(profile.birthDate)
        guard total > 0 else { return 1 }
        return min(1, max(0, date.timeIntervalSince(profile.birthDate) / total))
    }

    public func expectedEndDate(for profile: LifeProfile) -> Date {
        calendar.date(byAdding: .year, value: profile.lifeExpectancyYears, to: profile.birthDate) ?? profile.birthDate
    }

    // MARK: - Estimated body counts

    public func heartbeats(for profile: LifeProfile, asOf date: Date) -> Double {
        secondsLived(for: profile, asOf: date) / 60 * Rates.heartbeatsPerMinute
    }

    public func breaths(for profile: LifeProfile, asOf date: Date) -> Double {
        secondsLived(for: profile, asOf: date) / 60 * Rates.breathsPerMinute
    }

    public func hoursSlept(for profile: LifeProfile, asOf date: Date) -> Double {
        secondsLived(for: profile, asOf: date) / 86_400 * Rates.sleepHoursPerDay
    }

    public func blinks(for profile: LifeProfile, asOf date: Date) -> Double {
        let awakeFraction = (24 - Rates.sleepHoursPerDay) / 24
        return secondsLived(for: profile, asOf: date) / 60 * awakeFraction * Rates.blinksPerAwakeMinute
    }

    // MARK: - Cosmic

    public func fullMoonsSeen(for profile: LifeProfile, asOf date: Date) -> Int {
        Int(secondsLived(for: profile, asOf: date) / 86_400 / Rates.synodicMonthDays)
    }

    public func kilometersThroughSpace(for profile: LifeProfile, asOf date: Date) -> Double {
        secondsLived(for: profile, asOf: date) / 86_400 / 365.25 * Rates.orbitKilometersPerYear
    }

    // MARK: - Dashboard

    /// Every metric for the dashboard, in display order.
    public func allMetrics(for profile: LifeProfile, asOf date: Date = Date()) -> [LifeMetric] {
        let seconds = secondsLived(for: profile, asOf: date)
        let days = daysLived(for: profile, asOf: date)
        return [
            LifeMetric(
                kind: .daysLived,
                title: "Days Lived",
                value: Double(days),
                unit: "days",
                detail: "Every sunrise since you arrived.",
                symbolName: "sun.max"
            ),
            LifeMetric(
                kind: .weeksLived,
                title: "Weeks Lived",
                value: Double(weeksLived(for: profile, asOf: date)),
                unit: "weeks",
                detail: "Each one a box in your life grid.",
                symbolName: "square.grid.3x3"
            ),
            LifeMetric(
                kind: .monthsLived,
                title: "Months Lived",
                value: Double(monthsLived(for: profile, asOf: date)),
                unit: "months",
                detail: "Calendar pages turned so far.",
                symbolName: "calendar"
            ),
            LifeMetric(
                kind: .hoursLived,
                title: "Hours Lived",
                value: (seconds / 3_600).rounded(.down),
                unit: "hours",
                detail: "Time is the only nonrenewable resource.",
                symbolName: "clock"
            ),
            LifeMetric(
                kind: .secondsLived,
                title: "Seconds Lived",
                value: seconds.rounded(.down),
                unit: "seconds",
                detail: "Counting up as you read this.",
                symbolName: "stopwatch"
            ),
            LifeMetric(
                kind: .heartbeats,
                title: "Heartbeats",
                value: heartbeats(for: profile, asOf: date),
                unit: "beats",
                detail: "At an average of 70 beats per minute.",
                symbolName: "heart"
            ),
            LifeMetric(
                kind: .breaths,
                title: "Breaths Taken",
                value: breaths(for: profile, asOf: date),
                unit: "breaths",
                detail: "At an average of 14 breaths per minute.",
                symbolName: "wind"
            ),
            LifeMetric(
                kind: .hoursSlept,
                title: "Hours Asleep",
                value: hoursSlept(for: profile, asOf: date),
                unit: "hours",
                detail: "Assuming 8 hours a night — about a third of your life.",
                symbolName: "moon.zzz"
            ),
            LifeMetric(
                kind: .blinks,
                title: "Blinks",
                value: blinks(for: profile, asOf: date),
                unit: "blinks",
                detail: "Around 15 per waking minute.",
                symbolName: "eye"
            ),
            LifeMetric(
                kind: .fullMoons,
                title: "Full Moons",
                value: Double(fullMoonsSeen(for: profile, asOf: date)),
                unit: "moons",
                detail: "One every 29.5 days.",
                symbolName: "moonphase.full.moon"
            ),
            LifeMetric(
                kind: .kilometersThroughSpace,
                title: "Distance Around the Sun",
                value: kilometersThroughSpace(for: profile, asOf: date),
                unit: "km",
                detail: "Earth carries you 940 million km per orbit.",
                symbolName: "globe.americas"
            ),
            LifeMetric(
                kind: .tripsAroundSun,
                title: "Trips Around the Sun",
                value: Double(ageYears(for: profile, asOf: date)),
                unit: "orbits",
                detail: "Also known as your age.",
                symbolName: "sun.and.horizon"
            ),
            LifeMetric(
                kind: .lifeProgress,
                title: "Life Progress",
                value: lifeProgress(for: profile, asOf: date) * 100,
                unit: "%",
                detail: "Of a \(profile.lifeExpectancyYears)-year expected lifespan.",
                symbolName: "chart.bar.fill"
            )
        ]
    }
}
