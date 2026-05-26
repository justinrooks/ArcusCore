//
//  File.swift
//  ArcusCore
//
//  Created by Justin Rooks on 5/26/26.
//

import Foundation

public struct DevicePreferenceSyncAcceptedResponse: Sendable, Codable {
    public let status: String
    public let receivedAt: Date
    
    public init(status: String, receivedAt: Date) {
        self.status = status
        self.receivedAt = receivedAt
    }
    
    private enum CodingKeys: String, CodingKey {
        case status, receivedAt
    }
}
