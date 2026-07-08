import Foundation

public struct TornadoRawParameters: Sendable, Codable, Equatable {
    public let sbcapeJkg: Double?
    public let mlcapeJkg: Double?
    public let mucapeJkg: Double?
    public let mlcinJkg: Double?
    public let dcapeJkg: Double?
    public let mllclM: Double?
    public let tempDewPtDeltaF: Double?
    public let temperature2mK: Double?
    public let dewpoint2mK: Double?
    public let surfacePressurePa: Double?
    public let wind10m: DirectionSpeed?
    public let threeCapeJkg: Double?
    public let lclLfcSeparationM: Double?
    public let lapseRate03kmCkm: Double?
    public let lapseRate700500mbCkm: Double?
    public let shear06kmKt: Double?
    public let shear03kmKt: Double?
    public let shear01kmKt: Double?
    public let effectiveShearKt: Double?
    public let srh01kmM2s2: Double?
    public let srh03kmM2s2: Double?
    public let effectiveSrhM2s2: Double?
    public let supercellComposite: Double?
    public let significantTornadoFixed: Double?
    public let significantTornadoEffective: Double?
    public let significantHail: Double?
    public let bunkersRightMotion: DirectionSpeed?
    public let bunkersLeftMotion: DirectionSpeed?
    public let stormRelativeWind46km: DirectionSpeed?
    public let meanWind850300mb: DirectionSpeed?
    public let effectiveBulkShearMs: Double?
    public let effectiveLayer: AnvilEffectiveLayerDTO?
    public let stormMotion: AnvilStormMotionDTO?
    public let diagnostics: [TornadoRawParameterDiagnostic]?

    public init(
        sbcapeJkg: Double?,
        mlcapeJkg: Double?,
        mucapeJkg: Double?,
        mlcinJkg: Double?,
        dcapeJkg: Double?,
        mllclM: Double?,
        tempDewPtDeltaF: Double? = nil,
        temperature2mK: Double? = nil,
        dewpoint2mK: Double? = nil,
        surfacePressurePa: Double? = nil,
        wind10m: DirectionSpeed? = nil,
        threeCapeJkg: Double? = nil,
        lclLfcSeparationM: Double?,
        lapseRate03kmCkm: Double?,
        lapseRate700500mbCkm: Double?,
        shear06kmKt: Double?,
        shear03kmKt: Double?,
        shear01kmKt: Double?,
        effectiveShearKt: Double?,
        srh01kmM2s2: Double?,
        srh03kmM2s2: Double?,
        effectiveSrhM2s2: Double?,
        supercellComposite: Double?,
        significantTornadoFixed: Double?,
        significantTornadoEffective: Double?,
        significantHail: Double?,
        bunkersRightMotion: DirectionSpeed?,
        bunkersLeftMotion: DirectionSpeed?,
        stormRelativeWind46km: DirectionSpeed?,
        meanWind850300mb: DirectionSpeed?,
        diagnostics: [TornadoRawParameterDiagnostic]? = nil,
        effectiveBulkShearMs: Double? = nil,
        effectiveLayer: AnvilEffectiveLayerDTO? = nil,
        stormMotion: AnvilStormMotionDTO? = nil
    ) {
        self.sbcapeJkg = sbcapeJkg
        self.mlcapeJkg = mlcapeJkg
        self.mucapeJkg = mucapeJkg
        self.mlcinJkg = mlcinJkg
        self.dcapeJkg = dcapeJkg
        self.mllclM = mllclM
        self.tempDewPtDeltaF = tempDewPtDeltaF
        self.temperature2mK = temperature2mK
        self.dewpoint2mK = dewpoint2mK
        self.surfacePressurePa = surfacePressurePa
        self.wind10m = wind10m
        self.threeCapeJkg = threeCapeJkg
        self.lclLfcSeparationM = lclLfcSeparationM
        self.lapseRate03kmCkm = lapseRate03kmCkm
        self.lapseRate700500mbCkm = lapseRate700500mbCkm
        self.shear06kmKt = shear06kmKt
        self.shear03kmKt = shear03kmKt
        self.shear01kmKt = shear01kmKt
        self.effectiveShearKt = effectiveShearKt
        self.srh01kmM2s2 = srh01kmM2s2
        self.srh03kmM2s2 = srh03kmM2s2
        self.effectiveSrhM2s2 = effectiveSrhM2s2
        self.supercellComposite = supercellComposite
        self.significantTornadoFixed = significantTornadoFixed
        self.significantTornadoEffective = significantTornadoEffective
        self.significantHail = significantHail
        self.bunkersRightMotion = bunkersRightMotion
        self.bunkersLeftMotion = bunkersLeftMotion
        self.stormRelativeWind46km = stormRelativeWind46km
        self.meanWind850300mb = meanWind850300mb
        self.effectiveBulkShearMs = effectiveBulkShearMs
        self.effectiveLayer = effectiveLayer
        self.stormMotion = stormMotion
        self.diagnostics = diagnostics
    }
}

