import Foundation

public struct AnvilAnalyzeProfileResponse: Sendable, Codable, Equatable {
    public let effectiveLayer: AnvilEffectiveLayerDTO
    public let stormMotion: AnvilStormMotionDTO
    public let mucape: Double?
    public let mlcape: Double?
    public let mlcin: Double?
    public let mllclMetersAgl: Double?
    public let effectiveSrh: Double?
    public let effectiveBulkShearMs: Double?
    public let scp: Double?
    public let stpCin: Double?
    public let stpFixed: Double?
    public let ship: Double?
    public let srh01km: Double?
    public let srh03km: Double?
    public let sbcape: Double?
    public let sbcin: Double?
    public let bulkShear06kmMs: Double?
    public let lapserate03km: Double?
    public let threeCapeJkg: Double?
    public let quality: AnvilQualityDTO

    public init(
        effectiveLayer: AnvilEffectiveLayerDTO,
        stormMotion: AnvilStormMotionDTO,
        mucape: Double?,
        mlcape: Double?,
        mlcin: Double?,
        mllclMetersAgl: Double?,
        effectiveSrh: Double?,
        effectiveBulkShearMs: Double?,
        scp: Double?,
        stpCin: Double?,
        stpFixed: Double?,
        ship: Double?,
        srh01km: Double? = nil,
        srh03km: Double? = nil,
        sbcape: Double? = nil,
        sbcin: Double? = nil,
        bulkShear06kmMs: Double? = nil,
        lapserate03km: Double? = nil,
        threeCapeJkg: Double? = nil,
        quality: AnvilQualityDTO
    ) {
        self.effectiveLayer = effectiveLayer
        self.stormMotion = stormMotion
        self.mucape = mucape
        self.mlcape = mlcape
        self.mlcin = mlcin
        self.mllclMetersAgl = mllclMetersAgl
        self.effectiveSrh = effectiveSrh
        self.effectiveBulkShearMs = effectiveBulkShearMs
        self.scp = scp
        self.stpCin = stpCin
        self.stpFixed = stpFixed
        self.ship = ship
        self.srh01km = srh01km
        self.srh03km = srh03km
        self.sbcape = sbcape
        self.sbcin = sbcin
        self.bulkShear06kmMs = bulkShear06kmMs
        self.lapserate03km = lapserate03km
        self.threeCapeJkg = threeCapeJkg
        self.quality = quality
    }
}

public struct AnvilEffectiveLayerDTO: Sendable, Codable, Equatable {
    public let status: String
    public let basePressureMb: Double?
    public let topPressureMb: Double?
    public let baseMetersAgl: Double?
    public let topMetersAgl: Double?

    public init(
        status: String,
        basePressureMb: Double?,
        topPressureMb: Double?,
        baseMetersAgl: Double?,
        topMetersAgl: Double?
    ) {
        self.status = status
        self.basePressureMb = basePressureMb
        self.topPressureMb = topPressureMb
        self.baseMetersAgl = baseMetersAgl
        self.topMetersAgl = topMetersAgl
    }
}

public struct AnvilQualityDTO: Sendable, Codable, Equatable {
    public let profileLevelCount: Int
    public let warnings: [String]

    public init(profileLevelCount: Int, warnings: [String]) {
        self.profileLevelCount = profileLevelCount
        self.warnings = warnings
    }
}

public struct AnvilStormMotionDTO: Sendable, Codable, Equatable {
    public let status: String
    public let bunkersRight: AnvilBunkersRightStormMotionDTO?

    public init(status: String, bunkersRight: AnvilBunkersRightStormMotionDTO?) {
        self.status = status
        self.bunkersRight = bunkersRight
    }
}

public struct AnvilBunkersRightStormMotionDTO: Sendable, Codable, Equatable {
    public let uKt: Double
    public let vKt: Double
    public let speedKt: Double
    public let directionTowardDeg: Double
    public let uMs: Double
    public let vMs: Double
    public let speedMs: Double

    public init(
        uKt: Double,
        vKt: Double,
        speedKt: Double,
        directionTowardDeg: Double,
        uMs: Double,
        vMs: Double,
        speedMs: Double
    ) {
        self.uKt = uKt
        self.vKt = vKt
        self.speedKt = speedKt
        self.directionTowardDeg = directionTowardDeg
        self.uMs = uMs
        self.vMs = vMs
        self.speedMs = speedMs
    }
}
