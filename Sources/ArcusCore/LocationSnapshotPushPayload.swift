import Foundation

/// Shared wire contract for location snapshot uploads from app to server.
public struct LocationSnapshotPushPayload: Sendable, Codable, Equatable {
    public let capturedAt: Date
    public let locationAgeSeconds: Double
    public let horizontalAccuracyMeters: Double
    public let cellScheme: String
    public let h3Cell: Int64?
    public let h3Resolution: Int?
    public let county: String?
    public let zone: String?
    public let fireZone: String?
    public let apnsDeviceToken: String
    public let installationId: String
    public let source: String
    public let auth: String
    public let appVersion: String
    public let buildNumber: String
    public let platform: String
    public let osVersion: String
    public let apnsEnvironment: String
    public let countyLabel: String?
    public let fireZoneLabel: String?
    public let isSubscribed: Bool?

    public init(
        capturedAt: Date,
        locationAgeSeconds: Double,
        horizontalAccuracyMeters: Double,
        cellScheme: String,
        h3Cell: Int64?,
        h3Resolution: Int?,
        county: String?,
        zone: String?,
        fireZone: String?,
        apnsDeviceToken: String,
        installationId: String,
        source: String,
        auth: String,
        appVersion: String,
        buildNumber: String,
        platform: String,
        osVersion: String,
        apnsEnvironment: String,
        countyLabel: String?,
        fireZoneLabel: String?,
        isSubscribed: Bool?
    ) {
        self.capturedAt = capturedAt
        self.locationAgeSeconds = locationAgeSeconds
        self.horizontalAccuracyMeters = horizontalAccuracyMeters
        self.cellScheme = cellScheme
        self.h3Cell = h3Cell
        self.h3Resolution = h3Resolution
        self.county = county
        self.zone = zone
        self.fireZone = fireZone
        self.apnsDeviceToken = apnsDeviceToken
        self.installationId = installationId
        self.source = source
        self.auth = auth
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.platform = platform
        self.osVersion = osVersion
        self.apnsEnvironment = apnsEnvironment
        self.countyLabel = countyLabel
        self.fireZoneLabel = fireZoneLabel
        self.isSubscribed = isSubscribed
    }

    private enum CodingKeys: String, CodingKey {
        case capturedAt
        case locationAgeSeconds
        case horizontalAccuracyMeters
        case cellScheme
        case h3Cell
        case h3Resolution
        case county
        case zone
        case fireZone
        case apnsDeviceToken
        case installationId
        case source
        case auth
        case appVersion
        case buildNumber
        case platform
        case osVersion
        case apnsEnvironment
        case countyLabel
        case fireZoneLabel
        case isSubscribed
    }
}