public extension TornadoRawParameters {
    init(
        sbcapeJkg: Double?,
        mlcapeJkg: Double?,
        mucapeJkg: Double?,
        mlcinJkg: Double?,
        dcapeJkg: Double?,
        mllclM: Double?,
        tempDewPtDeltaF: Double? = nil,
        temperature2mK: Double? = nil,
        dewpoint2mK: Double? = nil,
        surfacePressurePa: Double? = nil,
        wind10m: DirectionSpeed? = nil,
        threeCapeJkg: Double? = nil,
        lclLfcSeparationM: Double?,
        lapseRate03kmCkm: Double?,
        lapseRate700500mbCkm: Double?,
        shear06kmKt: Double?,
        shear03kmKt: Double?,
        shear01kmKt: Double?,
        effectiveShearKt: Double?,
        srh01kmM2s2: Double?,
        srh03kmM2s2: Double?,
        effectiveSrhM2s2: Double?,
        supercellComposite: Double?,
        significantTornadoFixed: Double?,
        significantTornadoEffective: Double?,
        bunkersRightMotion: DirectionSpeed?,
        bunkersLeftMotion: DirectionSpeed?,
        stormRelativeWind46km: DirectionSpeed?,
        meanWind850300mb: DirectionSpeed?,
        diagnostics: [TornadoRawParameterDiagnostic]? = nil,
        effectiveBulkShearMs: Double? = nil,
        effectiveLayer: AnvilEffectiveLayerDTO? = nil,
        stormMotion: AnvilStormMotionDTO? = nil,
        ship: Double? = nil
    ) {
        self.init(
            sbcapeJkg: sbcapeJkg,
            mlcapeJkg: mlcapeJkg,
            mucapeJkg: mucapeJkg,
            mlcinJkg: mlcinJkg,
            dcapeJkg: dcapeJkg,
            mllclM: mllclM,
            tempDewPtDeltaF: tempDewPtDeltaF,
            temperature2mK: temperature2mK,
            dewpoint2mK: dewpoint2mK,
            surfacePressurePa: surfacePressurePa,
            wind10m: wind10m,
            threeCapeJkg: threeCapeJkg,
            lclLfcSeparationM: lclLfcSeparationM,
            lapseRate03kmCkm: lapseRate03kmCkm,
            lapseRate700500mbCkm: lapseRate700500mbCkm,
            shear06kmKt: shear06kmKt,
            shear03kmKt: shear03kmKt,
            shear01kmKt: shear01kmKt,
            effectiveShearKt: effectiveShearKt,
            srh01kmM2s2: srh01kmM2s2,
            srh03kmM2s2: srh03kmM2s2,
            effectiveSrhM2s2: effectiveSrhM2s2,
            supercellComposite: supercellComposite,
            significantTornadoFixed: significantTornadoFixed,
            significantTornadoEffective: significantTornadoEffective,
            significantHail: ship,
            bunkersRightMotion: bunkersRightMotion,
            bunkersLeftMotion: bunkersLeftMotion,
            stormRelativeWind46km: stormRelativeWind46km,
            meanWind850300mb: meanWind850300mb,
            diagnostics: diagnostics,
            effectiveBulkShearMs: effectiveBulkShearMs,
            effectiveLayer: effectiveLayer,
            stormMotion: stormMotion
        )
    }

