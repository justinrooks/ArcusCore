//
//  File.swift
//  ArcusCore
//
//  Created by Justin Rooks on 5/26/26.
//

import Foundation

public struct DevicePreferenceSyncPayload: Sendable, Codable, Equatable {
    let installationId: String
    let apnsDeviceToken: String
    let apnsEnvironment: String
    let platform: String
    let osVersion: String
    let appVersion: String
    let buildNumber: String
    let auth: String
    let isSubscribed: Bool
    let source: String
    let reason: String
}
