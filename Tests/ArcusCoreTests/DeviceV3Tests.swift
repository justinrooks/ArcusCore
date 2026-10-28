import Foundation
import Testing
@testable import ArcusCore

private let preferencesJSON = #"{"installationId":"550e8400-e29b-41d4-a716-446655440000","consentRevision":12,"consent":{"isSubscribed":false,"mesoNotificationsEnabled":true,"locationSharingEnabled":false,"locationAuthorization":"always"},"apnsDeviceToken":null,"apnsEnvironment":"prod","platform":"iOS","osVersion":"26.1","appVersion":"1.2.0","buildNumber":"120"}"#
private let locationJSON = #"{"installationId":"550e8400-e29b-41d4-a716-446655440000","capturedAt":"2026-10-28T20:30:00Z","locationAgeSeconds":15.0,"horizontalAccuracyMeters":35.0,"cellScheme":"h3","h3Cell":614934489169608703,"h3Resolution":8,"county":"COC005","zone":"COZ040","fireZone":null,"countyLabel":null,"fireZoneLabel":null,"source":"foregroundLocationChange"}"#

private func decoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}

private func encoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = .sortedKeys
    return encoder
}

@Test func deviceV3PreferencesWireContract() throws {
    let decoded = try decoder().decode(DevicePreferencesV3Payload.self, from: Data(preferencesJSON.utf8))
    let missingToken = preferencesJSON.replacingOccurrences(of: #""apnsDeviceToken":null,"#, with: "")
    #expect(try decoder().decode(DevicePreferencesV3Payload.self, from: Data(missingToken.utf8)) == decoded)
    let data = try encoder().encode(decoded)
    let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
    let consent = try #require(object["consent"] as? [String: Any])
    #expect(object["consentRevision"] as? Int64 == 12)
    #expect(consent["isSubscribed"] as? Bool == false)
    #expect(consent["locationSharingEnabled"] as? Bool == false)
    #expect(object["apnsDeviceToken"] == nil)
    #expect(try decoder().decode(DevicePreferencesV3Payload.self, from: data) == decoded)
    for invalid in [
        preferencesJSON.replacingOccurrences(of: #""apnsDeviceToken":null"#, with: #""apnsDeviceToken":"   ""#),
        preferencesJSON.replacingOccurrences(of: #""consentRevision":12"#, with: #""consentRevision":0"#),
        preferencesJSON.replacingOccurrences(of: #""consentRevision":12"#, with: #""consentRevision":"12""#),
        preferencesJSON.replacingOccurrences(of: #""locationSharingEnabled":false,"#, with: ""),
        preferencesJSON.replacingOccurrences(of: #""locationAuthorization":"always""#, with: #""locationAuthorization":"invalid""#),
    ] {
        #expect(throws: (any Error).self) { try decoder().decode(DevicePreferencesV3Payload.self, from: Data(invalid.utf8)) }
    }
}

@Test func deviceV3LocationAndResponseWireContract() throws {
    let location = try decoder().decode(DeviceLocationSnapshotV3Payload.self, from: Data(locationJSON.utf8))
    let data = try encoder().encode(location)
    let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
    #expect(object["capturedAt"] as? String == "2026-10-28T20:30:00Z")
    #expect(object["consentRevision"] == nil && object["auth"] == nil && object["apnsDeviceToken"] == nil)
    #expect(try decoder().decode(DeviceLocationSnapshotV3Payload.self, from: data) == location)
    let invalid = locationJSON.replacingOccurrences(of: #""h3Resolution":8,"#, with: "")
    #expect(throws: (any Error).self) { try decoder().decode(DeviceLocationSnapshotV3Payload.self, from: Data(invalid.utf8)) }
    let response = #"{"status":"stale","acceptedConsentRevision":12,"receivedAt":"2026-10-28T20:30:02Z","serverOwnsMesoNotificationDelivery":false}"#
    let decoded = try decoder().decode(DevicePreferencesV3AcceptedResponse.self, from: Data(response.utf8))
    #expect(decoded.status == .stale && decoded.serverOwnsMesoNotificationDelivery == false)
    #expect(try decoder().decode(DevicePreferencesV3AcceptedResponse.self, from: encoder().encode(decoded)) == decoded)
}

@Test func deviceV3ValidationBoundaries() throws {
    let invalidPreferences = [
        preferencesJSON.replacingOccurrences(of: "550e8400-e29b-41d4-a716-446655440000", with: "invalid"),
        preferencesJSON.replacingOccurrences(of: #""apnsDeviceToken":null"#, with: #""apnsDeviceToken":"""#),
        preferencesJSON.replacingOccurrences(of: #""apnsEnvironment":"prod""#, with: #""apnsEnvironment":"other""#),
        preferencesJSON.replacingOccurrences(of: #""consentRevision":12"#, with: #""consentRevision":9223372036854775808"#),
    ]
    for json in invalidPreferences {
        #expect(throws: (any Error).self) { try decoder().decode(DevicePreferencesV3Payload.self, from: Data(json.utf8)) }
    }
    let invalidLocations = [
        locationJSON.replacingOccurrences(of: "550e8400-e29b-41d4-a716-446655440000", with: "invalid"),
        locationJSON.replacingOccurrences(of: #""cellScheme":"h3""#, with: #""cellScheme":"other""#),
        locationJSON.replacingOccurrences(of: #""h3Resolution":8"#, with: #""h3Resolution":16"#),
        locationJSON.replacingOccurrences(of: #""locationAgeSeconds":15.0"#, with: #""locationAgeSeconds":-1"#),
        locationJSON.replacingOccurrences(of: #""horizontalAccuracyMeters":35.0"#, with: #""horizontalAccuracyMeters":-1"#),
        locationJSON.replacingOccurrences(of: #""source":"foregroundLocationChange""#, with: #""source":"other""#),
    ]
    for json in invalidLocations {
        #expect(throws: (any Error).self) { try decoder().decode(DeviceLocationSnapshotV3Payload.self, from: Data(json.utf8)) }
    }
    let ugc = locationJSON.replacingOccurrences(of: #""cellScheme":"h3","h3Cell":614934489169608703,"h3Resolution":8,"#, with: #""cellScheme":"ugc-only","#)
    #expect(try decoder().decode(DeviceLocationSnapshotV3Payload.self, from: Data(ugc.utf8)).h3Cell == nil)
    let maximum = preferencesJSON.replacingOccurrences(of: #""consentRevision":12"#, with: #""consentRevision":9223372036854775807"#)
    #expect(try decoder().decode(DevicePreferencesV3Payload.self, from: Data(maximum.utf8)).consentRevision == Int64.max)
}

@Test func deviceV3ExactWireKeysAndRevisionBoundaries() throws {
    let preference = try decoder().decode(DevicePreferencesV3Payload.self, from: Data(preferencesJSON.utf8))
    let preferenceObject = try #require(JSONSerialization.jsonObject(with: encoder().encode(preference)) as? [String: Any])
    #expect(Set(preferenceObject.keys) == Set(["installationId", "consentRevision", "consent", "apnsEnvironment", "platform", "osVersion", "appVersion", "buildNumber"]))
    let consent = try #require(preferenceObject["consent"] as? [String: Any])
    #expect(Set(consent.keys) == Set(["isSubscribed", "mesoNotificationsEnabled", "locationSharingEnabled", "locationAuthorization"]))
    let location = try decoder().decode(DeviceLocationSnapshotV3Payload.self, from: Data(locationJSON.utf8))
    let locationObject = try #require(JSONSerialization.jsonObject(with: encoder().encode(location)) as? [String: Any])
    #expect(Set(locationObject.keys) == Set(["installationId", "capturedAt", "locationAgeSeconds", "horizontalAccuracyMeters", "cellScheme", "h3Cell", "h3Resolution", "county", "zone", "source"]))
    let response = try DevicePreferencesV3AcceptedResponse(status: .accepted, acceptedConsentRevision: 1, receivedAt: Date(timeIntervalSince1970: 0), serverOwnsMesoNotificationDelivery: false)
    let responseObject = try #require(JSONSerialization.jsonObject(with: encoder().encode(response)) as? [String: Any])
    #expect(Set(responseObject.keys) == Set(["status", "acceptedConsentRevision", "receivedAt", "serverOwnsMesoNotificationDelivery"]))
    #expect(responseObject["receivedAt"] as? String == "1970-01-01T00:00:00Z")
    #expect(throws: (any Error).self) { try DevicePreferencesV3AcceptedResponse(status: .accepted, acceptedConsentRevision: 0, receivedAt: .now, serverOwnsMesoNotificationDelivery: false) }
    for revision in ["1", "9223372036854775807"] {
        let json = preferencesJSON.replacingOccurrences(of: #""consentRevision":12"#, with: "\"consentRevision\":\(revision)")
        #expect(try decoder().decode(DevicePreferencesV3Payload.self, from: Data(json.utf8)).consentRevision == Int64(revision))
    }
    for revision in ["-1", "12.5"] {
        let json = preferencesJSON.replacingOccurrences(of: #""consentRevision":12"#, with: "\"consentRevision\":\(revision)")
        #expect(throws: (any Error).self) { try decoder().decode(DevicePreferencesV3Payload.self, from: Data(json.utf8)) }
    }
    let token = preferencesJSON.replacingOccurrences(of: #""apnsDeviceToken":null"#, with: #""apnsDeviceToken":"token""#).replacingOccurrences(of: #""apnsEnvironment":"prod""#, with: #""apnsEnvironment":"sandbox""#)
    let tokenPayload = try decoder().decode(DevicePreferencesV3Payload.self, from: Data(token.utf8))
    #expect(tokenPayload.apnsDeviceToken == "token" && tokenPayload.apnsEnvironment == .sandbox && tokenPayload.consent == preference.consent)
    for field in [#""isSubscribed":false,"#, #""mesoNotificationsEnabled":true,"#, #""locationSharingEnabled":false,"#, #", "locationAuthorization":"always""#] {
        let normalized = field.replacingOccurrences(of: ", ", with: ",")
        let json = preferencesJSON.replacingOccurrences(of: normalized, with: "")
        #expect(json != preferencesJSON)
        #expect(throws: (any Error).self) { try decoder().decode(DevicePreferencesV3Payload.self, from: Data(json.utf8)) }
    }
}

@Test func deviceV3ResponseRevisionBoundaries() throws {
    for value: Int64 in [1, Int64.max] {
        let response = try DevicePreferencesV3AcceptedResponse(status: .unchanged, acceptedConsentRevision: value, receivedAt: .init(timeIntervalSince1970: 0), serverOwnsMesoNotificationDelivery: true)
        #expect(try decoder().decode(DevicePreferencesV3AcceptedResponse.self, from: encoder().encode(response)) == response)
    }
    for value in ["-1", "9223372036854775808", "1.5"] {
        let json = "{\"status\":\"accepted\",\"acceptedConsentRevision\":\(value),\"receivedAt\":\"1970-01-01T00:00:00Z\",\"serverOwnsMesoNotificationDelivery\":false}"
        #expect(throws: (any Error).self) { try decoder().decode(DevicePreferencesV3AcceptedResponse.self, from: Data(json.utf8)) }
    }
}
