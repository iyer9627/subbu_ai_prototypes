import XCTest
@testable import LifeMetricsKit

final class FactBankTests: XCTestCase {
    func testBankIsPopulatedAndValid() {
        XCTAssertGreaterThanOrEqual(FactBank.all.count, 30)
        for fact in FactBank.all {
            XCTAssertGreaterThan(fact.value, 0)
            XCTAssertFalse(fact.text.isEmpty)
            XCTAssertFalse(fact.source.isEmpty)
        }
    }

    func testClosestPicksNearestMagnitude() {
        // ~1.3 billion heartbeats should land on a billions-scale fact,
        // not millions or trillions.
        let fact = FactBank.closest(to: 1_300_000_000)
        XCTAssertNotNil(fact)
        XCTAssertGreaterThanOrEqual(fact!.value, 100_000_000)
        XCTAssertLessThanOrEqual(fact!.value, 100_000_000_000)

        // A 36-year age should land on a tens-scale human fact.
        let small = FactBank.closest(to: 36)
        XCTAssertNotNil(small)
        XCTAssertLessThanOrEqual(small!.value, 118)
    }

    func testClosestRejectsNonPositive() {
        XCTAssertNil(FactBank.closest(to: 0))
        XCTAssertNil(FactBank.closest(to: -5))
    }

    func testComparisonPhrasing() {
        let moon = NumberFact(value: 384_400, text: "kilometers from Earth to the Moon", source: "NASA")

        let near = FactBank.comparison(of: 380_000, with: moon)
        XCTAssertTrue(near.hasPrefix("almost exactly"), near)

        let bigger = FactBank.comparison(of: 768_800, with: moon)
        XCTAssertTrue(bigger.contains("2×"), bigger)

        let smaller = FactBank.comparison(of: 96_100, with: moon)
        XCTAssertTrue(smaller.contains("1/4"), smaller)

        // The multiplier is computed, and the fact value appears verbatim.
        XCTAssertTrue(bigger.contains("384,400") || bigger.contains("384"), bigger)
    }
}
