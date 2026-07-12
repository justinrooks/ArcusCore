public enum IngredientSupport: String, Sendable, Codable, Hashable, Comparable {
    case weak
    case conditional
    case supportive
    case strong
    case unknown
}

public enum SnapshotConfidence: String, Sendable, Codable, Hashable {
    case low
    case moderate
    case high
    case degraded
}

public enum TornadoViabilityLimiter: String, Sendable, Codable, Hashable {
    case weakInstability
    case weakDeepShear
    case weakLowLevelRotation
    case weakLowLevelStretching
    case elevatedCloudBases
    case strongCap
    case conditionalInitiation
    case weakStormOrganization
    case fixedEffectiveStpDisagreement
    case poorMoisture
    case missingStormMode
    case unknown
}

public enum TornadoViabilityRealization: String, Sendable, Codable, Hashable {
    case unknown
    case blocked
    case conditional
    case realized

    public init(from decoder: Decoder) throws {
        self = try Self.decodeTornadoViabilityEnum(from: decoder, enumName: "tornado viability realization")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

public enum TornadoViabilityFailureMode: String, Sendable, Codable, Hashable {
    case none
    case weakInstability
    case weakDeepShear
    case weakLowLevelRotation
    case weakLowLevelStretching
    case elevatedCloudBases
    case strongCap
    case conditionalInitiation
    case weakStormOrganization
    case weakLift
    case messyStormMode
    case poorMoisture
    case fixedEffectiveStpDisagreement
    case missingStormMode
    case compositeMismatch

    public init(from decoder: Decoder) throws {
        self = try Self.decodeTornadoViabilityEnum(from: decoder, enumName: "tornado viability failure mode")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

private struct TornadoViabilityLegacyCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}

private extension RawRepresentable where RawValue == String {
    static func decodeTornadoViabilityEnum(from decoder: Decoder, enumName: String) throws -> Self {
        let singleValueContainer = try decoder.singleValueContainer()
        if let rawValue = try? singleValueContainer.decode(String.self) {
            guard let value = Self(rawValue: rawValue) else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unknown \(enumName) raw value '\(rawValue)'."
                    )
                )
            }
            return value
        }

        let container: KeyedDecodingContainer<TornadoViabilityLegacyCodingKey>
        do {
            container = try decoder.container(keyedBy: TornadoViabilityLegacyCodingKey.self)
        } catch {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected \(enumName) to decode from a raw string or legacy keyed object."
                )
            )
        }

        guard !container.allKeys.isEmpty else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected one legacy \(enumName) case key, but found none."
                )
            )
        }

        guard container.allKeys.count == 1, let key = container.allKeys.first else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected exactly one legacy \(enumName) case key."
                )
            )
        }

        guard let value = Self(rawValue: key.stringValue) else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unknown legacy \(enumName) case key '\(key.stringValue)'."
                )
            )
        }

        do {
            let payload = try container.nestedContainer(keyedBy: TornadoViabilityLegacyCodingKey.self, forKey: key)
            guard payload.allKeys.isEmpty else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected legacy \(enumName) case '\(key.stringValue)' to contain an empty object."
                    )
                )
            }
        } catch {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected legacy \(enumName) case '\(key.stringValue)' to contain an empty object."
                )
            )
        }

        return value
    }
}

public extension IngredientSupport {
    static func < (lhs: IngredientSupport, rhs: IngredientSupport) -> Bool {
        lhs.comparisonRank < rhs.comparisonRank
    }

    func lowered() -> IngredientSupport {
        switch self {
        case .unknown:
            return .unknown
        case .weak:
            return .weak
        case .conditional:
            return .weak
        case .supportive:
            return .conditional
        case .strong:
            return .supportive
        }
    }

    func raised() -> IngredientSupport {
        switch self {
        case .unknown:
            return .unknown
        case .weak:
            return .conditional
        case .conditional:
            return .supportive
        case .supportive:
            return .strong
        case .strong:
            return .strong
        }
    }

    var comparisonRank: Int {
        switch self {
        case .unknown:
            return -1
        case .weak:
            return 0
        case .conditional:
            return 1
        case .supportive:
            return 2
        case .strong:
            return 3
        }
    }
}

public extension SnapshotConfidence {
    func lowered() -> SnapshotConfidence {
        switch self {
        case .high:
            return .moderate
        case .moderate:
            return .low
        case .low:
            return .degraded
        case .degraded:
            return .degraded
        }
    }

    func raised() -> SnapshotConfidence {
        switch self {
        case .degraded:
            return .low
        case .low:
            return .moderate
        case .moderate:
            return .high
        case .high:
            return .high
        }
    }
}
