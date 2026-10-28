import Foundation

/// Presence-only observation. Encode capturedAt as ISO-8601 UTC; it orders geographic observations independently of consent.
public struct DeviceLocationSnapshotV3Payload: Sendable, Codable, Equatable {
    public let installationId: String
    public let capturedAt: Date
    public let locationAgeSeconds: Double
    public let horizontalAccuracyMeters: Double
    public let cellScheme: String
    public let h3Cell: Int64?
    public let h3Resolution: Int?
    public let county: String?
    public let zone: String?
    public let fireZone: String?
    public let countyLabel: String?
    public let fireZoneLabel: String?
    public let source: LocationUploadSource

    public init(
        installationId: String,
        capturedAt: Date,
        locationAgeSeconds: Double,
        horizontalAccuracyMeters: Double,
        cellScheme: String,
        h3Cell: Int64?,
        h3Resolution: Int?,
        county: String?,
        zone: String?,
        fireZone: String?,
        countyLabel: String?,
        fireZoneLabel: String?,
        source: LocationUploadSource
    ) throws {
        guard UUID(uuidString: installationId) != nil else { throw ValidationError.invalidInstallationId }
        guard locationAgeSeconds.isFinite && locationAgeSeconds >= 0 else { throw ValidationError.invalidLocationAge }
        guard horizontalAccuracyMeters.isFinite && horizontalAccuracyMeters >= 0 else { throw ValidationError.invalidAccuracy }
        guard ["h3", "ugc-only"].contains(cellScheme) else { throw ValidationError.invalidCellScheme }
        guard (h3Cell == nil) == (h3Resolution == nil), cellScheme != "h3" || h3Cell != nil, h3Resolution.map({ (0...15).contains($0) }) ?? true else { throw ValidationError.invalidH3Pair }
        self.installationId = installationId
        self.capturedAt = capturedAt
        self.locationAgeSeconds = locationAgeSeconds
        self.horizontalAccuracyMeters = horizontalAccuracyMeters
        self.cellScheme = cellScheme
        self.h3Cell = h3Cell
        self.h3Resolution = h3Resolution
        self.county = county
        self.zone = zone
        self.fireZone = fireZone
        self.countyLabel = countyLabel
        self.fireZoneLabel = fireZoneLabel
        self.source = source
    }

    public enum ValidationError: Error, Equatable {
        case invalidInstallationId
        case invalidLocationAge
        case invalidAccuracy
        case invalidCellScheme
        case invalidH3Pair
    }

    private enum CodingKeys: String, CodingKey {
        case installationId, capturedAt, locationAgeSeconds, horizontalAccuracyMeters, cellScheme, h3Cell, h3Resolution, county, zone, fireZone, countyLabel, fireZoneLabel, source
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            installationId: container.decode(String.self, forKey: .installationId),
            capturedAt: container.decode(Date.self, forKey: .capturedAt),
            locationAgeSeconds: container.decode(Double.self, forKey: .locationAgeSeconds),
            horizontalAccuracyMeters: container.decode(Double.self, forKey: .horizontalAccuracyMeters),
            cellScheme: container.decode(String.self, forKey: .cellScheme),
            h3Cell: container.decodeIfPresent(Int64.self, forKey: .h3Cell),
            h3Resolution: container.decodeIfPresent(Int.self, forKey: .h3Resolution),
            county: container.decodeIfPresent(String.self, forKey: .county),
            zone: container.decodeIfPresent(String.self, forKey: .zone),
            fireZone: container.decodeIfPresent(String.self, forKey: .fireZone),
            countyLabel: container.decodeIfPresent(String.self, forKey: .countyLabel),
            fireZoneLabel: container.decodeIfPresent(String.self, forKey: .fireZoneLabel),
            source: container.decode(LocationUploadSource.self, forKey: .source)
        )
    }
}
