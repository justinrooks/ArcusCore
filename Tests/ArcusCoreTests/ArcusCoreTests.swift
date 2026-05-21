import Foundation
import Testing
@testable import ArcusCore

@Test func deviceAlertPayloadDecodesPolygonWireFormat() throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let payload = try decoder.decode(DeviceAlertPayload.self, from: Data(polygonJSON.utf8))

    #expect(payload.event == "Tornado Watch")
    #expect(payload.currentRevisionUrn == "urn:rev:123")
    #expect(payload.h3Cells == [61773312345, 61773312346])
    #expect(payload.geometry == DeviceAlertGeometry.polygon(rings: [[
        DeviceAlertCoordinate(longitude: -104.99, latitude: 39.74),
        DeviceAlertCoordinate(longitude: -104.9, latitude: 39.8),
        DeviceAlertCoordinate(longitude: -104.99, latitude: 39.74),
    ]]))
}

@Test func deviceAlertPayloadEncodesMultiPolygonWireFormat() throws {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = [.sortedKeys]
    let date = Date(timeIntervalSince1970: 1_711_234_567)

    let payload = DeviceAlertPayload(
        id: UUID(uuidString: "88888888-8888-8888-8888-888888888888")!,
        event: "Severe Thunderstorm Warning",
        currentRevisionUrn: "urn:rev:999",
        currentRevisionSent: date,
        messageType: "Alert",
        state: "Active",
        created: date,
        updated: date,
        lastSeenActive: date,
        sent: date,
        effective: date,
        onset: nil,
        expires: date,
        ends: nil,
        severity: "Severe",
        urgency: "Immediate",
        certainty: "Likely",
        areaDesc: "Denver",
        senderName: "NWS Boulder",
        headline: "Warning",
        description: "Storms expected.",
        instructions: "Take cover.",
        response: "Shelter",
        ugc: ["COC031"],
        h3Cells: [61773312347],
        geometry: .multiPolygon(polygons: [[[
            DeviceAlertCoordinate(longitude: -105.0, latitude: 39.7),
            DeviceAlertCoordinate(longitude: -104.98, latitude: 39.72),
            DeviceAlertCoordinate(longitude: -105.0, latitude: 39.7),
        ]]]),
        tornadoDetection: nil,
        tornadoDamageThreat: nil,
        maxWindGust: "70 mph",
        maxHailSize: "1.25 in",
        windThreat: "Observed",
        hailThreat: "Radar Indicated",
        thunderstormDamageThreat: "Considerable",
        flashFloodDetection: nil,
        flashFloodDamageThreat: nil
    )

    let encoded = try encoder.encode(payload)
    let object = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]
    let geometry = object?["geometry"] as? [String: Any]
    let h3Cells = (object?["h3Cells"] as? [NSNumber])?.map(\.int64Value)

    #expect(object?["currentRevisionUrn"] as? String == "urn:rev:999")
    #expect(h3Cells == [61773312347])
    #expect(geometry?["type"] as? String == "MultiPolygon")
}

private let polygonJSON = """
{
  "id": "77777777-7777-7777-7777-777777777777",
  "event": "Tornado Watch",
  "currentRevisionUrn": "urn:rev:123",
  "currentRevisionSent": "2026-03-17T12:00:00Z",
  "messageType": "Alert",
  "state": "Active",
  "created": "2026-03-17T12:01:00Z",
  "updated": "2026-03-17T12:02:00Z",
  "lastSeenActive": "2026-03-17T12:03:00Z",
  "sent": "2026-03-17T12:00:00Z",
  "effective": "2026-03-17T12:00:00Z",
  "onset": null,
  "expires": "2026-03-17T18:00:00Z",
  "ends": null,
  "severity": "Severe",
  "urgency": "Immediate",
  "certainty": "Likely",
  "areaDesc": "Denver",
  "senderName": "NWS Boulder",
  "headline": "Watch",
  "description": "A watch is in effect.",
  "instructions": "Stay weather aware.",
  "response": "Monitor",
  "ugc": ["COC031", "COC059"],
  "h3Cells": [61773312345, 61773312346],
  "geometry": {
    "type": "Polygon",
    "coordinates": [
      [
        [-104.99, 39.74],
        [-104.9, 39.8],
        [-104.99, 39.74]
      ]
    ]
  },
  "tornadoDetection": "Radar Indicated",
  "tornadoDamageThreat": "Considerable",
  "maxWindGust": null,
  "maxHailSize": null,
  "windThreat": null,
  "hailThreat": null,
  "thunderstormDamageThreat": null,
  "flashFloodDetection": null,
  "flashFloodDamageThreat": null
}
"""

