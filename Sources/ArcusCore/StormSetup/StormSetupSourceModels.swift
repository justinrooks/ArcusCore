import Foundation

public struct StormSetupSourceMetadata: Sendable, Codable, Equatable {
    public let sourceKind: HrrrSourceKind
    public let model: HrrrModel?
    public let product: HrrrProduct?
    public let domain: HrrrDomain?
    public let runTime: Date?
    public let forecastHour: Int?
    public let validTime: Date?
    public let fieldSetVersion: HrrrFieldSetVersion?
    public let bbox: StormSetupHrrrBoundingBox?
    public let primaryDownloadURL: URL?
    public let idxURL: URL?

    public init(
        sourceKind: HrrrSourceKind = .nomadsFilteredSubset,
        model: HrrrModel?,
        product: HrrrProduct?,
        domain: HrrrDomain?,
        runTime: Date?,
        forecastHour: Int?,
        validTime: Date?,
        fieldSetVersion: HrrrFieldSetVersion?,
        bbox: StormSetupHrrrBoundingBox? = nil,
        primaryDownloadURL: URL? = nil,
        idxURL: URL? = nil
    ) {
        self.sourceKind = sourceKind
        self.model = model
        self.product = product
        self.domain = domain
        self.runTime = runTime
        self.forecastHour = forecastHour
        self.validTime = validTime
        self.fieldSetVersion = fieldSetVersion
        self.bbox = bbox
        self.primaryDownloadURL = primaryDownloadURL
        self.idxURL = idxURL
    }

    public init(
        model: HrrrModel?,
        product: HrrrProduct?,
        domain: HrrrDomain?,
        runTime: Date?,
        forecastHour: Int?,
        validTime: Date?,
        fieldSetVersion: HrrrFieldSetVersion?,
        bbox: StormSetupHrrrBoundingBox? = nil,
        nomadsURL: URL? = nil
    ) {
        self.init(
            sourceKind: .nomadsFilteredSubset,
            model: model,
            product: product,
            domain: domain,
            runTime: runTime,
            forecastHour: forecastHour,
            validTime: validTime,
            fieldSetVersion: fieldSetVersion,
            bbox: bbox,
            primaryDownloadURL: nomadsURL,
            idxURL: nil
        )
    }

    public var nomadsURL: URL? {
        primaryDownloadURL
    }
}

public struct StormSetupHrrrBoundingBox: Sendable, Codable, Equatable {
    public let leftlon: Double
    public let rightlon: Double
    public let toplat: Double
    public let bottomlat: Double

    public init(
        leftlon: Double,
        rightlon: Double,
        toplat: Double,
        bottomlat: Double
    ) {
        self.leftlon = leftlon
        self.rightlon = rightlon
        self.toplat = toplat
        self.bottomlat = bottomlat
    }

    public init(
        around centroid: StormSetupCentroid,
        halfWidthDegrees: Double = 0.15,
        halfHeightDegrees: Double = 0.175
    ) {
        self.leftlon = centroid.longitude - halfWidthDegrees
        self.rightlon = centroid.longitude + halfWidthDegrees
        self.toplat = centroid.latitude + halfHeightDegrees
        self.bottomlat = centroid.latitude - halfHeightDegrees
    }
}

public enum HrrrSourceKind: String, Sendable, Codable, Equatable {
    case nomadsFilteredSubset
    case directObject
}

public enum HrrrModel: String, Sendable, Codable, Equatable {
    case hrrr = "HRRR"
}

public enum HrrrProduct: String, Sendable, Codable, Equatable {
    case wrfsfc
    case wrfprsf

    public var defaultFieldSetVersion: HrrrFieldSetVersion {
        switch self {
        case .wrfsfc:
            return .tornadoV1
        case .wrfprsf:
            return .tornadoPressureV2
        }
    }

    public var fileNameStem: String {
        switch self {
        case .wrfsfc:
            return "wrfsfcf"
        case .wrfprsf:
            return "wrfprsf"
        }
    }
}

public enum HrrrDomain: String, Sendable, Codable, Equatable {
    case conus
}

public enum HrrrFieldSetVersion: String, Sendable, Codable, Equatable {
    case tornadoV1 = "tornado-v1"
    case anvilSurfaceV1 = "anvil-surface-v1"
    case tornadoPressureV1 = "tornado-pressure-v1"
    case tornadoPressureV2 = "tornado-pressure-v2"

