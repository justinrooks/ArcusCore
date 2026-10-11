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
    /// Whether the server currently owns mesoscale discussion notification delivery.
    /// `nil` means an older response did not report delivery ownership.
    public let serverOwnsMesoNotificationDelivery: Bool?
    
    public init(
        status: String,
        receivedAt: Date,
        serverOwnsMesoNotificationDelivery: Bool? = nil
    ) {
        self.status = status
        self.receivedAt = receivedAt
        self.serverOwnsMesoNotificationDelivery = serverOwnsMesoNotificationDelivery
    }
    
    private enum CodingKeys: String, CodingKey {
        case status, receivedAt, serverOwnsMesoNotificationDelivery
    }
}
