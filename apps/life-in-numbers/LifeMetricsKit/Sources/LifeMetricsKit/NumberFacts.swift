import Foundation

/// A verified real-world quantity used to give a life statistic scale.
/// Every fact carries its source so nothing on a card is invented.
public struct NumberFact: Equatable, Sendable {
    public let value: Double
    /// Completes the sentence "<value> — <text>", e.g. "kilometers from Earth to the Moon".
    public let text: String
    public let source: String
    /// Interest category this fact belongs to; nil = universal knowledge.
    public let interest: Interest?
    /// Place keyword ("India", "France", "New York"…) for geo relevance; nil = global.
    public let region: String?

    public init(value: Double, text: String, source: String, interest: Interest? = nil, region: String? = nil) {
        self.value = value
        self.text = text
        self.source = source
        self.interest = interest
        self.region = region
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
        NumberFact(value: 1_665, text: "steps to the top of the Eiffel Tower", source: "tour-eiffel.fr", region: "France"),
        NumberFact(value: 8_849, text: "meters of Mount Everest's height", source: "2020 China–Nepal survey"),
        NumberFact(value: 20_000, text: "breaths an average person takes in a day", source: "American Lung Association"),
        NumberFact(value: 40_075, text: "kilometers around Earth's equator", source: "NASA"),
        NumberFact(value: 100_000, text: "times a human heart beats in a single day", source: "American Heart Association"),
        NumberFact(value: 384_400, text: "kilometers from Earth to the Moon", source: "NASA"),
        NumberFact(value: 2_300_000, text: "stone blocks in the Great Pyramid of Giza", source: "Egyptological estimates"),
        NumberFact(value: 8_800_000, text: "people living in New York City", source: "2020 US Census", region: "United States"),
        NumberFact(value: 31_500_000, text: "seconds in a year", source: "arithmetic"),
        NumberFact(value: 68_000_000, text: "people in France", source: "INSEE, 2024", region: "France"),
        NumberFact(value: 150_000_000, text: "kilometers from Earth to the Sun — one astronomical unit", source: "NASA"),
        NumberFact(value: 339_000_000, text: "people in the United States", source: "US Census Bureau, 2023", region: "United States"),
        NumberFact(value: 1_430_000_000, text: "people in India, the world's most populous country", source: "UN, 2023", region: "India"),
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

        // Geography
        NumberFact(value: 2_525, text: "kilometers the Ganges flows from the Himalaya to the sea", source: "Encyclopaedia Britannica", region: "India"),
        NumberFact(value: 68_000, text: "kilometers of Indian Railways routes", source: "Indian Railways annual report, 2023", region: "India"),
        NumberFact(value: 11_500_000, text: "people in greater Chennai", source: "UN World Urbanization Prospects", region: "India"),
        NumberFact(value: 21_000_000, text: "people in greater Mumbai", source: "UN World Urbanization Prospects", region: "India"),
        NumberFact(value: 402, text: "kilometers of London Underground track", source: "Transport for London", region: "United Kingdom"),
        NumberFact(value: 3_776, text: "meters of Mount Fuji's height", source: "Geospatial Information Authority of Japan", region: "Japan"),

        // Sports
        NumberFact(value: 42_195, text: "meters in a marathon", source: "World Athletics", interest: .sports),
        NumberFact(value: 34_357, text: "international runs scored by Sachin Tendulkar", source: "ESPNcricinfo", interest: .sports, region: "India"),
        NumberFact(value: 32_292, text: "career points scored by Michael Jordan", source: "NBA.com", interest: .sports, region: "United States"),
        NumberFact(value: 3_500, text: "kilometers ridden in a typical Tour de France", source: "letour.fr", interest: .sports, region: "France"),
        NumberFact(value: 99_354, text: "seats in Camp Nou, Europe's largest stadium", source: "FC Barcelona", interest: .sports),
        NumberFact(value: 1_500_000_000, text: "people who watched the 2022 World Cup final", source: "FIFA", interest: .sports),

        // Movies
        NumberFact(value: 24, text: "film frames flickering past every second", source: "SMPTE standard", interest: .movies),
        NumberFact(value: 2_200_000_000, text: "US dollars Titanic earned at the box office", source: "Box Office Mojo", interest: .movies),
        NumberFact(value: 2_900_000_000, text: "US dollars Avatar earned — the biggest film ever", source: "Box Office Mojo", interest: .movies),
        NumberFact(value: 1_800, text: "films made in India each year — the world's largest film industry", source: "Film Federation of India", interest: .movies, region: "India"),

        // TV
        NumberFact(value: 236, text: "episodes of Friends", source: "Warner Bros.", interest: .tv),
        NumberFact(value: 750, text: "episodes of The Simpsons and counting", source: "Fox", interest: .tv),
        NumberFact(value: 60, text: "years Doctor Who has been travelling in time", source: "BBC", interest: .tv, region: "United Kingdom"),

        // Music
        NumberFact(value: 88, text: "keys on a piano", source: "standard keyboard", interest: .music),
        NumberFact(value: 600_000_000, text: "records the Beatles have sold", source: "EMI estimates", interest: .music, region: "United Kingdom"),
        NumberFact(value: 70_000_000, text: "copies of Thriller sold — the best-selling album ever", source: "Guinness World Records", interest: .music),
        NumberFact(value: 4_000_000_000, text: "Spotify streams of Blinding Lights, the most-streamed song", source: "Spotify Charts, 2024", interest: .music),

        // Tech
        NumberFact(value: 17_468, text: "vacuum tubes inside ENIAC, the first general-purpose computer", source: "US Army, 1946", interest: .tech),
        NumberFact(value: 28_000_000, text: "lines of code in the Linux kernel", source: "Linux Foundation, 2023", interest: .tech),
        NumberFact(value: 5_400_000_000, text: "people using the internet", source: "ITU, 2023", interest: .tech),
        NumberFact(value: 134_000_000_000, text: "transistors in Apple's M2 Ultra chip", source: "Apple, 2023", interest: .tech, region: "United States"),

        // Pop culture
        NumberFact(value: 1_025, text: "Pokémon species discovered so far", source: "The Pokémon Company, 2023", interest: .popCulture),
        NumberFact(value: 3_782, text: "emojis in the Unicode standard", source: "Unicode 15.1", interest: .popCulture),
        NumberFact(value: 600_000_000, text: "Harry Potter books sold worldwide", source: "Bloomsbury, 2023", interest: .popCulture, region: "United Kingdom"),
        NumberFact(value: 4.325_200_327_448_985_6e19, text: "possible arrangements of a Rubik's Cube", source: "group theory", interest: .popCulture),
    ]