    static let empty = TornadoRawParameters(
        sbcapeJkg: nil,
        mlcapeJkg: nil,
        mucapeJkg: nil,
        mlcinJkg: nil,
        dcapeJkg: nil,
        mllclM: nil,
        tempDewPtDeltaF: nil,
        temperature2mK: nil,
        dewpoint2mK: nil,
        surfacePressurePa: nil,
        wind10m: nil,
        threeCapeJkg: nil,
        lclLfcSeparationM: nil,
        lapseRate03kmCkm: nil,
        lapseRate700500mbCkm: nil,
        shear06kmKt: nil,
        shear03kmKt: nil,
        shear01kmKt: nil,
        effectiveShearKt: nil,
        srh01kmM2s2: nil,
        srh03kmM2s2: nil,
        effectiveSrhM2s2: nil,
        supercellComposite: nil,
        significantTornadoFixed: nil,
        significantTornadoEffective: nil,
        significantHail: nil,
        bunkersRightMotion: nil,
        bunkersLeftMotion: nil,
        stormRelativeWind46km: nil,
        meanWind850300mb: nil,
        diagnostics: nil,
        effectiveBulkShearMs: nil,
        effectiveLayer: nil,
        stormMotion: nil
    )

    var nonNilFieldCount: Int {
        [
            sbcapeJkg != nil,
            mlcapeJkg != nil,
            mucapeJkg != nil,
            mlcinJkg != nil,
            dcapeJkg != nil,
            mllclM != nil,
            tempDewPtDeltaF != nil,
            threeCapeJkg != nil,
            lclLfcSeparationM != nil,
            lapseRate03kmCkm != nil,
            lapseRate700500mbCkm != nil,
            shear06kmKt != nil,
            shear03kmKt != nil,
            shear01kmKt != nil,
            effectiveShearKt != nil,
            srh01kmM2s2 != nil,
            srh03kmM2s2 != nil,
            effectiveSrhM2s2 != nil,
            supercellComposite != nil,
            significantTornadoFixed != nil,
            significantTornadoEffective != nil,
            significantHail != nil,
            bunkersRightMotion != nil,
            bunkersLeftMotion != nil,
            stormRelativeWind46km != nil,
            meanWind850300mb != nil
        ]
        .filter { $0 }
        .count
    }

    var ship: Double? {
        significantHail
    }
}

public struct DirectionSpeed: Sendable, Codable, Equatable {
    public let directionDegrees: Double
    public let speedKt: Double

    public init(directionDegrees: Double, speedKt: Double) {
        self.directionDegrees = directionDegrees
        self.speedKt = speedKt
    }
}

public enum TornadoRawParameterKey: String, Sendable, Codable, Equatable {
    case sbcapeJkg
    case mlcapeJkg
    case mucapeJkg
    case mlcinJkg
    case temperature2mK
    case dewpoint2mK
    case surfacePressurePa
    case wind10m
    case tempDewPtDeltaF
    case threeCapeJkg
    case srh01kmM2s2
    case srh03kmM2s2
    case effectiveSrhM2s2
    case shear06kmKt
    case effectiveShearKt
    case mllclM
}

public struct TornadoRawParameterDiagnostic: Sendable, Codable, Equatable {
    public let inventory: String
    public let parsedValue: Double?
    public let matchedRawParameterKey: TornadoRawParameterKey?
    public let requestedLongitude: Double
    public let requestedLatitude: Double
    public let nearestLongitude: Double?
    public let nearestLatitude: Double?

    public init(
        inventory: String,
        parsedValue: Double?,
        matchedRawParameterKey: TornadoRawParameterKey?,
        requestedLongitude: Double,
        requestedLatitude: Double,
        nearestLongitude: Double? = nil,
        nearestLatitude: Double? = nil
    ) {
        self.inventory = inventory
        self.parsedValue = parsedValue
        self.matchedRawParameterKey = matchedRawParameterKey
        self.requestedLongitude = requestedLongitude
        self.requestedLatitude = requestedLatitude
        self.nearestLongitude = nearestLongitude
        self.nearestLatitude = nearestLatitude
    }
}
