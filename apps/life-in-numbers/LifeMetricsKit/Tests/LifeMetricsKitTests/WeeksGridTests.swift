import XCTest
@testable import LifeMetricsKit

final class WeeksGridTests: XCTestCase {
    var calendar: Calendar!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    func testGridDimensions() {
        let profile = LifeProfile(birthDate: date(2000, 1, 1), lifeExpectancyYears: 80)
        let grid = WeeksGrid(profile: profile, asOf: date(2000, 1, 1), calculator: LifeCalculator(calendar: calendar))
        XCTAssertEqual(grid.totalWeeks, 4_160)
        XCTAssertEqual(grid.rows, 80)
        XCTAssertEqual(grid.weeksLived, 0)
        XCTAssertEqual(grid.weeksRemaining, 4_160)
    }

    func testLivedAndCurrentWeeks() {
        let profile = LifeProfile(birthDate: date(2000, 1, 1), lifeExpectancyYears: 80)
        // 70 days later = 10 full weeks lived.
        let grid = WeeksGrid(profile: profile, asOf: date(2000, 3, 11), calculator: LifeCalculator(calendar: calendar))
        XCTAssertEqual(grid.weeksLived, 10)
        XCTAssertTrue(grid.isLived(week: 9))
        XCTAssertFalse(grid.isLived(week: 10))
        XCTAssertTrue(grid.isCurrent(week: 10))
        XCTAssertFalse(grid.isCurrent(week: 11))
    }

    func testWeeksLivedClampedToTotal() {
        let profile = LifeProfile(birthDate: date(1900, 1, 1), lifeExpectancyYears: 80)
        let grid = WeeksGrid(profile: profile, asOf: date(2020, 1, 1), calculator: LifeCalculator(calendar: calendar))
        XCTAssertEqual(grid.weeksLived, grid.totalWeeks)
        XCTAssertEqual(grid.weeksRemaining, 0)
        XCTAssertEqual(grid.fractionLived, 1)
        XCTAssertFalse(grid.isCurrent(week: grid.totalWeeks))
    }
}
