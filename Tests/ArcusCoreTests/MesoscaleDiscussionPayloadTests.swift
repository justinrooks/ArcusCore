import Foundation
import Testing
@testable import ArcusCore

@Test func mesoscaleDiscussionPayloadRoundTripsFullWireShape() throws {
    let fixture = """
    {
      "productID": "SPC-MD-2026-1234",
      "issueYear": 2026,
      "number": 1234,
      "title": "Severe thunderstorms possible",
      "sourceURL": "https://www.spc.noaa.gov/products/md/md1234.html",
      "issued": "2026-06-01T12:00:00Z",
      "validStart": "2026-06-01T12:10:00Z",
      "validEnd": "2026-06-01T14:00:00Z",
      "areasAffected": "Eastern Colorado",
      "summary": "Storms may intensify.",
      "concerning": "A watch may be needed.",
      "watchProbability": 40,
      "watchProbabilityText": "40%",
      "threats": {
        "peakWindMPH": 70,
        "hailRangeInches": 1.5,
        "tornadoStrength": "Brief / weak"
      },
      "coordinates": [
        { "latitude": 39.7, "longitude": -105.0 },
        { "latitude": 39.8, "longitude": -104.8 }
      ]
    }
    """
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let payload = try decoder.decode(MesoscaleDiscussionPayload.self, from: Data(fixture.utf8))
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let encoded = try encoder.encode(payload)
    let object = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]
    let threatObject = object?["threats"] as? [String: Any]
    let coordinates = object?["coordinates"] as? [[String: Double]]

    #expect(payload.issueYear == 2026)
    #expect(payload.id == "SPC-MD-2026-1234")
    #expect(payload.validStart.timeIntervalSince(payload.issued) == 600)
    #expect(payload.validEnd.timeIntervalSince(payload.validStart) == 6_600)
    #expect(payload.concerning == "A watch may be needed.")
    #expect(payload.watchProbability == 40)
    #expect(payload.watchProbabilityText == "40%")
    #expect(threatObject?["peakWindMPH"] as? Int == 70)
    #expect(threatObject?["hailRangeInches"] as? Double == 1.5)
    #expect(threatObject?["tornadoStrength"] as? String == "Brief / weak")
    #expect(coordinates?.first?["latitude"] == 39.7)
    #expect(coordinates?.first?["longitude"] == -105.0)
    #expect(coordinates?.last?["longitude"] == -104.8)
    #expect(object?["sourceURL"] as? String == "https://www.spc.noaa.gov/products/md/md1234.html")
    #expect(object?["productID"] as? String == "SPC-MD-2026-1234")
    #expect(object?["watchProbabilityText"] as? String == "40%")
    #expect(object?["link"] == nil)
}

@Test func mesoscaleDiscussionPayloadDecodesSparseAndOptionalFields() throws {
    let json = """
    {
      "number": 1234,
      "title": "Mesoscale Discussion 1234",
      "link": "https://www.spc.noaa.gov/products/md/md1234.html",
      "issued": 1735689600,
      "validStart": 1735690200,
      "validEnd": 1735696800,
      "areasAffected": "Central Plains",
      "summary": "Elevated storms possible.",
      "watchProbability": 35.5,
      "coordinates": []
    }
    """
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let payload = try decoder.decode(MesoscaleDiscussionPayload.self, from: Data(json.utf8))

    #expect(payload.issueYear == 2025)
    #expect(payload.number == 1234)
    #expect(payload.id == "SPC-MD-2025-1234")
    #expect(payload.sourceURL.absoluteString == "https://www.spc.noaa.gov/products/md/md1234.html")
    #expect(payload.concerning == nil)
    #expect(payload.watchProbability == 35.5)
    #expect(payload.watchProbabilityText == "35.5")
    #expect(payload.threats == nil)
    #expect(payload.coordinates.isEmpty)
}

@Test func mesoscaleDiscussionPayloadIdentityDistinguishesReusedNumbers() {
    let current = makeMesoPayloadForYear(2026)
    let previous = makeMesoPayloadForYear(2025)

    #expect(current.id != previous.id)
    #expect(current != previous)
}

