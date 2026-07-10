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
}

public enum HrrrDomain: String, Sendable, Codable, Equatable {
    case conus
}

public enum HrrrFieldSetVersion: String, Sendable, Codable, Equatable {
    case tornadoV1 = "tornado-v1"
    case anvilSurfaceV1 = "anvil-surface-v1"
    case tornadoPressureV1 = "tornado-pressure-v1"
    case tornadoPressureV2 = "tornado-pressure-v2"
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
