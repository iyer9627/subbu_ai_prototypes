import XCTest
@testable import LifeMetricsKit

final class QuoteBankTests: XCTestCase {
    func testBankIsPopulatedAndConsistent() {
        XCTAssertGreaterThanOrEqual(QuoteBank.all.count, 18)
        for quote in QuoteBank.all {
            XCTAssertFalse(quote.text.isEmpty)
            XCTAssertFalse(quote.book.isEmpty)
            XCTAssertFalse(quote.author.isEmpty)
            let age = quote.authorAgeAtPublication
            XCTAssertTrue((15...90).contains(age), "\(quote.author) age \(age) looks wrong")
        }
    }

    func testAgesSpanAdultLife() {
        let ages = QuoteBank.all.map(\.authorAgeAtPublication)
        XCTAssertLessThanOrEqual(ages.min() ?? 99, 25, "need young-author quotes")
        XCTAssertGreaterThanOrEqual(ages.max() ?? 0, 65, "need older-author quotes")
    }

    func testPoolIsNearestFirstAndUnique() {
        let pool = QuoteBank.pool(forAge: 45)
        XCTAssertEqual(pool.count, 6)
        let distances = pool.map { abs($0.authorAgeAtPublication - 45) }
        XCTAssertEqual(distances, distances.sorted(), "pool should be nearest-age first")
        XCTAssertEqual(Set(pool.map(\.id)).count, pool.count, "no duplicates")
        // Tolkien published The Hobbit at 45 — it should lead the pool.
        XCTAssertEqual(pool.first?.book, "The Hobbit")
    }

    func testPoolFiltersByInterest() {
        let movies = QuoteBank.pool(forAge: 36, interest: .movies)
        XCTAssertEqual(movies.first?.interest, .movies)
        // Lucas released Empire at 36 — it should lead the movies pool.
        XCTAssertEqual(movies.first?.author, "George Lucas")

        // A thin shelf pads with book classics rather than running short.
        let sports = QuoteBank.pool(forAge: 30, interest: .sports)
        XCTAssertEqual(sports.count, 6)
        XCTAssertTrue(sports.prefix(3).allSatisfy { $0.interest == .sports })
        XCTAssertTrue(sports.suffix(3).allSatisfy { $0.interest == .books })
    }

    func testKnownAuthorAges() {
        let hobbit = QuoteBank.all.first { $0.book == "The Hobbit" }
        XCTAssertEqual(hobbit?.authorAgeAtPublication, 45)
        let frankenstein = QuoteBank.all.first { $0.book == "Frankenstein" }
        XCTAssertEqual(frankenstein?.authorAgeAtPublication, 21)
    }
}
