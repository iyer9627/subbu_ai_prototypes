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
        static let reflectionModelID = "reflection.modelID"
        static let lastReflection = "reflection.lastText"
        static let lastReflectionDate = "reflection.lastDate"
    }

    /// Hugging Face repo of the on-device model (MLX 4-bit weights).
    static let defaultReflectionModelID = "mlx-community/Qwen2.5-0.5B-Instruct-4bit"

    var profile: LifeProfile {
        didSet { persist() }
    }
    var hasOnboarded: Bool {
        didSet { defaults.set(hasOnboarded, forKey: Keys.hasOnboarded) }
    }
    var reflectionModelID: String {
        didSet { defaults.set(reflectionModelID, forKey: Keys.reflectionModelID) }
    }
    var lastReflection: String? {
        didSet { defaults.set(lastReflection, forKey: Keys.lastReflection) }
    }
    var lastReflectionDate: Date? {
        didSet { defaults.set(lastReflectionDate?.timeIntervalSinceReferenceDate, forKey: Keys.lastReflectionDate) }
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
        self.reflectionModelID = defaults.string(forKey: Keys.reflectionModelID) ?? Self.defaultReflectionModelID
        self.lastReflection = defaults.string(forKey: Keys.lastReflection)
        self.lastReflectionDate = (defaults.object(forKey: Keys.lastReflectionDate) as? Double)
            .map(Date.init(timeIntervalSinceReferenceDate:))
    }

    private func persist() {
        defaults.set(profile.birthDate.timeIntervalSinceReferenceDate, forKey: Keys.birthDate)
        defaults.set(profile.lifeExpectancyYears, forKey: Keys.lifeExpectancy)
    }
}
