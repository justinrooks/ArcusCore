import Foundation

public enum DeviceAlertGeometry: Sendable, Codable, Equatable {
    case polygon(rings: [[DeviceAlertCoordinate]])
    case multiPolygon(polygons: [[[DeviceAlertCoordinate]]])

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }

    private enum GeometryType: String, Codable {
        case polygon = "Polygon"
        case multiPolygon = "MultiPolygon"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeometryType.self, forKey: .type)

        switch type {
        case .polygon:
            let rings = try container.decode([[DeviceAlertCoordinate]].self, forKey: .coordinates)
            self = .polygon(rings: rings)
        case .multiPolygon:
            let polygons = try container.decode([[[DeviceAlertCoordinate]]].self, forKey: .coordinates)
            self = .multiPolygon(polygons: polygons)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .polygon(let rings):
            try container.encode(GeometryType.polygon, forKey: .type)
            try container.encode(rings, forKey: .coordinates)
        case .multiPolygon(let polygons):
            try container.encode(GeometryType.multiPolygon, forKey: .type)
            try container.encode(polygons, forKey: .coordinates)
        }
    }
}

/// GeoJSON-like transport coordinate stored as `[longitude, latitude]`.
public struct DeviceAlertCoordinate: Sendable, Codable, Equatable {
    public let longitude: Double
    public let latitude: Double

    public init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }

    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        longitude = try container.decode(Double.self)
        latitude = try container.decode(Double.self)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
}

public struct DeviceAlertPayload: Sendable, Codable, Equatable {
    public let id: UUID
    public let event: String
    public let currentRevisionUrn: String
    public let currentRevisionSent: Date?
    public let messageType: String

    public let state: String
    public let created: Date
    public let updated: Date
    public let lastSeenActive: Date

    public let sent: Date?
    public let effective: Date?
    public let onset: Date?
    public let expires: Date?
    public let ends: Date?

    public let severity: String
    public let urgency: String
    public let certainty: String

    public let areaDesc: String?
    public let senderName: String?
    public let headline: String?
    public let description: String?
    public let instructions: String?
    public let response: String?

    public let ugc: [String]
    public let h3Cells: [Int64]
    public let geometry: DeviceAlertGeometry?

    public let tornadoDetection: String?
    public let tornadoDamageThreat: String?
    public let maxWindGust: String?
    public let maxHailSize: String?
    public let windThreat: String?
    public let hailThreat: String?
    public let thunderstormDamageThreat: String?
    public let flashFloodDetection: String?
    public let flashFloodDamageThreat: String?

    public init(
        id: UUID,
        event: String,
        currentRevisionUrn: String,
        currentRevisionSent: Date?,
        messageType: String,
        state: String,
        created: Date,
        updated: Date,
        lastSeenActive: Date,
        sent: Date?,
        effective: Date?,
        onset: Date?,
        expires: Date?,
        ends: Date?,
        severity: String,
        urgency: String,
        certainty: String,
        areaDesc: String?,
        senderName: String?,
        headline: String?,
        description: String?,
        instructions: String?,
        response: String?,
        ugc: [String],
        h3Cells: [Int64],
        geometry: DeviceAlertGeometry?,
        tornadoDetection: String?,
        tornadoDamageThreat: String?,
        maxWindGust: String?,
        maxHailSize: String?,
        windThreat: String?,
        hailThreat: String?,
        thunderstormDamageThreat: String?,
        flashFloodDetection: String?,
        flashFloodDamageThreat: String?
    ) {
        self.id = id
        self.event = event
        self.currentRevisionUrn = currentRevisionUrn
        self.currentRevisionSent = currentRevisionSent
        self.messageType = messageType
        self.state = state
        self.created = created
        self.updated = updated
        self.lastSeenActive = lastSeenActive
        self.sent = sent
        self.effective = effective
        self.onset = onset
        self.expires = expires
        self.ends = ends
        self.severity = severity
        self.urgency = urgency
        self.certainty = certainty
        self.areaDesc = areaDesc
        self.senderName = senderName
        self.headline = headline
        self.description = description
        self.instructions = instructions
        self.response = response
        self.ugc = ugc
        self.h3Cells = h3Cells
        self.geometry = geometry
        self.tornadoDetection = tornadoDetection
        self.tornadoDamageThreat = tornadoDamageThreat
        self.maxWindGust = maxWindGust
        self.maxHailSize = maxHailSize
        self.windThreat = windThreat
        self.hailThreat = hailThreat
        self.thunderstormDamageThreat = thunderstormDamageThreat
        self.flashFloodDetection = flashFloodDetection
        self.flashFloodDamageThreat = flashFloodDamageThreat
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case event
        case currentRevisionUrn
        case currentRevisionSent
        case messageType
        case state
        case created
        case updated
        case lastSeenActive
        case sent
        case effective
        case onset
        case expires
        case ends
        case severity
        case urgency
        case certainty
        case areaDesc
        case senderName
        case headline
        case description
        case instructions
        case response
        case ugc
        case h3Cells
        case geometry
        case tornadoDetection
        case tornadoDamageThreat
        case maxWindGust
        case maxHailSize
        case windThreat
        case hailThreat
        case thunderstormDamageThreat
        case flashFloodDetection
        case flashFloodDamageThreat
    }
}