    /// The fact whose magnitude is closest to `value` (log-scale distance).
    public static func closest(to value: Double) -> NumberFact? {
        guard value > 0 else { return nil }
        return all.min { a, b in
            abs(log10(a.value) - log10(value)) < abs(log10(b.value) - log10(value))
        }
    }

    /// A ranked pool of facts near `value`'s magnitude, boosted toward the
    /// user's chosen interest and place. Flip through the pool for variety —
    /// callers cycle it so cards never feel repeated.
    public static func pool(
        for value: Double,
        interest: Interest? = nil,
        place: String? = nil,
        count: Int = 6
    ) -> [NumberFact] {
        guard value > 0 else { return [] }
        let placeLower = place?.lowercased() ?? ""
        func score(_ fact: NumberFact) -> Double {
            var s = abs(log10(fact.value) - log10(value))
            // A matching interest or home region is worth being up to about
            // half an order of magnitude further away.
            if let interest, fact.interest == interest { s -= 0.45 }
            if let region = fact.region?.lowercased(), !placeLower.isEmpty,
               placeLower.contains(region) || region.contains(placeLower) {
                s -= 0.55
            }
            // Facts from other interests shouldn't crowd out universal ones.
            if let factInterest = fact.interest, factInterest != interest { s += 0.8 }
            return s
        }
        return Array(all.sorted { score($0) < score($1) }.prefix(count))
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
        case 0.55..<0.95:
            return "about \(Int((ratio * 100).rounded()))% of the \(factValue) \(fact.text)"
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
