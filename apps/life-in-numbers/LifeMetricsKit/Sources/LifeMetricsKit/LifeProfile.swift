import Foundation

/// The user's inputs from which every statistic is derived.
public struct LifeProfile: Codable, Equatable, Sendable {
    public var birthDate: Date
    /// Expected lifespan in years, used for the life-in-weeks grid and progress metrics.
    public var lifeExpectancyYears: Int

    public init(birthDate: Date, lifeExpectancyYears: Int = 80) {
        self.birthDate = birthDate
        self.lifeExpectancyYears = lifeExpectancyYears
    }
}