@Test func mesoscaleDiscussionPayloadRejectsMismatchedProductIdentity() {
    let json = """
    {
      "productID": "SPC-MD-1234",
      "issueYear": 2026,
      "number": 1234,
      "title": "Mesoscale Discussion 1234",
      "sourceURL": "https://www.spc.noaa.gov/products/md/md1234.html",
      "issued": 1780315200,
      "validStart": 1780315800,
      "validEnd": 1780322400,
      "areasAffected": "Central Plains",
      "summary": "Elevated storms possible.",
      "watchProbabilityText": "Unknown",
      "coordinates": []
    }
    """
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970

    do {
        _ = try decoder.decode(MesoscaleDiscussionPayload.self, from: Data(json.utf8))
        Issue.record("Expected a mismatched productID to fail decoding")
    } catch DecodingError.dataCorrupted(let context) {
        #expect(context.codingPath.last?.stringValue == "productID")
    } catch {
        Issue.record("Expected productID validation error, got: \(error)")
    }
}

@Test func mesoscaleDiscussionPayloadRejectsMismatchedIssueYear() {
    let json = """
    {
      "issueYear": 2025,
      "number": 1234,
      "title": "Mesoscale Discussion 1234",
      "sourceURL": "https://www.spc.noaa.gov/products/md/md1234.html",
      "issued": "2026-06-01T12:00:00Z",
      "validStart": "2026-06-01T12:10:00Z",
      "validEnd": "2026-06-01T14:00:00Z",
      "areasAffected": "Central Plains",
      "summary": "Elevated storms possible.",
      "watchProbabilityText": "Unknown",
      "coordinates": []
    }
    """
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    #expect(throws: DecodingError.self) {
        try decoder.decode(MesoscaleDiscussionPayload.self, from: Data(json.utf8))
    }
}

@Test func mesoscaleDiscussionPayloadNormalizesWatchProbabilityTextOnConstruction() throws {
    let padded = makeMesoPayload(watchProbabilityText: "  35%  ")
    let blank = makeMesoPayload(watchProbability: 35.5, watchProbabilityText: "   ")
    let decoded = try JSONDecoder().decode(MesoscaleDiscussionPayload.self, from: JSONEncoder().encode(blank))

    #expect(padded.watchProbabilityText == "35%")
    #expect(blank.watchProbabilityText == "35.5")
    #expect(decoded == blank)
}

private func makeMesoPayload(
    watchProbability: Double? = 35,
    watchProbabilityText: String = "Unknown"
) -> MesoscaleDiscussionPayload {
    let issued = Date(timeIntervalSince1970: 1_767_225_600)
    return MesoscaleDiscussionPayload(
        number: 1234,
        title: "Mesoscale Discussion 1234",
        sourceURL: URL(string: "https://www.spc.noaa.gov/products/md/md1234.html")!,
        issued: issued,
        validStart: issued.addingTimeInterval(600),
        validEnd: issued.addingTimeInterval(7_200),
        areasAffected: "Central Plains",
        summary: "Elevated storms possible.",
        concerning: nil,
        watchProbability: watchProbability,
        watchProbabilityText: watchProbabilityText,
        threats: nil,
        coordinates: []
    )
}

private func makeMesoPayloadForYear(_ issueYear: Int) -> MesoscaleDiscussionPayload {
    let issued = Date(timeIntervalSince1970: issueYear == 2025 ? 1_735_689_600 : 1_767_225_600)
    return MesoscaleDiscussionPayload(number: 1234, title: "Mesoscale Discussion 1234",
        sourceURL: URL(string: "https://www.spc.noaa.gov/products/md/md1234.html")!, issued: issued,
        validStart: issued.addingTimeInterval(600), validEnd: issued.addingTimeInterval(7_200),
        areasAffected: "Central Plains", summary: "Elevated storms possible.", concerning: nil,
        watchProbability: nil, watchProbabilityText: "Unknown", threats: nil, coordinates: [])
}
