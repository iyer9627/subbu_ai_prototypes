import Foundation
import Observation
import LifeMetricsKit

/// App state: the user's profile, persisted to UserDefaults.
@Observable
final class AppModel {
    private enum Keys {
        static let birthDate = "profile.birthDate"
        static let lifeExpectancy = "profile.lifeExpectancyYears"
        static let hasOnboarded = "profile.hasOnboarded"
    }

    var profile: LifeProfile {
        didSet { persist() }
    }
    var hasOnboarded: Bool {
        didSet { defaults.set(hasOnboarded, forKey: Keys.hasOnboarded) }
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
        self.profile = LifeProfile(birthDate: birthDate, lifeExpectancyYears: storedExpectancy ?? 80)
        self.hasOnboarded = defaults.bool(forKey: Keys.hasOnboarded)
    }

    private func persist() {
        defaults.set(profile.birthDate.timeIntervalSinceReferenceDate, forKey: Keys.birthDate)
        defaults.set(profile.lifeExpectancyYears, forKey: Keys.lifeExpectancy)
    }
}
