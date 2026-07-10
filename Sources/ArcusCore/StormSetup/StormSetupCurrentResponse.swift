import Foundation

public struct StormSetupCurrentResponse: Sendable, Codable, Equatable {
    public let setup: StormSetupCurrentSetupResponse
    public let ingredients: StormSetupTornadoIngredientsResponse
    public let profileAnalysis: AnvilAnalyzeProfileResponse?
    public let tornadoViability: TornadoViabilityReport

    public init(
        setup: StormSetupCurrentSetupResponse,
        ingredients: StormSetupTornadoIngredientsResponse,
        profileAnalysis: AnvilAnalyzeProfileResponse?,
        tornadoViability: TornadoViabilityReport
    ) {
        self.setup = setup
        self.ingredients = ingredients
        self.profileAnalysis = profileAnalysis
        self.tornadoViability = tornadoViability
    }
}

public struct StormSetupCurrentSetupResponse: Sendable, Codable, Equatable {
    public let h3Cell: Int64
    public let centroid: StormSetupCentroid
    public let source: StormSetupSourceMetadata
    public let surfaceHeightMslM: Double?
    public let freshness: IngredientFreshness

    public init(
        h3Cell: Int64,
        centroid: StormSetupCentroid,
        source: StormSetupSourceMetadata,
        surfaceHeightMslM: Double?,
        freshness: IngredientFreshness
    ) {
        self.h3Cell = h3Cell
        self.centroid = centroid
        self.source = source
        self.surfaceHeightMslM = surfaceHeightMslM
        self.freshness = freshness
    }
}

public struct StormSetupTornadoIngredientsResponse: Sendable, Codable, Equatable {
    public let canonical: TornadoRawParameters
    public let diagnostics: TornadoRawParameters

    public init(canonical: TornadoRawParameters, diagnostics: TornadoRawParameters) {
        self.canonical = canonical
        self.diagnostics = diagnostics
    }
}

public struct TornadoViabilityReport: Sendable, Codable, Equatable {
    public let overall: IngredientSupport
    public let realization: TornadoViabilityRealization
    public let primaryFailureMode: TornadoViabilityFailureMode
    public let confidence: SnapshotConfidence
    public let summary: String
    public let details: TornadoViabilityDetails
    public let limitingFactors: [TornadoViabilityLimiter]

    public init(
        overall: IngredientSupport,
        realization: TornadoViabilityRealization,
        primaryFailureMode: TornadoViabilityFailureMode,
        confidence: SnapshotConfidence,
        summary: String,
        details: TornadoViabilityDetails,
        limitingFactors: [TornadoViabilityLimiter]
    ) {
        self.overall = overall
        self.realization = realization
        self.primaryFailureMode = primaryFailureMode
        self.confidence = confidence
        self.summary = summary
        self.details = details
        self.limitingFactors = limitingFactors
    }

}

public struct TornadoViabilityDetails: Sendable, Codable, Equatable {
    public let stormViability: IngredientSupport
    public let supercellViability: IngredientSupport
    public let tornadoEfficiency: IngredientSupport
    public let inhibition: IngredientSupport
    public let instability: IngredientSupport
    public let moisture: IngredientSupport
    public let cloudBase: IngredientSupport
    public let deepShear: IngredientSupport
    public let lowLevelRotation: IngredientSupport
    public let lowLevelStretching: IngredientSupport
    public let cloudBaseEfficiency: IngredientSupport
    public let supercellComposite: IngredientSupport
    public let tornadoComposite: IngredientSupport
    public let stormMode: IngredientSupport

    public init(
        stormViability: IngredientSupport,
        supercellViability: IngredientSupport,
        tornadoEfficiency: IngredientSupport,
        inhibition: IngredientSupport,
        instability: IngredientSupport,
        moisture: IngredientSupport,
        cloudBase: IngredientSupport,
        deepShear: IngredientSupport,
        lowLevelRotation: IngredientSupport,
        lowLevelStretching: IngredientSupport,
        cloudBaseEfficiency: IngredientSupport,
        supercellComposite: IngredientSupport,
        tornadoComposite: IngredientSupport,
        stormMode: IngredientSupport
    ) {
        self.stormViability = stormViability
        self.supercellViability = supercellViability
        self.tornadoEfficiency = tornadoEfficiency
        self.inhibition = inhibition
        self.instability = instability
        self.moisture = moisture
        self.cloudBase = cloudBase
        self.deepShear = deepShear
        self.lowLevelRotation = lowLevelRotation
        self.lowLevelStretching = lowLevelStretching
        self.cloudBaseEfficiency = cloudBaseEfficiency
        self.supercellComposite = supercellComposite
        self.tornadoComposite = tornadoComposite
        self.stormMode = stormMode
    }
}

public struct StormSetupCentroid: Sendable, Codable, Equatable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
