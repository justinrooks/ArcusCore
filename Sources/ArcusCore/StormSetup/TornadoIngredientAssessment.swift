import Foundation

public struct TornadoIngredientAssessment: Sendable, Codable, Equatable {
    public let overall: IngredientSupport
    public let instability: IngredientSupport
    public let moisture: IngredientSupport
    public let cloudBase: IngredientSupport
    public let capInhibition: IngredientSupport
    public let deepShear: IngredientSupport
    public let lowLevelRotation: IngredientSupport
    public let lowLevelRotationSupport: IngredientSupport?
    public let lowLevelStretching: IngredientSupport?
    public let cloudBaseEfficiency: IngredientSupport?
    public let tornadoEfficiency: IngredientSupport?
    public let stormViability: IngredientSupport?
    public let supercellViability: IngredientSupport?
    public let supercellComposite: IngredientSupport?
    public let stormMode: IngredientSupport
    public let compositeSignal: IngredientSupport
    public let realization: TornadoViabilityRealization?
    public let primaryFailureMode: TornadoViabilityFailureMode?
    public let viabilityLimiters: [TornadoViabilityLimiter]?
    public let confidence: SnapshotConfidence
    public let trend: IngredientTrend
    public let stormModeHint: StormModeHint
    public let primaryDrivers: [String]
    public let limitingFactors: [TornadoLimitingFactor]
    public let summary: String

    public init(
        overall: IngredientSupport,
        instability: IngredientSupport,
        moisture: IngredientSupport,
        cloudBase: IngredientSupport,
        capInhibition: IngredientSupport,
        deepShear: IngredientSupport,
        lowLevelRotation: IngredientSupport,
        stormMode: IngredientSupport,
        compositeSignal: IngredientSupport,
        confidence: SnapshotConfidence,
        trend: IngredientTrend,
        stormModeHint: StormModeHint,
        primaryDrivers: [String],
        limitingFactors: [TornadoLimitingFactor],
        summary: String,
        lowLevelRotationSupport: IngredientSupport? = nil,
        lowLevelStretching: IngredientSupport? = nil,
        cloudBaseEfficiency: IngredientSupport? = nil,
        tornadoEfficiency: IngredientSupport? = nil,
        stormViability: IngredientSupport? = nil,
        supercellViability: IngredientSupport? = nil,
        supercellComposite: IngredientSupport? = nil,
        realization: TornadoViabilityRealization? = nil,
        primaryFailureMode: TornadoViabilityFailureMode? = nil,
        viabilityLimiters: [TornadoViabilityLimiter]? = nil
    ) {
        self.overall = overall
        self.instability = instability
        self.moisture = moisture
        self.cloudBase = cloudBase
        self.capInhibition = capInhibition
        self.deepShear = deepShear
        self.lowLevelRotation = lowLevelRotation
        self.lowLevelRotationSupport = lowLevelRotationSupport
        self.lowLevelStretching = lowLevelStretching
        self.cloudBaseEfficiency = cloudBaseEfficiency
        self.tornadoEfficiency = tornadoEfficiency
        self.stormViability = stormViability
        self.supercellViability = supercellViability
        self.supercellComposite = supercellComposite
        self.stormMode = stormMode
        self.compositeSignal = compositeSignal
        self.realization = realization
        self.primaryFailureMode = primaryFailureMode
        self.viabilityLimiters = viabilityLimiters
        self.confidence = confidence
        self.trend = trend
        self.stormModeHint = stormModeHint
        self.primaryDrivers = primaryDrivers
        self.limitingFactors = limitingFactors
        self.summary = summary
    }
}

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

public enum IngredientTrend: String, Sendable, Codable, Hashable {
    case increasing
    case steady
    case decreasing
    case unknown
}

public enum StormModeHint: String, Sendable, Codable, Hashable {
    case discreteSupercells
    case mixedMode
    case linear
    case clustered
    case elevated
    case unknown
}

public enum TornadoLimitingFactor: String, Sendable, Codable, Hashable {
    case weakInstability
    case weakDeepShear
    case weakLowLevelRotation
    case elevatedCloudBases
    case strongCap
    case weakLift
    case messyStormMode
    case poorMoisture
    case unknown
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
