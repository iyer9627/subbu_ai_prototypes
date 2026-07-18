import Foundation

/// A verified real-world quantity used to give a life statistic scale.
/// Every fact carries its source so nothing on a card is invented.
public struct NumberFact: Equatable, Sendable {
    public let value: Double
    /// Completes the sentence "<value> — <text>", e.g. "kilometers from Earth to the Moon".
    public let text: String
    public let source: String

    public init(value: Double, text: String, source: String) {
        self.value = value
        self.text = text
        self.source = source
    }
}

/// Curated bank of real quantities spanning ten orders of magnitude, plus
/// closest-magnitude retrieval. This is the retrieval half of the app's
/// grounded "number fact" feature: the LLM may rephrase a retrieved fact
/// but facts themselves only come from here.
public enum FactBank {
    public static let all: [NumberFact] = [
        NumberFact(value: 27, text: "bones in each human hand", source: "Gray's Anatomy"),
        NumberFact(value: 32, text: "teeth in a full adult set", source: "American Dental Association"),
        NumberFact(value: 46, text: "chromosomes in a human cell", source: "NIH"),
        NumberFact(value: 88, text: "days in a year on Mercury", source: "NASA"),
        NumberFact(value: 118, text: "elements in the periodic table", source: "IUPAC"),
        NumberFact(value: 206, text: "bones in the adult human body", source: "Gray's Anatomy"),
        NumberFact(value: 354, text: "days in a lunar year of twelve full-moon cycles", source: "astronomical calendar"),
        NumberFact(value: 687, text: "days in a year on Mars", source: "NASA"),
        NumberFact(value: 1_440, text: "minutes in every day", source: "arithmetic"),
        NumberFact(value: 1_665, text: "steps to the top of the Eiffel Tower", source: "tour-eiffel.fr"),
        NumberFact(value: 8_849, text: "meters of Mount Everest's height", source: "2020 China–Nepal survey"),
        NumberFact(value: 20_000, text: "breaths an average person takes in a day", source: "American Lung Association"),
        NumberFact(value: 40_075, text: "kilometers around Earth's equator", source: "NASA"),
        NumberFact(value: 100_000, text: "times a human heart beats in a single day", source: "American Heart Association"),
        NumberFact(value: 384_400, text: "kilometers from Earth to the Moon", source: "NASA"),
        NumberFact(value: 2_300_000, text: "stone blocks in the Great Pyramid of Giza", source: "Egyptological estimates"),
        NumberFact(value: 8_800_000, text: "people living in New York City", source: "2020 US Census"),
        NumberFact(value: 31_500_000, text: "seconds in a year", source: "arithmetic"),
        NumberFact(value: 68_000_000, text: "people in France", source: "INSEE, 2024"),
        NumberFact(value: 150_000_000, text: "kilometers from Earth to the Sun — one astronomical unit", source: "NASA"),
        NumberFact(value: 339_000_000, text: "people in the United States", source: "US Census Bureau, 2023"),
        NumberFact(value: 1_430_000_000, text: "people in India, the world's most populous country", source: "UN, 2023"),
        NumberFact(value: 3_000_000_000, text: "heartbeats in an average human lifetime", source: "American Heart Association"),
        NumberFact(value: 5_500_000_000, text: "US dollars — the entire GDP of Fiji", source: "World Bank, 2023"),
        NumberFact(value: 8_100_000_000, text: "people on Earth", source: "UN, 2024"),
        NumberFact(value: 13_800_000_000, text: "years since the Big Bang", source: "Planck mission, ESA"),
        NumberFact(value: 31_000_000_000, text: "US dollars — the GDP of Iceland", source: "World Bank, 2023"),
        NumberFact(value: 86_000_000_000, text: "neurons in the human brain", source: "Herculano-Houzel, 2009"),
        NumberFact(value: 100_000_000_000, text: "stars in the Milky Way, at the least", source: "NASA"),
        NumberFact(value: 250_000_000_000, text: "US dollars — the GDP of New Zealand", source: "World Bank, 2023"),
        NumberFact(value: 2_000_000_000_000, text: "galaxies in the observable universe", source: "NASA, 2016"),
        NumberFact(value: 3_000_000_000_000, text: "trees on Earth", source: "Crowther et al., Nature 2015"),
        NumberFact(value: 37_200_000_000_000, text: "cells in the human body", source: "Bianconi et al., 2013"),
        NumberFact(value: 40_000_000_000_000, text: "kilometers to Proxima Centauri, our nearest star", source: "NASA"),
    ]

    /// The fact whose magnitude is closest to `value` (log-scale distance).
    public static func closest(to value: Double) -> NumberFact? {
        guard value > 0 else { return nil }
        return all.min { a, b in
            abs(log10(a.value) - log10(value)) < abs(log10(b.value) - log10(value))
        }
    }

    /// A ready-to-display comparison line, e.g. "about 3.4× the 8,100,000,000
    /// people on Earth" — computed, so the multiplier is never hallucinated.
    public static func comparison(of value: Double, with fact: NumberFact) -> String {
        let ratio = value / fact.value
        let factValue = MetricFormatter.compact(fact.value)
        switch ratio {
        case 0.95...1.05:
            return "almost exactly the \(factValue) \(fact.text)"
        case 1.05...:
            return "about \(formattedRatio(ratio))× the \(factValue) \(fact.text)"
        default:
            return "about 1/\(formattedRatio(1 / ratio)) of the \(factValue) \(fact.text)"
        }
    }

    private static func formattedRatio(_ ratio: Double) -> String {
        if ratio >= 100 { return String(Int(ratio.rounded())) }
        let rounded = (ratio * 10).rounded() / 10
        if rounded == rounded.rounded() { return String(Int(rounded)) }
        return String(format: "%.1f", rounded)
    }
}
