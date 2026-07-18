import Foundation
import Observation
import LifeMetricsKit

/// App state: the user's profile, persisted to UserDefaults.
@Observable
final class AppModel {
    private enum Keys {
        static let birthDate = "profile.birthDate"
        static let lifeExpectancy = "profile.lifeExpectancyYears"
        static let gender = "profile.gender"
        static let placeOfBirth = "profile.placeOfBirth"
        static let hasOnboarded = "profile.hasOnboarded"
        static let reflectionModelID = "reflection.modelID"
        static let lastReflection = "reflection.lastText"
        static let lastReflectionDate = "reflection.lastDate"
        static let lastReflectionIsFallback = "reflection.lastIsFallback"
        static let events = "diary.events"
        static let eventsSeeded = "diary.seeded"
        static let interest = "profile.interest"
    }

    /// Hugging Face repo of the on-device model (MLX 4-bit weights): the
    /// best writer this device can run, unless the user picked one.
    static var defaultReflectionModelID: String { ModelCatalog.recommended.id }

    var profile: LifeProfile {
        didSet { persist() }
    }
    var hasOnboarded: Bool {
        didSet { defaults.set(hasOnboarded, forKey: Keys.hasOnboarded) }
    }
    var reflectionModelID: String {
        didSet { defaults.set(reflectionModelID, forKey: Keys.reflectionModelID) }
    }
    /// The single interest that flavors quotes and number facts.
    var interest: Interest {
        didSet { defaults.set(interest.rawValue, forKey: Keys.interest) }
    }
    var lastReflection: String? {
        didSet { defaults.set(lastReflection, forKey: Keys.lastReflection) }
    }
    var lastReflectionDate: Date? {
        didSet { defaults.set(lastReflectionDate?.timeIntervalSinceReferenceDate, forKey: Keys.lastReflectionDate) }
    }
    /// True when the shown reflection is the app's hand-written fallback
    /// rather than the model's draft — so the UI never misattributes it.
    var lastReflectionIsFallback: Bool {
        didSet { defaults.set(lastReflectionIsFallback, forKey: Keys.lastReflectionIsFallback) }
    }
    /// The life-in-months diary, kept sorted by month. Mutation points sort
    /// before assigning — never mutate this inside its own observer:
    /// @Observable makes properties computed, so self-mutation in didSet
    /// recurses infinitely (stack overflow).
    var events: [LifeEvent] {
        didSet {
            if let data = try? JSONEncoder().encode(events) {
                defaults.set(data, forKey: Keys.events)
            }
        }
    }

    let calculator = LifeCalculator()
    let milestoneGenerator = MilestoneGenerator()

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let storedInterval = defaults.object(forKey: Keys.birthDate) as? Double
        let storedExpectancy = defaults.object(forKey: Keys.lifeExpectancy) as? Int
        let birthDate = storedInterval.map(Date.init(timeIntervalSinceReferenceDate:))
            ?? Calendar.current.date(byAdding: .year, value: -30, to: .now) ?? .now
        self.profile = LifeProfile(
            birthDate: birthDate,
            lifeExpectancyYears: storedExpectancy ?? 80,
            gender: defaults.string(forKey: Keys.gender),
            placeOfBirth: defaults.string(forKey: Keys.placeOfBirth)
        )
        self.hasOnboarded = defaults.bool(forKey: Keys.hasOnboarded)
        self.reflectionModelID = defaults.string(forKey: Keys.reflectionModelID) ?? Self.defaultReflectionModelID
        self.interest = defaults.string(forKey: Keys.interest).flatMap(Interest.init(rawValue:)) ?? .books
        self.lastReflection = defaults.string(forKey: Keys.lastReflection)
        self.lastReflectionDate = (defaults.object(forKey: Keys.lastReflectionDate) as? Double)
            .map(Date.init(timeIntervalSinceReferenceDate:))
        self.lastReflectionIsFallback = defaults.bool(forKey: Keys.lastReflectionIsFallback)

        if let data = defaults.data(forKey: Keys.events),
           let stored = try? JSONDecoder().decode([LifeEvent].self, from: data) {
            self.events = stored.sorted { $0.monthIndex < $1.monthIndex }
        } else {
            self.events = []
        }
    }

    /// Pre-fills the diary with movable, approximate milestones — once.
    func seedDiaryIfNeeded() {
        guard !defaults.bool(forKey: Keys.eventsSeeded) else { return }
        defaults.set(true, forKey: Keys.eventsSeeded)
        if events.isEmpty {
            events = LifeEvent.starterEvents(
                monthsLived: calculator.monthsLived(for: profile, asOf: .now)
            )
        }
    }

    func event(atMonth index: Int) -> LifeEvent? {
        events.first { $0.monthIndex == index }
    }

    func upsert(_ event: LifeEvent) {
        var updated = events
        if let i = updated.firstIndex(where: { $0.id == event.id }) {
            updated[i] = event
        } else {
            updated.append(event)
        }
        events = updated.sorted { $0.monthIndex < $1.monthIndex }
    }

    func deleteEvent(id: UUID) {
        if let event = events.first(where: { $0.id == id }) {
            MemoryMediaStore.delete(event.photoFilename)
            MemoryMediaStore.delete(event.audioFilename)
        }
        events.removeAll { $0.id == id }
    }

    private func persist() {
        defaults.set(profile.birthDate.timeIntervalSinceReferenceDate, forKey: Keys.birthDate)
        defaults.set(profile.lifeExpectancyYears, forKey: Keys.lifeExpectancy)
        defaults.set(profile.gender, forKey: Keys.gender)
        defaults.set(profile.placeOfBirth, forKey: Keys.placeOfBirth)
    }
}
