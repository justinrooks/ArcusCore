//
//  File.swift
//  ArcusCore
//
//  Created by Justin Rooks on 5/26/26.
//

import Foundation

public struct DevicePreferenceSyncPayload: Sendable, Codable, Equatable {
    public let installationId: String
    public let apnsDeviceToken: String
    public let apnsEnvironment: String
    public let platform: String
    public let osVersion: String
    public let appVersion: String
    public let buildNumber: String
    public let auth: String
    public let isSubscribed: Bool
    public let source: String
    public let reason: String
    
    public init(
        installationId: String,
        apnsDeviceToken: String,
        apnsEnvironment: String,
        platform: String,
        osVersion: String,
        appVersion: String,
        buildNumber: String,
        auth: String,
        isSubscribed: Bool,
        source: String,
        reason: String
    ) {
        self.installationId = installationId
        self.apnsDeviceToken = apnsDeviceToken
        self.apnsEnvironment = apnsEnvironment
        self.platform = platform
        self.osVersion = osVersion
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.auth = auth
        self.isSubscribed = isSubscribed
        self.source = source
        self.reason = reason
    }
    
    private enum CodingKeys: String, CodingKey {
        case installationId, apnsDeviceToken, apnsEnvironment, platform, osVersion, appVersion, buildNumber, auth, isSubscribed, source, reason
    }
}
