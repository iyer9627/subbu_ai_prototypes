import Foundation

/// Builds the prompt sent to an LLM to write a short reflection on the
/// user's numbers, and cleans up what comes back. Lives in the kit (not the
/// app) so it stays pure and unit-testable; the app layer only handles
/// transport.
public enum ReflectionPrompt {
    public static let system = """
    You are a warm, generous friend writing a short note that celebrates one \
    person's life so far. You are given real statistics about their life and \
    their upcoming milestones. Write one uplifting reflection of 60 to 100 \
    words, addressed directly to "you". Pick the two or three most striking \
    numbers and marvel at them — every one of those heartbeats, sunrises, and \
    steps is something they actually did. Be specific with the numbers you \
    use. Never be gloomy, never dwell on time running out, and never repeat a \
    sentence or an idea. End with one bright sentence that looks forward to \
    an upcoming milestone. Plain prose only: no headings, no lists, no \
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
        if let place = profile.placeOfBirth, !place.isEmpty {
            lines.append("Born in \(place).")
        }
        if let gender = profile.gender, !gender.isEmpty {
            lines.append("They describe themselves as: \(gender). Refer to them only as \"you\" — never in the third person.")
        }
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

    // MARK: - Cleaning up a small model's draft

    /// Word budget a polished reflection is trimmed to, on sentence
    /// boundaries.
    public static let maxWords = 120

    /// Small on-device models loop: they restate the same sentence or whole
    /// paragraph two or three times. Strip reasoning blocks, drop repeated
    /// sentences, and trim to `maxWords` — keeping only whole sentences.
    public static func polish(_ text: String) -> String {
        let stripped = stripThinking(from: text)
            .replacingOccurrences(of: "\n", with: " ")

        var sentences: [String] = []
        stripped.enumerateSubstrings(in: stripped.startIndex..., options: .bySentences) { substring, _, _, _ in
            if let sentence = substring?.trimmingCharacters(in: .whitespacesAndNewlines), !sentence.isEmpty {
                sentences.append(sentence)
            }
        }

        var seen = Set<String>()
        var kept: [String] = []
        var wordCount = 0
        for sentence in sentences {
            let normalized = sentence.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            guard !normalized.isEmpty, !seen.contains(normalized) else { continue }
            let words = sentence.split { $0.isWhitespace }.count
            guard wordCount + words <= maxWords || kept.isEmpty else { break }
            seen.insert(normalized)
            kept.append(sentence)
            wordCount += words
        }
        return kept.joined(separator: " ")
    }

    /// Whether a polished draft is good enough to show: long enough to mean
    /// something, grounded in at least one real number, and actually talking
    /// to the person. Anything that fails gets the hand-written fallback.
    public static func isWorthShowing(_ text: String) -> Bool {
        let words = text.split { $0.isWhitespace }.count
        guard words >= 30 else { return false }
        guard text.rangeOfCharacter(from: .decimalDigits) != nil else { return false }
        guard text.lowercased().contains("you") else { return false }
        return true
    }

    /// A hand-written, always-uplifting reflection assembled from the user's
    /// real numbers — shown whenever the on-device model's draft isn't worth
    /// their time. Varies with the metrics it highlights.
    public static func fallback(
        metrics: [LifeMetric],
        milestones: [Milestone],
        asOf date: Date = Date()
    ) -> String {
        func metric(_ kind: LifeMetric.Kind) -> String? {
            metrics.first { $0.kind == kind }.map { MetricFormatter.compact($0.value) }
        }

        var parts: [String] = []
        if let heartbeats = metric(.heartbeats) {
            parts.append("Your heart has beaten about \(heartbeats) times — and it never once asked for a day off.")
        }
        if let days = metric(.daysLived) {
            parts.append("You have woken up to \(days) sunrises, and each one found you still here, still going.")
        }
        if let moons = metric(.fullMoons) {
            parts.append("You've lived under \(moons) full moons — that's \(moons) times the night sky put on a show just as you happened to be around.")
        }
        if let km = metric(.kilometersThroughSpace) {
            parts.append("Without lifting a finger you've ridden this planet \(km) kilometers through space. You are, quite literally, well travelled.")
        }
        if let breaths = metric(.breaths) {
            parts.append("Somewhere around \(breaths) breaths, and every single one was a small vote for what comes next.")
        }

        var lines = Array(parts.shuffled().prefix(3))
        if let next = milestones.first {
            let when = next.date.formatted(date: .long, time: .omitted)
            lines.append("And the counting isn't done — \(next.title) lands on \(when), one more bright thing already on its way to you.")
        }
        return lines.joined(separator: " ")
    }
}
