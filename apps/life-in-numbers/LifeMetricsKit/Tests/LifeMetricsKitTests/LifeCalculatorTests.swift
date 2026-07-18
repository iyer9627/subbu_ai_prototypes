import XCTest
@testable import LifeMetricsKit

final class LifeCalculatorTests: XCTestCase {
    var calendar: Calendar!
    var calculator: LifeCalculator!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        calculator = LifeCalculator(calendar: calendar)
    }

    private func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 0) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
    }

    // MARK: - Elapsed time

    func testDaysLivedExactDecade() {
        // 2000-01-01 to 2010-01-01 spans 3,653 days (leap years 2000, 2004, 2008).
        let profile = LifeProfile(birthDate: date(2000, 1, 1))
        XCTAssertEqual(calculator.daysLived(for: profile, asOf: date(2010, 1, 1)), 3_653)
    }

    func testDaysLivedIgnoresTimeOfDay() {
        let profile = LifeProfile(birthDate: date(2000, 1, 1, 23))
        XCTAssertEqual(calculator.daysLived(for: profile, asOf: date(2000, 1, 2, 1)), 1)
    }

    func testWeeksAndMonthsLived() {
        let profile = LifeProfile(birthDate: date(2000, 1, 1))
        let asOf = date(2001, 1, 1)
        XCTAssertEqual(calculator.weeksLived(for: profile, asOf: asOf), 52) // 366 / 7
        XCTAssertEqual(calculator.monthsLived(for: profile, asOf: asOf), 12)
        XCTAssertEqual(calculator.ageYears(for: profile, asOf: asOf), 1)
    }

    func testSecondsLivedOneDay() {
        let profile = LifeProfile(birthDate: date(2000, 1, 1))
        XCTAssertEqual(calculator.secondsLived(for: profile, asOf: date(2000, 1, 2)), 86_400)
    }

    func testFutureBirthDateClampsToZero() {
        let profile = LifeProfile(birthDate: date(2030, 1, 1))
        let asOf = date(2020, 1, 1)
        XCTAssertEqual(calculator.secondsLived(for: profile, asOf: asOf), 0)
        XCTAssertEqual(calculator.daysLived(for: profile, asOf: asOf), 0)
        XCTAssertEqual(calculator.lifeProgress(for: profile, asOf: asOf), 0)
    }

    // MARK: - Estimated counts

    func testHeartbeatsAndBreathsForOneDay() {
        let profile = LifeProfile(birthDate: date(2000, 1, 1))
        let asOf = date(2000, 1, 2)
        // 1,440 minutes at 70 bpm and 14 breaths/min.
        XCTAssertEqual(calculator.heartbeats(for: profile, asOf: asOf), 100_800, accuracy: 0.001)
        XCTAssertEqual(calculator.breaths(for: profile, asOf: asOf), 20_160, accuracy: 0.001)
    }

    func testSleepAndBlinksForOneDay() {
        let profile = LifeProfile(birthDate: date(2000, 1, 1))
        let asOf = date(2000, 1, 2)
        XCTAssertEqual(calculator.hoursSlept(for: profile, asOf: asOf), 8, accuracy: 0.001)
        // 16 awake hours * 60 minutes * 15 blinks.
        XCTAssertEqual(calculator.blinks(for: profile, asOf: asOf), 14_400, accuracy: 0.001)
    }

    func testFullMoonsInOneYear() {
        let profile = LifeProfile(birthDate: date(2000, 1, 1))
        // 365 days / 29.53 ≈ 12.36 → 12 full moons.
        XCTAssertEqual(calculator.fullMoonsSeen(for: profile, asOf: date(2000, 12, 31)), 12)
    }

    // MARK: - Life progress

    func testLifeProgressHalfway() {
        var profile = LifeProfile(birthDate: date(1980, 1, 1))
        profile.lifeExpectancyYears = 80
        let halfway = date(2020, 1, 1)
        XCTAssertEqual(calculator.lifeProgress(for: profile, asOf: halfway), 0.5, accuracy: 0.001)
    }

    func testLifeProgressClampsAtOne() {
        let profile = LifeProfile(birthDate: date(1900, 1, 1), lifeExpectancyYears: 80)
        XCTAssertEqual(calculator.lifeProgress(for: profile, asOf: date(2020, 1, 1)), 1)
    }

    // MARK: - Dashboard

    func testAllMetricsCoversEveryKind() {
        let profile = LifeProfile(birthDate: date(1990, 6, 15))
        let metrics = calculator.allMetrics(for: profile, asOf: date(2026, 7, 17))
        XCTAssertEqual(Set(metrics.map(\.kind)), Set(LifeMetric.Kind.allCases))
        XCTAssertEqual(metrics.count, LifeMetric.Kind.allCases.count)
    }
}
