import Foundation

/// Builds the prompt sent to an LLM to write a short reflection on the
/// user's numbers. Lives in the kit (not the app) so it stays pure and
/// unit-testable; the app layer only handles transport.
public enum ReflectionPrompt {
    public static let system = """
    You are a warm, thoughtful observer of a human life. You are given a set of \
    statistics about one person's life so far, and their upcoming milestones. \
    Write a single short reflection (at most 120 words) that helps them feel the \
    weight and wonder of these numbers. Pick two or three of the most striking \
    figures — do not list them all. Be specific with the numbers you use, keep an \
    encouraging tone without being saccharine, and end with one sentence looking \
    forward to an upcoming milestone. Plain prose only: no headings, no lists, no \
    markdown.
    """

    public static func userPrompt(
        profile: LifeProfile,
        metrics: [LifeMetric],
        milestones: [Milestone],
        asOf date: Date = Date()
    ) -> String {
        var lines: [String] = []
        lines.append("Today is \(date.formatted(date: .long, time: .omitted)).")
        lines.append("Born \(profile.birthDate.formatted(date: .long, time: .omitted)).")
        lines.append("")
        lines.append("Life so far:")
        for metric in metrics {
            let value = MetricFormatter.compact(metric.value)
            let unit = metric.unit.map { " \($0)" } ?? ""
            lines.append("- \(metric.title): \(value)\(unit)")
        }
        if !milestones.isEmpty {
            lines.append("")
            lines.append("Upcoming milestones:")
            for milestone in milestones {
                lines.append("- \(milestone.title) on \(milestone.date.formatted(date: .long, time: .omitted)) (\(milestone.detail))")
            }
        }
        return lines.joined(separator: "\n")
    }

    /// Some open models (e.g. Qwen3) emit `<think>…</think>` reasoning blocks
    /// before the answer; keep only the answer.
    public static func stripThinking(from text: String) -> String {
        var output = text
        while let start = output.range(of: "<think>"),
              let end = output.range(of: "</think>", range: start.upperBound..<output.endIndex) {
            output.removeSubrange(start.lowerBound..<end.upperBound)
        }
        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
