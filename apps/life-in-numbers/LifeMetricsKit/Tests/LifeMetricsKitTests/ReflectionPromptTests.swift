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

    func testSystemPromptIsNonEmptyAndConstrainsLength() {
        XCTAssertFalse(ReflectionPrompt.system.isEmpty)
        XCTAssertTrue(ReflectionPrompt.system.contains("120 words"))
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