@Test func locationSnapshotPushPayloadDecodesWireFormat() throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let payload = try decoder.decode(LocationSnapshotPushPayload.self, from: Data(locationSnapshotJSON.utf8))

    #expect(payload.cellScheme == "h3")
    #expect(payload.county == "COC031")
    #expect(payload.zone == "COZ041")
    #expect(payload.installationId == "11111111-2222-3333-4444-555555555555")
    #expect(payload.isSubscribed == true)
}

@Test func locationSnapshotPushPayloadEncodesStableWireKeys() throws {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = [.sortedKeys]

    let payload = LocationSnapshotPushPayload(
        capturedAt: Date(timeIntervalSince1970: 1_714_000_000),
        locationAgeSeconds: 12.5,
        horizontalAccuracyMeters: 9.8,
        cellScheme: "h3",
        h3Cell: 61773312345,
        h3Resolution: 8,
        county: "COC031",
        zone: "COZ041",
        fireZone: "COZ241",
        apnsDeviceToken: "token",
        installationId: "11111111-2222-3333-4444-555555555555",
        source: "unknown",
        auth: "whenInUse",
        appVersion: "1.2.3",
        buildNumber: "456",
        platform: "iOS",
        osVersion: "26.0",
        apnsEnvironment: "sandbox",
        countyLabel: "Denver County",
        fireZoneLabel: "Front Range",
        isSubscribed: false
    )

    let encoded = try encoder.encode(payload)
    let object = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]

    #expect(object?["county"] as? String == "COC031")
    #expect(object?["zone"] as? String == "COZ041")
    #expect(object?["installationId"] as? String == "11111111-2222-3333-4444-555555555555")
    #expect(object?["countyCode"] == nil)
    #expect(object?["forecastZone"] == nil)
}

private let locationSnapshotJSON = """
{
  "capturedAt": "2026-03-17T12:00:00Z",
  "locationAgeSeconds": 18.5,
  "horizontalAccuracyMeters": 7.2,
  "cellScheme": "h3",
  "h3Cell": 61773312345,
  "h3Resolution": 8,
  "county": "COC031",
  "zone": "COZ041",
  "fireZone": "COZ241",
  "apnsDeviceToken": "abc123",
  "installationId": "11111111-2222-3333-4444-555555555555",
  "source": "unknown",
  "auth": "whenInUse",
  "appVersion": "1.2.3",
  "buildNumber": "456",
  "platform": "iOS",
  "osVersion": "26.0",
  "apnsEnvironment": "sandbox",
  "countyLabel": "Denver County",
  "fireZoneLabel": "Front Range",
  "isSubscribed": true
}
"""

@Test func hotAlertAPNsPayloadDecodesStableWireKeys() throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let payload = try decoder.decode(HotAlertAPNsPayload.self, from: Data(hotAlertPayloadJSON.utf8))

    #expect(payload.alertID == "11111111-2222-3333-4444-555555555555")
    #expect(payload.seriesId == "11111111-2222-3333-4444-555555555555")
    #expect(payload.revisionSent == ISO8601DateFormatter().date(from: "2026-05-20T12:34:56Z"))
    #expect(payload.resolvedAlertID == "11111111-2222-3333-4444-555555555555")
}

@Test func hotAlertAPNsPayloadEncodesStableWireKeys() throws {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = [.sortedKeys]

    let payload = HotAlertAPNsPayload(
        alertID: "11111111-2222-3333-4444-555555555555",
        seriesId: "11111111-2222-3333-4444-555555555555",
        revisionSent: Date(timeIntervalSince1970: 1_747_744_896)
    )

    let encoded = try encoder.encode(payload)
    let object = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]

    #expect(object?[HotAlertAPNsPayload.alertIDKey] as? String == "11111111-2222-3333-4444-555555555555")
    #expect(object?[HotAlertAPNsPayload.seriesIDKey] as? String == "11111111-2222-3333-4444-555555555555")
    #expect(object?[HotAlertAPNsPayload.revisionSentKey] as? String == "2025-05-20T12:41:36Z")
}

private let hotAlertPayloadJSON = """
{
  "alertID": "11111111-2222-3333-4444-555555555555",
  "seriesId": "11111111-2222-3333-4444-555555555555",
  "revisionSent": "2026-05-20T12:34:56Z"
}
"""
