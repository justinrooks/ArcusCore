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
