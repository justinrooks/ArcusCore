import Foundation
import Testing
@testable import ArcusCore

@Test func enrollmentRequestWireContract() throws {
    let json = #"{"installationId":"550e8400-e29b-41d4-a716-446655440000","credential":"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}"#
    let request = try JSONDecoder().decode(InstallationEnrollmentRequest.self, from: Data(json.utf8))
    #expect(request.installationId == "550e8400-e29b-41d4-a716-446655440000")
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    #expect(String(decoding: try encoder.encode(request), as: UTF8.self) == #"{"credential":"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA","installationId":"550e8400-e29b-41d4-a716-446655440000"}"#)
    #expect(try JSONDecoder().decode(InstallationEnrollmentRequest.self, from: encoder.encode(request)) == request)
}

@Test func enrollmentAcknowledgmentWireContract() throws {
    let response = InstallationEnrollmentAcceptedResponse(status: "accepted")
    let encoded = try JSONEncoder().encode(response)
    #expect(String(decoding: encoded, as: UTF8.self) == #"{"status":"accepted"}"#)
    #expect(try JSONDecoder().decode(InstallationEnrollmentAcceptedResponse.self, from: encoded) == response)
    // New installations, legacy claims, and same-secret retries share this response.
    #expect(try JSONDecoder().decode(InstallationEnrollmentAcceptedResponse.self, from: Data(#"{"status":"accepted"}"#.utf8)) == response)
}

@Test func enrollmentRejectsMissingOrWrongTypedFields() {
    let decoder = JSONDecoder()
    for json in [#"{}"#, #"{"installationId":"id"}"#, #"{"credential":"secret"}"#, #"{"installationId":1,"credential":"secret"}"#, #"{"installationId":"id","credential":null}"#] {
        #expect(throws: (any Error).self) { try decoder.decode(InstallationEnrollmentRequest.self, from: Data(json.utf8)) }
    }
    for json in [#"{}"#, #"{"status":null}"#] {
        #expect(throws: (any Error).self) { try decoder.decode(InstallationEnrollmentAcceptedResponse.self, from: Data(json.utf8)) }
    }
}

@Test func legacyDevicePayloadsKeepTheirWireKeys() throws {
    let preferences = #"{"installationId":"550e8400-e29b-41d4-a716-446655440000","apnsDeviceToken":"token","apnsEnvironment":"sandbox","platform":"iOS","osVersion":"26","appVersion":"1","buildNumber":"1","auth":"denied","isSubscribed":false,"source":"settings","reason":"change"}"#
    let location = #"{"capturedAt":0,"locationAgeSeconds":1,"horizontalAccuracyMeters":2,"cellScheme":"h3","apnsDeviceToken":"token","installationId":"550e8400-e29b-41d4-a716-446655440000","source":"unknown","auth":"denied","appVersion":"1","buildNumber":"1","platform":"iOS","osVersion":"26","apnsEnvironment":"sandbox"}"#
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let preferencePayload = try decoder.decode(DevicePreferenceSyncPayload.self, from: Data(preferences.utf8))
    let locationPayload = try decoder.decode(LocationSnapshotPushPayload.self, from: Data(location.utf8))
    for (original, encoded) in [(preferences, try encoder.encode(preferencePayload)), (location, try encoder.encode(locationPayload))] {
        let expected = try #require(JSONSerialization.jsonObject(with: Data(original.utf8)) as? [String: Any])
        let actual = try #require(JSONSerialization.jsonObject(with: encoded) as? [String: Any])
        #expect(Set(actual.keys) == Set(expected.keys))
        #expect(actual["credential"] == nil)
    }
}