    public var nomadsVariableFlags: [String] {
        switch self {
        case .tornadoV1:
            return [
                "var_CAPE",
                "var_CIN",
                "var_HLCY",
                "var_VUCSH",
                "var_VVCSH",
                "var_USTM",
                "var_VSTM",
                "var_HGT",
                "var_DPT",
                "var_TMP"
            ]
        case .anvilSurfaceV1:
            return [
                "var_PRES",
                "var_HGT",
                "var_TMP",
                "var_DPT",
                "var_UGRD",
                "var_VGRD"
            ]
        case .tornadoPressureV1, .tornadoPressureV2:
            return [
                "var_HGT",
                "var_TMP",
                "var_DPT",
                "var_UGRD",
                "var_VGRD"
            ]
        }
    }

    public var nomadsLevelFlags: [String] {
        switch self {
        case .tornadoV1:
            return [
                "lev_surface",
                "lev_0-3000_m_above_ground",
                "lev_2_m_above_ground",
                "lev_90-0_mb_above_ground",
                "lev_255-0_mb_above_ground",
                "lev_1000-0_m_above_ground",
                "lev_3000-0_m_above_ground",
                "lev_0-6000_m_above_ground",
                "lev_level_of_adiabatic_condensation_from_sfc"
            ]
        case .anvilSurfaceV1:
            return [
                "lev_surface",
                "lev_2_m_above_ground",
                "lev_10_m_above_ground"
            ]
        case .tornadoPressureV1:
            return [
                "lev_1000_mb",
                "lev_925_mb",
                "lev_850_mb",
                "lev_700_mb",
                "lev_500_mb",
                "lev_300_mb",
                "lev_250_mb"
            ]
        case .tornadoPressureV2:
            return [
                "lev_1000_mb",
                "lev_975_mb",
                "lev_950_mb",
                "lev_925_mb",
                "lev_900_mb",
                "lev_875_mb",
                "lev_850_mb",
                "lev_825_mb",
                "lev_800_mb",
                "lev_775_mb",
                "lev_750_mb",
                "lev_725_mb",
                "lev_700_mb",
                "lev_675_mb",
                "lev_650_mb",
                "lev_625_mb",
                "lev_600_mb",
                "lev_575_mb",
                "lev_550_mb",
                "lev_525_mb",
                "lev_500_mb",
                "lev_475_mb",
                "lev_450_mb",
                "lev_425_mb",
                "lev_400_mb",
                "lev_375_mb",
                "lev_350_mb",
                "lev_325_mb",
                "lev_300_mb",
                "lev_275_mb",
                "lev_250_mb",
                "lev_225_mb",
                "lev_200_mb",
                "lev_175_mb",
                "lev_150_mb",
                "lev_125_mb",
                "lev_100_mb"
            ]
        }
    }
}

public struct IngredientFreshness: Sendable, Codable, Equatable {
    public let sourceValidTime: Date?
    public let modelRunTime: Date?
    public let forecastHour: Int?
    public let fetchedAt: Date
    public let expiresAt: Date
    public let isStale: Bool
    public let isDegraded: Bool

    public init(
        sourceValidTime: Date?,
        modelRunTime: Date?,
        forecastHour: Int?,
        fetchedAt: Date,
        expiresAt: Date,
        isStale: Bool,
        isDegraded: Bool
    ) {
        self.sourceValidTime = sourceValidTime
        self.modelRunTime = modelRunTime
        self.forecastHour = forecastHour
        self.fetchedAt = fetchedAt
        self.expiresAt = expiresAt
        self.isStale = isStale
        self.isDegraded = isDegraded
    }
}

public extension IngredientFreshness {
    static func make(
        source: StormSetupSourceMetadata,
        fetchedAt: Date,
        staleAfter: TimeInterval = 90 * 60
    ) -> IngredientFreshness {
        let sourceReferenceTime = source.validTime ?? source.runTime ?? fetchedAt
        let expiresAt = sourceReferenceTime.addingTimeInterval(staleAfter)
        let isStale = fetchedAt >= expiresAt
        let isDegraded = isStale || source.validTime == nil || source.runTime == nil || source.forecastHour == nil

        return IngredientFreshness(
            sourceValidTime: source.validTime,
            modelRunTime: source.runTime,
            forecastHour: source.forecastHour,
            fetchedAt: fetchedAt,
            expiresAt: expiresAt,
            isStale: isStale,
            isDegraded: isDegraded
        )
    }
}
