import Foundation

/// The user's inputs from which every statistic is derived.
public struct LifeProfile: Codable, Equatable, Sendable {
    public var birthDate: Date
    /// Expected lifespan in years, used for the life grid and progress metrics.
    public var lifeExpectancyYears: Int
    /// Optional, used only to personalize written reflections.
    public var gender: String?
    /// Optional, e.g. "Chennai, India" — used only to personalize reflections.
    public var placeOfBirth: String?

    public init(
        birthDate: Date,
        lifeExpectancyYears: Int = 80,
        gender: String? = nil,
        placeOfBirth: String? = nil
    ) {
        self.birthDate = birthDate
        self.lifeExpectancyYears = lifeExpectancyYears
        self.gender = gender
        self.placeOfBirth = placeOfBirth
    }
}
