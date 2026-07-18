import XCTest
@testable import LifeMetricsKit

final class ReflectionPromptTests: XCTestCase {
    func testUserPromptContainsMetricsAndMilestones() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let calculator = LifeCalculator(calendar: calendar)
        let generator = MilestoneGenerator(calendar: calendar)

        let birth = calendar.date(from: DateComponents(year: 1990, month: 6, day: 15))!
        let asOf = calendar.date(from: DateComponents(year: 2026, month: 7, day: 17))!
        let profile = LifeProfile(birthDate: birth)
        let metrics = calculator.allMetrics(for: profile, asOf: asOf)
        let milestones = generator.upcomingMilestones(for: profile, asOf: asOf)

        let prompt = ReflectionPrompt.userPrompt(
            profile: profile,
            metrics: metrics,
            milestones: milestones,
            asOf: asOf
        )

        for metric in metrics {
            XCTAssertTrue(prompt.contains(metric.title), "prompt should mention \(metric.title)")
        }
        XCTAssertTrue(prompt.contains("Upcoming milestones:"))
        if let first = milestones.first {
            XCTAssertTrue(prompt.contains(first.title))
        }
        // Heartbeats for ~36 years should be formatted compactly, e.g. "1.3 billion".
        XCTAssertTrue(prompt.contains("billion"), "large counts should use compact formatting")
    }

    func testSystemPromptIsUpliftingAndConstrainsLength() {
        XCTAssertFalse(ReflectionPrompt.system.isEmpty)
        XCTAssertTrue(ReflectionPrompt.system.contains("60 to 100 words"))
        XCTAssertTrue(ReflectionPrompt.system.contains("uplifting"))
        XCTAssertTrue(ReflectionPrompt.system.contains("Never be gloomy"))
    }

    func testPolishDropsLoopedSentencesAndParagraphs() {
        // The failure mode seen in the wild: a tiny model restating the same
        // sentences and then the same whole paragraph, twice.
        let looped = """
        You have lived 14,202 days. Every step forward is a step forward in the journey of life. \
        Every step forward is a step forward in the journey of life.

        You have lived 14,202 days. Every step forward is a step forward in the journey of life.
        """
        let polished = ReflectionPrompt.polish(looped)
        XCTAssertEqual(
            polished,
            "You have lived 14,202 days. Every step forward is a step forward in the journey of life."
        )
    }

    func testPolishTrimsToWordBudgetOnSentenceBoundaries() {
        let sentence = Array(repeating: "word", count: 50).joined(separator: " ")
        let text = (1...5).map { "Sentence \($0) begins. \(sentence) ends." }.joined(separator: " ")
        let polished = ReflectionPrompt.polish(text)
        let words = polished.split { $0.isWhitespace }.count
        XCTAssertLessThanOrEqual(words, ReflectionPrompt.maxWords)
        XCTAssertTrue(polished.hasSuffix("ends."), "should end on a whole sentence")
    }

    func testIsWorthShowingRejectsSlopAndAcceptsGroundedProse() {
        // No numbers at all — the dreary failure case from the screenshots.
        let noNumbers = """
        Life's journey is long and full, marked by moments of achievement and reflection. \
        As you look forward you feel the weight of your life, and every moment is precious \
        and has value on its own, contributing to the story of who you are.
        """
        XCTAssertFalse(ReflectionPrompt.isWorthShowing(noNumbers))
        XCTAssertFalse(ReflectionPrompt.isWorthShowing("You have lived 14,202 days."), "too short")

        let good = """
        Your heart has beaten 1.4 billion times since August 1987, and you have seen 14,202 \
        sunrises — every one of them found you here, still curious, still going. In a few \
        weeks you cross week 2,000, and that box in your grid is already waiting for you.
        """
        XCTAssertTrue(ReflectionPrompt.isWorthShowing(good))
    }

    func testFallbackIsGroundedUpliftingAndMentionsNextMilestone() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let calculator = LifeCalculator(calendar: calendar)
        let generator = MilestoneGenerator(calendar: calendar)
        let birth = calendar.date(from: DateComponents(year: 1990, month: 6, day: 15))!
        let asOf = calendar.date(from: DateComponents(year: 2026, month: 7, day: 17))!
        let profile = LifeProfile(birthDate: birth)
        let metrics = calculator.allMetrics(for: profile, asOf: asOf)
        let milestones = generator.upcomingMilestones(for: profile, asOf: asOf)

        let text = ReflectionPrompt.fallback(metrics: metrics, milestones: milestones, asOf: asOf)
        XCTAssertTrue(ReflectionPrompt.isWorthShowing(text), "the fallback must always pass its own quality bar")
        if let first = milestones.first {
            XCTAssertTrue(text.contains(first.title))
        }
    }

    func testStripThinkingRemovesReasoningBlocks() {
        XCTAssertEqual(
            ReflectionPrompt.stripThinking(from: "<think>counting…</think>\nYou have lived well."),
            "You have lived well."
        )
        XCTAssertEqual(
            ReflectionPrompt.stripThinking(from: "<think>a</think>Hello<think>b</think> world"),
            "Hello world"
        )
        XCTAssertEqual(ReflectionPrompt.stripThinking(from: "  plain answer \n"), "plain answer")
        // Unclosed tag is left as-is rather than eating the whole answer.
        XCTAssertEqual(ReflectionPrompt.stripThinking(from: "<think>oops"), "<think>oops")
    }
}
