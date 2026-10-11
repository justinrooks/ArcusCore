import Foundation

/// Shared representation of one SPC mesoscale discussion product.
///
/// `productID` is `SPC-MD-<issueYear>-<number>` because SPC reuses MD numbers
/// across calendar years. `watchProbability` is expressed in percentage points
/// (for example, `40` means 40%). Dates use the consumer's configured Codable
/// date strategy, as with other ArcusCore payloads.
public struct MesoscaleDiscussionPayload: Sendable, Codable, Hashable, Identifiable {
    public var productID: String { "SPC-MD-\(issueYear)-\(number)" }
    public var id: String { productID }

    public let issueYear: Int
    public let number: Int
    public let title: String
    public let sourceURL: URL
    public let issued: Date
    public let validStart: Date
    public let validEnd: Date
    public let areasAffected: String
    public let summary: String
    public let concerning: String?
    public let watchProbability: Double?
    public let watchProbabilityText: String
    public let threats: MesoscaleDiscussionThreats?
    public let coordinates: [MesoscaleDiscussionCoordinate]

    public init(
        number: Int,
        title: String,
        sourceURL: URL,
        issued: Date,
        validStart: Date,
        validEnd: Date,
        areasAffected: String,
        summary: String,
        concerning: String?,
        watchProbability: Double?,
        watchProbabilityText: String,
        threats: MesoscaleDiscussionThreats?,
        coordinates: [MesoscaleDiscussionCoordinate]
    ) {
        self.issueYear = Self.utcYear(of: issued)
        self.number = number
        self.title = title
        self.sourceURL = sourceURL
        self.issued = issued
        self.validStart = validStart
        self.validEnd = validEnd
        self.areasAffected = areasAffected
        self.summary = summary
        self.concerning = concerning
        self.watchProbability = watchProbability
        self.watchProbabilityText = Self.normalizedWatchProbabilityText(watchProbabilityText, probability: watchProbability)
        self.threats = threats
        self.coordinates = coordinates
    }

    private enum CodingKeys: String, CodingKey {
        case productID
        case issueYear
        case number
        case title
        case sourceURL
        case legacyLink = "link"
        case issued
        case validStart
        case validEnd
        case areasAffected
        case summary
        case concerning
        case watchProbability
        case watchProbabilityText
        case threats
        case coordinates
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decode(Int.self, forKey: .number)
        title = try container.decode(String.self, forKey: .title)
        issued = try container.decode(Date.self, forKey: .issued)
        let decodedYear = try container.decodeIfPresent(Int.self, forKey: .issueYear)
        issueYear = Self.utcYear(of: issued)
        if let decodedYear, decodedYear != issueYear {
            throw DecodingError.dataCorruptedError(
                forKey: .issueYear,
                in: container,
                debugDescription: "issueYear must match the UTC year of issued"
            )
        }
        sourceURL = try container.decodeIfPresent(URL.self, forKey: .sourceURL)
            ?? container.decode(URL.self, forKey: .legacyLink)
        validStart = try container.decode(Date.self, forKey: .validStart)
        validEnd = try container.decode(Date.self, forKey: .validEnd)
        areasAffected = try container.decode(String.self, forKey: .areasAffected)
        summary = try container.decode(String.self, forKey: .summary)
        concerning = try container.decodeIfPresent(String.self, forKey: .concerning)
        watchProbability = try container.decodeIfPresent(Double.self, forKey: .watchProbability)
        let decodedText = try container.decodeIfPresent(String.self, forKey: .watchProbabilityText)
        watchProbabilityText = Self.normalizedWatchProbabilityText(decodedText ?? "", probability: watchProbability)
        threats = try container.decodeIfPresent(MesoscaleDiscussionThreats.self, forKey: .threats)
        coordinates = try container.decode([MesoscaleDiscussionCoordinate].self, forKey: .coordinates)

        if let decodedProductID = try container.decodeIfPresent(String.self, forKey: .productID),
           decodedProductID != productID {
            throw DecodingError.dataCorruptedError(
                forKey: .productID,
                in: container,
                debugDescription: "productID must match issueYear and number"
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productID, forKey: .productID)
        try container.encode(issueYear, forKey: .issueYear)
        try container.encode(number, forKey: .number)
        try container.encode(title, forKey: .title)
        try container.encode(sourceURL, forKey: .sourceURL)
        try container.encode(issued, forKey: .issued)
        try container.encode(validStart, forKey: .validStart)
        try container.encode(validEnd, forKey: .validEnd)
        try container.encode(areasAffected, forKey: .areasAffected)
        try container.encode(summary, forKey: .summary)
        try container.encodeIfPresent(concerning, forKey: .concerning)
        try container.encodeIfPresent(watchProbability, forKey: .watchProbability)
        try container.encode(watchProbabilityText, forKey: .watchProbabilityText)
        try container.encodeIfPresent(threats, forKey: .threats)
        try container.encode(coordinates, forKey: .coordinates)
    }

    private static func utcYear(of date: Date) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        if let utc = TimeZone(secondsFromGMT: 0) {
            calendar.timeZone = utc
        }
        return calendar.component(.year, from: date)
    }

    private static func normalizedWatchProbabilityText(_ text: String, probability: Double?) -> String {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty == false { return trimmedText }
        return probability?.formatted(
            .number.locale(Locale(identifier: "en_US_POSIX")).precision(.fractionLength(0...2))
        ) ?? "Unknown"
    }
}

/// Parsed severe-weather threat values associated with a mesoscale discussion.
public struct MesoscaleDiscussionThreats: Sendable, Codable, Hashable {
    public let peakWindMPH: Int?
    public let hailRangeInches: Double?
    public let tornadoStrength: String?

    public init(peakWindMPH: Int?, hailRangeInches: Double?, tornadoStrength: String?) {
        self.peakWindMPH = peakWindMPH
        self.hailRangeInches = hailRangeInches
        self.tornadoStrength = tornadoStrength
    }
}

/// Platform-neutral latitude and longitude pair used by shared payloads.
public struct MesoscaleDiscussionCoordinate: Sendable, Codable, Hashable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
