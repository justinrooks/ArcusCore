import Foundation
import Testing
@testable import ArcusCore

@Test func tornadoViabilityEnumsUseRawStringPayloads() throws {
    for value in [
        TornadoViabilityRealization.unknown,
        .blocked,
        .conditional,
        .realized,
    ] {
        let encoded = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder().decode(TornadoViabilityRealization.self, from: encoded)

        #expect(try JSONSerialization.jsonObject(with: encoded, options: [.fragmentsAllowed]) as? String == value.rawValue)
        #expect(decoded == value)
    }

    for value in [
        TornadoViabilityFailureMode.none,
        .weakInstability,
        .weakDeepShear,
        .weakLowLevelRotation,
        .weakLowLevelStretching,
        .elevatedCloudBases,
        .strongCap,
        .conditionalInitiation,
        .weakStormOrganization,
        .weakLift,
        .messyStormMode,
        .poorMoisture,
        .fixedEffectiveStpDisagreement,
        .missingStormMode,
        .compositeMismatch,
    ] {
        let encoded = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder().decode(TornadoViabilityFailureMode.self, from: encoded)

        #expect(try JSONSerialization.jsonObject(with: encoded, options: [.fragmentsAllowed]) as? String == value.rawValue)
        #expect(decoded == value)
    }
}

@Test func tornadoViabilityEnumsDecodeLegacyObjectPayloadsAndReencodeAsRawStrings() throws {
    let realization = try JSONDecoder().decode(
        TornadoViabilityRealization.self,
        from: Data(#"{"conditional":{}}"#.utf8)
    )
    let failureMode = try JSONDecoder().decode(
        TornadoViabilityFailureMode.self,
        from: Data(#"{"conditionalInitiation":{}}"#.utf8)
    )

    let realizationEncoded = try JSONEncoder().encode(realization)
    let failureModeEncoded = try JSONEncoder().encode(failureMode)

    #expect(realization == .conditional)
    #expect(failureMode == .conditionalInitiation)
    #expect(try JSONSerialization.jsonObject(with: realizationEncoded, options: [.fragmentsAllowed]) as? String == "conditional")
    #expect(try JSONSerialization.jsonObject(with: failureModeEncoded, options: [.fragmentsAllowed]) as? String == "conditionalInitiation")
}

@Test func tornadoViabilityEnumsRejectInvalidPayloads() throws {
    try assertDecodingFails(
        TornadoViabilityRealization.self,
        data: Data(#""mystery""#.utf8),
        expectedMessage: "Unknown tornado viability realization raw value 'mystery'."
    )
    try assertDecodingFails(
        TornadoViabilityFailureMode.self,
        data: Data(#""not-a-mode""#.utf8),
        expectedMessage: "Unknown tornado viability failure mode raw value 'not-a-mode'."
    )

    try assertDecodingFails(
        TornadoViabilityRealization.self,
        data: Data(#"{"mystery":{}}"#.utf8),
        expectedMessage: "Unknown legacy tornado viability realization case key 'mystery'."
    )
    try assertDecodingFails(
        TornadoViabilityFailureMode.self,
        data: Data(#"{"mystery":{}}"#.utf8),
        expectedMessage: "Unknown legacy tornado viability failure mode case key 'mystery'."
    )

    try assertDecodingFails(
        TornadoViabilityRealization.self,
        data: Data(#"{}"#.utf8),
        expectedMessage: "Expected one legacy tornado viability realization case key, but found none."
    )
    try assertDecodingFails(
        TornadoViabilityFailureMode.self,
        data: Data(#"{}"#.utf8),
        expectedMessage: "Expected one legacy tornado viability failure mode case key, but found none."
    )

    try assertDecodingFails(
        TornadoViabilityRealization.self,
        data: Data(#"{"blocked":{},"conditional":{}}"#.utf8),
        expectedMessage: "Expected exactly one legacy tornado viability realization case key."
    )
    try assertDecodingFails(
        TornadoViabilityFailureMode.self,
        data: Data(#"{"none":{},"conditionalInitiation":{}}"#.utf8),
        expectedMessage: "Expected exactly one legacy tornado viability failure mode case key."
    )

    try assertDecodingFails(
        TornadoViabilityRealization.self,
        data: Data(#"{"blocked":{"unexpected":true}}"#.utf8),
        expectedMessage: "Expected legacy tornado viability realization case 'blocked' to contain an empty object."
    )
    try assertDecodingFails(
        TornadoViabilityFailureMode.self,
        data: Data(#"{"conditionalInitiation":{"unexpected":true}}"#.utf8),
        expectedMessage: "Expected legacy tornado viability failure mode case 'conditionalInitiation' to contain an empty object."
    )
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

private func assertDecodingFails<T: Decodable>(
    _ type: T.Type,
    data: Data,
    expectedMessage: String
) throws {
    do {
        _ = try JSONDecoder().decode(T.self, from: data)
        #expect(Bool(false))
    } catch let error as DecodingError {
        guard case let .dataCorrupted(context) = error else {
            #expect(Bool(false))
            return
        }

        #expect(context.debugDescription == expectedMessage)
    } catch {
        #expect(Bool(false))
    }
}
