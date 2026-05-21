import Foundation

/// Shared APNs custom payload contract for remote hot-alert ingestion.
public struct HotAlertAPNsPayload: Sendable, Codable, Equatable {
    public static let alertIDKey = "alertID"
    public static let seriesIDKey = "seriesId"
    public static let revisionSentKey = "revisionSent"

    public let alertID: String?
    public let seriesId: String?
    public let revisionSent: Date?

    public init(
        alertID: String?,
        seriesId: String?,
        revisionSent: Date?
    ) {
        self.alertID = Self.normalized(alertID)
        self.seriesId = Self.normalized(seriesId)
        self.revisionSent = revisionSent
    }

    public var resolvedAlertID: String? {
        alertID ?? seriesId
    }

    enum CodingKeys: String, CodingKey {
        case alertID = "alertID"
        case seriesId = "seriesId"
        case revisionSent = "revisionSent"
    }

    private static func normalized(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
