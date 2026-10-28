import Foundation

/// The four values compared for equal consent revisions. Authorization describes Core Location.
public struct DeviceConsentSnapshotV3: Sendable, Codable, Equatable {
    public enum LocationAuthorization: String, Sendable, Codable {
        case always, whenInUse, denied, restricted, notDetermined, unknown
    }

    public let isSubscribed: Bool
    public let mesoNotificationsEnabled: Bool
    public let locationSharingEnabled: Bool
    public let locationAuthorization: LocationAuthorization

    public init(isSubscribed: Bool, mesoNotificationsEnabled: Bool, locationSharingEnabled: Bool, locationAuthorization: LocationAuthorization) {
        self.isSubscribed = isSubscribed
        self.mesoNotificationsEnabled = mesoNotificationsEnabled
        self.locationSharingEnabled = locationSharingEnabled
        self.locationAuthorization = locationAuthorization
    }
}

/// V3 preference request. Start revisions at 1; increment only for changed consent. On overflow or lost durable state, stop sending. A missing or null token preserves the binding; a supplied token updates it. Environment applies only with a token. Stale requests cannot update metadata or binding. Deploy Core, then Signal, then release SkyAware.
public struct DevicePreferencesV3Payload: Sendable, Codable, Equatable {
    public enum APNsEnvironment: String, Sendable, Codable {
        case prod, sandbox
    }

    public let installationId: String
    public let consentRevision: Int64
    public let consent: DeviceConsentSnapshotV3
    public let apnsDeviceToken: String?
    public let apnsEnvironment: APNsEnvironment
    public let platform: String
    public let osVersion: String
    public let appVersion: String
    public let buildNumber: String

    public init(
        installationId: String,
        consentRevision: Int64,
        consent: DeviceConsentSnapshotV3,
        apnsDeviceToken: String?,
        apnsEnvironment: APNsEnvironment,
        platform: String,
        osVersion: String,
        appVersion: String,
        buildNumber: String
    ) throws {
        guard UUID(uuidString: installationId) != nil else { throw ValidationError.invalidInstallationId }
        guard consentRevision > 0 else { throw ValidationError.invalidConsentRevision }
        guard apnsDeviceToken.map({ !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ?? true else { throw ValidationError.invalidAPNsDeviceToken }
        self.installationId = installationId
        self.consentRevision = consentRevision
        self.consent = consent
        self.apnsDeviceToken = apnsDeviceToken
        self.apnsEnvironment = apnsEnvironment
        self.platform = platform
        self.osVersion = osVersion
        self.appVersion = appVersion
        self.buildNumber = buildNumber
    }

    public enum ValidationError: Error, Equatable {
        case invalidInstallationId
        case invalidConsentRevision
        case invalidAPNsDeviceToken
    }

    private enum CodingKeys: String, CodingKey {
        case installationId, consentRevision, consent, apnsDeviceToken, apnsEnvironment, platform, osVersion, appVersion, buildNumber
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            installationId: container.decode(String.self, forKey: .installationId),
            consentRevision: container.decode(Int64.self, forKey: .consentRevision),
            consent: container.decode(DeviceConsentSnapshotV3.self, forKey: .consent),
            apnsDeviceToken: container.decodeIfPresent(String.self, forKey: .apnsDeviceToken),
            apnsEnvironment: container.decode(APNsEnvironment.self, forKey: .apnsEnvironment),
            platform: container.decode(String.self, forKey: .platform),
            osVersion: container.decode(String.self, forKey: .osVersion),
            appVersion: container.decode(String.self, forKey: .appVersion),
            buildNumber: container.decode(String.self, forKey: .buildNumber)
        )
    }
}

/// Accepted server state; stale responses describe current server state. Clients must compare acknowledgments to their current revision before applying ownership. Encode dates as ISO-8601 UTC.
public struct DevicePreferencesV3AcceptedResponse: Sendable, Codable, Equatable {
    public enum Status: String, Sendable, Codable {
        case accepted, unchanged, stale
    }

    public let status: Status
    public let acceptedConsentRevision: Int64
    public let receivedAt: Date
    public let serverOwnsMesoNotificationDelivery: Bool

    public init(
        status: Status,
        acceptedConsentRevision: Int64,
        receivedAt: Date,
        serverOwnsMesoNotificationDelivery: Bool
    ) throws {
        guard acceptedConsentRevision > 0 else { throw ValidationError.invalidConsentRevision }
        self.status = status
        self.acceptedConsentRevision = acceptedConsentRevision
        self.receivedAt = receivedAt
        self.serverOwnsMesoNotificationDelivery = serverOwnsMesoNotificationDelivery
    }

    public enum ValidationError: Error, Equatable {
        case invalidConsentRevision
    }

    private enum CodingKeys: String, CodingKey {
        case status, acceptedConsentRevision, receivedAt, serverOwnsMesoNotificationDelivery
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try self.init(
            status: container.decode(Status.self, forKey: .status),
            acceptedConsentRevision: container.decode(Int64.self, forKey: .acceptedConsentRevision),
            receivedAt: container.decode(Date.self, forKey: .receivedAt),
            serverOwnsMesoNotificationDelivery: container.decode(Bool.self, forKey: .serverOwnsMesoNotificationDelivery)
        )
    }
}
