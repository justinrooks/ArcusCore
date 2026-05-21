import Foundation

/// Shared APNs custom payload contract for remote hot-alert ingestion.
/// `arcusAlertId` is the canonical public identifier.
public struct HotAlertAPNsPayload: Sendable, Codable, Equatable {
    public static let arcusAlertIDKey = "arcusAlertId"
    public static let revisionSentKey = "revisionSent"

    public let arcusAlertId: String?
    public let revisionSent: Date?

    public init(
        arcusAlertId: String?,
        revisionSent: Date?
    ) {
        self.arcusAlertId = Self.normalized(arcusAlertId)
        self.revisionSent = revisionSent
    }

    public var resolvedAlertID: String? {
        arcusAlertId
    }

    enum CodingKeys: String, CodingKey {
        case arcusAlertId
        case revisionSent = "revisionSent"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.arcusAlertId = Self.normalized(try container.decodeIfPresent(String.self, forKey: .arcusAlertId))
        self.revisionSent = try container.decodeIfPresent(Date.self, forKey: .revisionSent)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(arcusAlertId, forKey: .arcusAlertId)
        try container.encodeIfPresent(revisionSent, forKey: .revisionSent)
    }

    private static func normalized(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
