import Foundation
import Testing
@testable import ArcusCore

@Test func tornadoViabilityEnumsPreserveV1ObjectPayloads() throws {
    struct V1Payload: Codable, Equatable {
        let realization: TornadoViabilityRealization
        let primaryFailureMode: TornadoViabilityFailureMode
    }

    let legacyJSON = Data(#"""
    {"realization":{"conditional":{}},"primaryFailureMode":{"conditionalInitiation":{}}}
    """#.utf8)
    let payload = try JSONDecoder().decode(V1Payload.self, from: legacyJSON)
    let encoded = try JSONEncoder().encode(payload)

    #expect(payload == V1Payload(realization: .conditional, primaryFailureMode: .conditionalInitiation))
    #expect(try JSONSerialization.jsonObject(with: encoded) as? [String: [String: [String: String]]] == [
        "realization": ["conditional": [:]],
        "primaryFailureMode": ["conditionalInitiation": [:]],
    ])
}

@Test func stormSetupCurrentResponseRoundTripsNestedContract() throws {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = [.sortedKeys]

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let source = StormSetupSourceMetadata(
        sourceKind: .directObject,
        model: .hrrr,
        product: .wrfprsf,
        domain: .conus,
        runTime: Date(timeIntervalSince1970: 1_750_000_000),
        forecastHour: 6,
        validTime: Date(timeIntervalSince1970: 1_750_021_600),
        fieldSetVersion: .tornadoPressureV2,
        bbox: StormSetupHrrrBoundingBox(leftlon: -105.2, rightlon: -104.8, toplat: 39.9, bottomlat: 39.4),
        primaryDownloadURL: URL(string: "https://example.com/grib2")!,
        idxURL: URL(string: "https://example.com/grib2.idx")!
    )
    let freshness = IngredientFreshness.make(
        source: source,
        fetchedAt: Date(timeIntervalSince1970: 1_750_000_600),
        staleAfter: 3_600
    )

    let canonical = TornadoRawParameters(
        sbcapeJkg: 1_250.0,
        mlcapeJkg: 1_100.0,
        mucapeJkg: 1_400.0,
        mlcinJkg: -42.5,
        dcapeJkg: 650.0,
        mllclM: 980.0,
        tempDewPtDeltaF: 8.5,
        temperature2mK: 294.5,
        dewpoint2mK: 286.0,
        surfacePressurePa: 98_100.0,
        wind10m: DirectionSpeed(directionDegrees: 250.0, speedKt: 15.0),
        threeCapeJkg: 85.0,
        lclLfcSeparationM: 320.0,
        lapseRate03kmCkm: 7.8,
        lapseRate700500mbCkm: 6.1,
        shear06kmKt: 47.0,
        shear03kmKt: 33.0,
        shear01kmKt: 19.0,
        effectiveShearKt: 49.0,
        srh01kmM2s2: 210.0,
        srh03kmM2s2: 280.0,
        effectiveSrhM2s2: 190.0,
        supercellComposite: 4.2,
        significantTornadoFixed: 2.3,
        significantTornadoEffective: 3.1,
        significantHail: 1.8,
        bunkersRightMotion: DirectionSpeed(directionDegrees: 245.0, speedKt: 36.0),
        bunkersLeftMotion: DirectionSpeed(directionDegrees: 120.0, speedKt: 28.0),
        stormRelativeWind46km: DirectionSpeed(directionDegrees: 260.0, speedKt: 44.0),
        meanWind850300mb: DirectionSpeed(directionDegrees: 255.0, speedKt: 31.0),
        diagnostics: [
            TornadoRawParameterDiagnostic(
                inventory: "surface",
                parsedValue: 1_250.0,
                matchedRawParameterKey: .mlcapeJkg,
                requestedLongitude: -104.991,
                requestedLatitude: 39.742,
                nearestLongitude: -104.990,
                nearestLatitude: 39.741
            )
        ],
        effectiveBulkShearMs: 25.1,
        effectiveLayer: AnvilEffectiveLayerDTO(
            status: "found",
            basePressureMb: 845.0,
            topPressureMb: 512.0,
            baseMetersAgl: 1_050.0,
            topMetersAgl: 5_250.0
        ),
        stormMotion: AnvilStormMotionDTO(
            status: "computed",
            bunkersRight: AnvilBunkersRightStormMotionDTO(
                uKt: 18.0,
                vKt: -24.0,
                speedKt: 30.0,
                directionTowardDeg: 233.0,
                uMs: 9.3,
                vMs: -12.4,
                speedMs: 15.4
            )
        )
    )

    let diagnostics = TornadoRawParameters(
        sbcapeJkg: 1_250.0,
        mlcapeJkg: 1_100.0,
        mucapeJkg: 1_400.0,
        mlcinJkg: -42.5,
        dcapeJkg: 650.0,
        mllclM: 980.0,
        tempDewPtDeltaF: 8.5,
        threeCapeJkg: 85.0,
        lclLfcSeparationM: 320.0,
        lapseRate03kmCkm: 7.8,
        lapseRate700500mbCkm: 6.1,
        shear06kmKt: 47.0,
        shear03kmKt: 33.0,
        shear01kmKt: 19.0,
        effectiveShearKt: 49.0,
        srh01kmM2s2: 210.0,
        srh03kmM2s2: 280.0,
        effectiveSrhM2s2: 190.0,
        supercellComposite: 4.2,
        significantTornadoFixed: 2.3,
        significantTornadoEffective: 3.1,
        significantHail: 1.8,
        bunkersRightMotion: DirectionSpeed(directionDegrees: 245.0, speedKt: 36.0),
        bunkersLeftMotion: DirectionSpeed(directionDegrees: 120.0, speedKt: 28.0),
        stormRelativeWind46km: DirectionSpeed(directionDegrees: 260.0, speedKt: 44.0),
        meanWind850300mb: DirectionSpeed(directionDegrees: 255.0, speedKt: 31.0),
        diagnostics: nil,
        effectiveBulkShearMs: nil,
        effectiveLayer: nil,
        stormMotion: nil
    )

    let response = StormSetupCurrentResponse(
        setup: StormSetupCurrentSetupResponse(
            h3Cell: 6_177_331_234_5,
            centroid: StormSetupCentroid(latitude: 39.742, longitude: -104.991),
            source: source,
            surfaceHeightMslM: 1_642.5,
            freshness: freshness
        ),
        ingredients: StormSetupTornadoIngredientsResponse(
            canonical: canonical,
            diagnostics: diagnostics
        ),
        profileAnalysis: AnvilAnalyzeProfileResponse(
            effectiveLayer: AnvilEffectiveLayerDTO(
                status: "found",
                basePressureMb: 845.0,
                topPressureMb: 512.0,
                baseMetersAgl: 1_050.0,
                topMetersAgl: 5_250.0
            ),
            stormMotion: AnvilStormMotionDTO(
                status: "computed",
                bunkersRight: AnvilBunkersRightStormMotionDTO(
                    uKt: 18.0,
                    vKt: -24.0,
                    speedKt: 30.0,
                    directionTowardDeg: 233.0,
                    uMs: 9.3,
                    vMs: -12.4,
                    speedMs: 15.4
                )
            ),
            mucape: 1_400.0,
            mlcape: 1_100.0,
            mlcin: -42.5,
            mllclMetersAgl: 980.0,
            effectiveSrh: 190.0,
            effectiveBulkShearMs: 25.1,
            scp: 4.2,
            stpCin: 2.1,
            stpFixed: 3.1,
            ship: 1.8,
            srh01km: 210.0,
            srh03km: 280.0,
            sbcape: 1_250.0,
            sbcin: -42.5,
            bulkShear06kmMs: 26.0,
            lapserate03km: 7.8,
            threeCapeJkg: 85.0,
            quality: AnvilQualityDTO(profileLevelCount: 43, warnings: ["none"])
        ),
        tornadoViability: TornadoViabilityReport(
            overall: .supportive,
            realization: .realized,
            primaryFailureMode: .none,
            confidence: .high,
            summary: "Conditions are supportive.",
            details: TornadoViabilityDetails(
                stormViability: .supportive,
                supercellViability: .strong,
                tornadoEfficiency: .supportive,
                inhibition: .weak,
                instability: .strong,
                moisture: .supportive,
                cloudBase: .conditional,
                deepShear: .supportive,
                lowLevelRotation: .strong,
                lowLevelStretching: .conditional,
                cloudBaseEfficiency: .supportive,
                supercellComposite: .supportive,
                tornadoComposite: .supportive,
                stormMode: .conditional
            ),
            limitingFactors: [.conditionalInitiation, .poorMoisture]
        )
    )

    let encoded = try encoder.encode(response)
    let decoded = try decoder.decode(StormSetupCurrentResponse.self, from: encoded)

    #expect(decoded == response)
    #expect(decoded.setup.source.nomadsURL == URL(string: "https://example.com/grib2"))
    #expect(decoded.ingredients.canonical.nonNilFieldCount == 26)
    #expect(decoded.ingredients.diagnostics.temperature2mK == nil)
    #expect(decoded.profileAnalysis?.srh01km == 210.0)
    #expect(decoded.tornadoViability.details.lowLevelStretching == IngredientSupport.conditional)
    #expect(decoded.tornadoViability.limitingFactors == [.conditionalInitiation, .poorMoisture])
}

@Test func stormSetupHelperTypesMirrorSignalBehavior() {
    let source = StormSetupSourceMetadata(
        model: .hrrr,
        product: .wrfprsf,
        domain: .conus,
        runTime: Date(timeIntervalSince1970: 1_750_000_000),
        forecastHour: 6,
        validTime: Date(timeIntervalSince1970: 1_750_021_600),
        fieldSetVersion: .tornadoPressureV2
    )

    #expect(IngredientSupport.supportive.lowered() == .conditional)
    #expect(IngredientSupport.conditional.raised() == .supportive)
    #expect(SnapshotConfidence.high.lowered() == .moderate)
    #expect(SnapshotConfidence.degraded.raised() == .low)
    #expect(IngredientFreshness.make(source: source, fetchedAt: Date(timeIntervalSince1970: 1_750_000_600), staleAfter: 3_600).isDegraded == false)
    #expect(TornadoRawParameters.empty.nonNilFieldCount == 0)
}
