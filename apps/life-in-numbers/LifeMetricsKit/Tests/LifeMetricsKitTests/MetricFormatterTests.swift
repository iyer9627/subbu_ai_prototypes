import XCTest
@testable import LifeMetricsKit

final class MetricFormatterTests: XCTestCase {
    private let enUS = Locale(identifier: "en_US")

    func testSmallNumbersUseGrouping() {
        XCTAssertEqual(MetricFormatter.compact(0, locale: enUS), "0")
        XCTAssertEqual(MetricFormatter.compact(999, locale: enUS), "999")
        XCTAssertEqual(MetricFormatter.compact(12_345, locale: enUS), "12,345")
        XCTAssertEqual(MetricFormatter.compact(999_999, locale: enUS), "999,999")
    }

    func testMillions() {
        XCTAssertEqual(MetricFormatter.compact(1_000_000), "1 million")
        XCTAssertEqual(MetricFormatter.compact(43_500_000), "43.5 million")
    }

    func testBillionsAndTrillions() {
        XCTAssertEqual(MetricFormatter.compact(2_100_000_000), "2.1 billion")
        XCTAssertEqual(MetricFormatter.compact(1_500_000_000_000), "1.5 trillion")
    }
}
