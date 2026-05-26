//
//  File.swift
//  ArcusCore
//
//  Created by Justin Rooks on 5/26/26.
//

import Foundation

public enum LocationUploadSource: String, Sendable, Codable {
    case foregroundPrime
    case foregroundActivate
    case foregroundLocationChange
    case manualRefresh
    case backgroundRefresh
    case backgroundLocationChange
    case onboarding
    case settingsPreference
    case unknown
}
