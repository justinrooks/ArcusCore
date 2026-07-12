import Foundation

/// The current, location-scoped air-quality observation returned by Arcus Signal.
public struct AirQualityCurrentResponse: Sendable, Codable, Equatable {
    public let aqi: Int
    public let category: AirQualityCategory?
    public let primaryPollutant: String?
    public let observedAt: Date
    public let sourceIdentifier: String

    public init(
        aqi: Int,
        category: AirQualityCategory?,
        primaryPollutant: String?,
        observedAt: Date,
        sourceIdentifier: String
    ) {
        self.aqi = aqi
        self.category = category
        self.primaryPollutant = primaryPollutant
        self.observedAt = observedAt
        self.sourceIdentifier = sourceIdentifier
    }
}

public struct AirQualityCategory: Sendable, Codable, Equatable {
    public let identifier: Int?
    public let name: String?

    public init(identifier: Int?, name: String?) {
        self.identifier = identifier
        self.name = name
    }
}
