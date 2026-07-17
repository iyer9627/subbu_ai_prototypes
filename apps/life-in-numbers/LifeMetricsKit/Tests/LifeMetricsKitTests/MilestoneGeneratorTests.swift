import XCTest
@testable import LifeMetricsKit

final class MilestoneGeneratorTests: XCTestCase {
    var calendar: Calendar!
    var generator: MilestoneGenerator!

    override func setUp() {
        super.setUp()
        calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        generator = MilestoneGenerator(calendar: calendar)
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    func testMilestonesAreUpcomingAndSorted() {
        let profile = LifeProfile(birthDate: date(1990, 6, 15))
        let asOf = date(2026, 7, 17)
        let milestones = generator.upcomingMilestones(for: profile, asOf: asOf)
        XCTAssertFalse(milestones.isEmpty)
        XCTAssertLessThanOrEqual(milestones.count, 8)
        for milestone in milestones {
            XCTAssertGreaterThan(milestone.date, asOf, "\(milestone.title) should be in the future")
        }
        XCTAssertEqual(milestones.map(\.date), milestones.map(\.date).sorted())
    }

    func testNextRoundDayMilestone() {
        // Born 2000-01-01, as of ~day 3,653: next 1,000-day milestone is day 4,000.
        let profile = LifeProfile(birthDate: date(2000, 1, 1))
        let milestones = generator.roundNumberDays(for: profile, asOf: date(2010, 1, 1))
        let expectedTitle = "Day \(4_000.formatted(.number.grouping(.automatic)))"
        XCTAssertEqual(milestones.first?.title, expectedTitle)
        XCTAssertEqual(milestones.first?.date, date(2010, 12, 14)) // 4,000 days after birth
    }

    func testNextBirthday() {
        let profile = LifeProfile(birthDate: date(1990, 6, 15))
        let milestone = generator.nextBirthday(for: profile, asOf: date(2026, 7, 17))
        XCTAssertEqual(milestone?.title, "Birthday 37")
        XCTAssertEqual(milestone?.date, date(2027, 6, 15))
    }

    func testHalfwayPointOnlyWhenAhead() {
        let young = LifeProfile(birthDate: date(2010, 1, 1), lifeExpectancyYears: 80)
        XCTAssertNotNil(generator.halfwayPoint(for: young, asOf: date(2026, 1, 1)))

        let past = LifeProfile(birthDate: date(1950, 1, 1), lifeExpectancyYears: 80)
        XCTAssertNil(generator.halfwayPoint(for: past, asOf: date(2026, 1, 1)))
    }

    func testBillionSecondsMilestone() {
        // Born 2000-01-01; 1 billion seconds ≈ 31.69 years, so first upcoming is 1 billion.
        let profile = LifeProfile(birthDate: date(2000, 1, 1))
        let milestones = generator.billionSeconds(for: profile, asOf: date(2026, 1, 1))
        XCTAssertEqual(milestones.first?.title, "1 Billion Seconds")
        XCTAssertEqual(milestones.first?.date, profile.birthDate.addingTimeInterval(1_000_000_000))
    }
}
