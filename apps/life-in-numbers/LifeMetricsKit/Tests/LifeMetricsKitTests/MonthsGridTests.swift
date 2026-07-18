import XCTest
@testable import LifeMetricsKit

final class MonthsGridTests: XCTestCase {
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
        let grid = MonthsGrid(profile: profile, asOf: date(2000, 1, 1), calculator: LifeCalculator(calendar: calendar))
        XCTAssertEqual(grid.totalMonths, 960)
        XCTAssertEqual(grid.rows, 80)
        XCTAssertEqual(grid.monthsLived, 0)
        XCTAssertTrue(grid.isCurrent(month: 0))
    }

    func testLivedAndCurrentMonths() {
        let profile = LifeProfile(birthDate: date(2000, 1, 15), lifeExpectancyYears: 80)
        let grid = MonthsGrid(profile: profile, asOf: date(2001, 1, 20), calculator: LifeCalculator(calendar: calendar))
        XCTAssertEqual(grid.monthsLived, 12)
        XCTAssertTrue(grid.isLived(month: 11))
        XCTAssertFalse(grid.isLived(month: 12))
        XCTAssertTrue(grid.isCurrent(month: 12))
    }

    func testMonthsLivedClampedToTotal() {
        let profile = LifeProfile(birthDate: date(1900, 1, 1), lifeExpectancyYears: 80)
        let grid = MonthsGrid(profile: profile, asOf: date(2020, 1, 1), calculator: LifeCalculator(calendar: calendar))
        XCTAssertEqual(grid.monthsLived, grid.totalMonths)
        XCTAssertEqual(grid.monthsRemaining, 0)
        XCTAssertEqual(grid.fractionLived, 1)
    }

    func testMonthIndexDateRoundTrip() {
        let birth = date(1990, 6, 15)
        // Index 0 is the birth month, normalized to its first day.
        XCTAssertEqual(MonthsGrid.date(forMonthIndex: 0, birthDate: birth, calendar: calendar), date(1990, 6, 1))
        XCTAssertEqual(MonthsGrid.date(forMonthIndex: 13, birthDate: birth, calendar: calendar), date(1991, 7, 1))

        XCTAssertEqual(MonthsGrid.monthIndex(for: date(1990, 6, 30), birthDate: birth, calendar: calendar), 0)
        XCTAssertEqual(MonthsGrid.monthIndex(for: date(1991, 7, 1), birthDate: birth, calendar: calendar), 13)
        for index in [0, 5, 100, 500] {
            let d = MonthsGrid.date(forMonthIndex: index, birthDate: birth, calendar: calendar)
            XCTAssertEqual(MonthsGrid.monthIndex(for: d, birthDate: birth, calendar: calendar), index)
        }
    }

    func testStarterEventsOnlyIncludePastMilestones() {
        // A 10-year-old (120 months) has no "finished school" or "first crush" yet.
        let events = LifeEvent.starterEvents(monthsLived: 120)
        XCTAssertEqual(events.count, 4)
        XCTAssertTrue(events.allSatisfy { $0.monthIndex <= 120 })
        XCTAssertFalse(events.contains { $0.title == "First crush" })

        // A 30-year-old has the full set.
        XCTAssertEqual(LifeEvent.starterEvents(monthsLived: 360).count, 7)

        // A newborn has just the birth.
        XCTAssertEqual(LifeEvent.starterEvents(monthsLived: 0).count, 1)
    }

    func testLifeEventRoundTripsThroughJSON() throws {
        let event = LifeEvent(monthIndex: 156, title: "First crush", symbolName: "heart", note: "Spring that year")
        let data = try JSONEncoder().encode([event])
        let decoded = try JSONDecoder().decode([LifeEvent].self, from: data)
        XCTAssertEqual(decoded, [event])
    }
}
