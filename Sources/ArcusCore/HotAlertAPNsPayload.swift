import Foundation

/// The kind of weather resource identified by a remote notification.
public enum RemoteWeatherProductKind: String, Sendable, Codable, Equatable {
    case nwsAlert
    case mesoscaleDiscussion
}

/// Shared APNs custom payload for targeted weather-product refreshes.
///
/// New payloads identify a product with `productKind` and `resourceID`. Alert
/// payloads also retain `arcusAlertId` and `revisionSent` for older app builds.
public struct HotAlertAPNsPayload: Sendable, Codable, Equatable {
    public static let productKindKey = "productKind"
    public static let resourceIDKey = "resourceID"
    public static let arcusAlertIDKey = "arcusAlertId"
    public static let revisionSentKey = "revisionSent"

    public let productKind: RemoteWeatherProductKind
    public let resourceID: String?
    /// Alert revision metadata. Mesoscale discussions do not have CAP revisions.
    public let revisionSent: Date?

    /// Creates a typed weather-product payload.
    public init?(
        productKind: RemoteWeatherProductKind,
        resourceID: String,
        revisionSent: Date? = nil
    ) {
        guard let resourceID = Self.normalized(resourceID) else { return nil }
        self.productKind = productKind
        self.resourceID = resourceID
        self.revisionSent = productKind == .nwsAlert ? revisionSent : nil
    }

    /// Creates an alert payload using the legacy source-compatible initializer.
    public init(arcusAlertId: String?, revisionSent: Date?) {
        self.productKind = .nwsAlert
        self.resourceID = Self.normalized(arcusAlertId)
        self.revisionSent = revisionSent
    }

    public var arcusAlertId: String? {
        productKind == .nwsAlert ? resourceID : nil
    }

    public var resolvedAlertID: String? {
        arcusAlertId
    }

    private enum CodingKeys: String, CodingKey {
        case productKind
        case resourceID
        case arcusAlertId
        case revisionSent
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let legacyAlertID = Self.normalized(try container.decodeIfPresent(String.self, forKey: .arcusAlertId))
        let decodedKind = try container.decodeIfPresent(RemoteWeatherProductKind.self, forKey: .productKind)
        let decodedResourceID = Self.normalized(try container.decodeIfPresent(String.self, forKey: .resourceID))

        // A missing discriminator is the original alert-only wire format.
        if decodedKind == nil, decodedResourceID != nil, legacyAlertID == nil {
            throw DecodingError.dataCorruptedError(
                forKey: .productKind,
                in: container,
                debugDescription: "A typed resourceID requires a productKind"
            )
        }
        let kind = decodedKind ?? .nwsAlert
        if kind == .mesoscaleDiscussion, legacyAlertID != nil {
            throw DecodingError.dataCorruptedError(
                forKey: .arcusAlertId,
                in: container,
                debugDescription: "Mesoscale discussion payloads cannot contain arcusAlertId"
            )
        }
        if kind == .nwsAlert, let decodedResourceID, let legacyAlertID, decodedResourceID != legacyAlertID {
            throw DecodingError.dataCorruptedError(
                forKey: .resourceID,
                in: container,
                debugDescription: "resourceID must match arcusAlertId when both are present"
            )
        }
        let identifier = decodedResourceID ?? (kind == .nwsAlert ? legacyAlertID : nil)
        if decodedKind != nil, identifier == nil {
            throw DecodingError.dataCorruptedError(
                forKey: .resourceID,
                in: container,
                debugDescription: "A resourceID is required for a typed product payload"
            )
        }

        productKind = kind
        resourceID = identifier
        revisionSent = kind == .nwsAlert
            ? try container.decodeIfPresent(Date.self, forKey: .revisionSent)
            : nil
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productKind, forKey: .productKind)
        if productKind == .nwsAlert {
            if let resourceID {
                // Keep the legacy keys during staggered app/server rollout.
                try container.encode(resourceID, forKey: .resourceID)
                try container.encode(resourceID, forKey: .arcusAlertId)
            }
            try container.encodeIfPresent(revisionSent, forKey: .revisionSent)
        } else if let resourceID {
            try container.encode(resourceID, forKey: .resourceID)
        }
    }

    private static func normalized(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
