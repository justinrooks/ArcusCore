## 2026-05-26
- Repos scanned: `project-arcus` (SkyAware), `arcus-signal`, `ArcusCore`
- Commit window: `2026-05-19` through `2026-05-26` (last 7 days; no prior automation marker)
- High-risk areas inspected:
  - APNs hot-alert payload contract wiring and parsing (`arcusAlertId`/`revisionSent`)
  - Geometry-first targeting and UGC fallback behavior
  - Notification dispatch fallback for unsupported geometry
  - Targeted `/api/v2/alerts?id=<seriesUUID>` API contract
  - Location context freshness/state application in `LocationSession`
- Top recommended test:
  - `TargetEventRevisionJob` should enqueue/drain UGC notification fallback when H3 cover computation fails (`unsupportedGeometry`) and avoid H3 drain in that path.
- Watchlist:
  - `LocationSession.applyResolvedContext` refresh-key dedupe behavior appears under-tested for repeated context application and upload side effects.
- Implementation recommended: **Yes** (small, deterministic high-risk tests in app/server repos)

## 2026-06-02
- Repos scanned: `project-arcus` (SkyAware), `arcus-signal`, `ArcusCore`
- Commit window: `2026-05-26T15:00:38Z` through `2026-06-02`
- High-risk areas inspected:
  - SPC map batch staging, split convective/fire persistence, and all-clear rollback behavior
  - Expanded `LocationUploadSource` compatibility across shared DTOs, server validation, and DB constraints
  - Dedicated device preference sync endpoint coverage vs. location snapshot ingestion coverage
  - Mesoscale discussion payload compatibility and notification copy changes
- Top recommended test:
  - `arcus-signal` should accept a `POST /api/v1/devices/location-snapshots` payload using `source=backgroundLocationChange` and persist the presence row without violating the expanded source constraint.
- Watchlist:
  - `project-arcus` fire all-clear rollback path is structurally similar to the untested convective rollback path but has weaker direct evidence of breakage risk.
- Implementation recommended: **Yes** (small deterministic contract/integration tests only)

## 2026-06-09
- Repository reviewed: `ArcusCore`
- Commit window inspected: no commits found since `2026-06-02T15:07:36Z`; used current-default-branch high-risk inspection instead of scanning older history
- High-risk areas inspected:
  - Shared DTO contracts in `Sources/ArcusCore/DevicePreferenceSyncPayload.swift`
  - Shared DTO response contract in `Sources/ArcusCore/DevicePreferenceSyncAcceptedResponse.swift`
  - Shared enum wire compatibility in `Sources/ArcusCore/LocationUploadSource.swift`
  - Existing contract-test patterns in `Tests/ArcusCoreTests/ArcusCoreTests.swift`
- Files inspected:
  - `Sources/ArcusCore/DevicePreferenceSyncPayload.swift`
  - `Sources/ArcusCore/DevicePreferenceSyncAcceptedResponse.swift`
  - `Sources/ArcusCore/LocationUploadSource.swift`
  - `Tests/ArcusCoreTests/ArcusCoreTests.swift`
  - `Package.swift`
- Existing relevant tests found:
  - `deviceAlertPayloadDecodesPolygonWireFormat`
  - `deviceAlertPayloadEncodesMultiPolygonWireFormat`
  - `locationSnapshotPushPayloadDecodesWireFormat`
  - `locationSnapshotPushPayloadEncodesStableWireKeys`
  - `hotAlertAPNsPayloadDecodesCanonicalKey`
  - `hotAlertAPNsPayloadEncodesCanonicalKeys`
  - `hotAlertAPNsPayloadRoundTripPreservesCanonicalIdentifierAndRevisionSent`
- Top recommended test:
  - Add a focused raw-value round-trip test for `LocationUploadSource` that encodes/decodes every declared case, with explicit coverage for the new `unknown` case.
- Watchlist:
  - Add contract coverage for `DevicePreferenceSyncPayload` and `DevicePreferenceSyncAcceptedResponse` if either type is consumed across the app/server boundary with ISO-8601 dates or stable key expectations; evidence is present in the type declarations but no local usage was found in this repo.
- Implementation recommended: **Yes** for the enum contract test; **maybe** for the device preference sync DTOs pending local consumer evidence
- Out-of-scope repositories intentionally not scanned: none

## 2026-06-23
- Repository reviewed: `ArcusCore`
- Commit window inspected: no commits found since `2026-06-16T15:02:20.605Z`; used current-default-branch high-risk inspection instead of scanning older history
- High-risk areas inspected:
  - Shared DTO and enum contracts in `Sources/ArcusCore/DevicePreferenceSyncPayload.swift`, `Sources/ArcusCore/DevicePreferenceSyncAcceptedResponse.swift`, and `Sources/ArcusCore/LocationUploadSource.swift`
  - Shared wire contracts in `Sources/ArcusCore/LocationSnapshotPushPayload.swift`, `Sources/ArcusCore/HotAlertAPNsPayload.swift`, and `Sources/ArcusCore/DeviceAlertPayload.swift`
  - Existing contract tests in `Tests/ArcusCoreTests/ArcusCoreTests.swift`
- Files inspected:
  - `Sources/ArcusCore/DeviceAlertPayload.swift`
  - `Sources/ArcusCore/DevicePreferenceSyncAcceptedResponse.swift`
  - `Sources/ArcusCore/DevicePreferenceSyncPayload.swift`
  - `Sources/ArcusCore/HotAlertAPNsPayload.swift`
  - `Sources/ArcusCore/LocationSnapshotPushPayload.swift`
  - `Sources/ArcusCore/LocationUploadSource.swift`
  - `Tests/ArcusCoreTests/ArcusCoreTests.swift`
  - `Package.swift`
- Existing relevant tests found:
  - `deviceAlertPayloadDecodesPolygonWireFormat`
  - `deviceAlertPayloadEncodesMultiPolygonWireFormat`
  - `locationSnapshotPushPayloadDecodesWireFormat`
  - `locationSnapshotPushPayloadEncodesStableWireKeys`
  - `locationUploadSourceRoundTripsAllCasesThroughCodable`
  - `hotAlertAPNsPayloadDecodesCanonicalKey`
  - `hotAlertAPNsPayloadEncodesCanonicalKeys`
  - `hotAlertAPNsPayloadRoundTripPreservesCanonicalIdentifierAndRevisionSent`
- Top recommended test: none
- Watchlist:
  - `DevicePreferenceSyncPayload` and `DevicePreferenceSyncAcceptedResponse` still lack local wire-format contract tests in this repo; promote only if a documented local consumer or fixed wire example appears.
- Implementation recommended: **No**
- Out-of-scope repositories intentionally not scanned: `project-arcus`, `arcus-signal`

## 2026-06-30
- Repository reviewed: `ArcusCore`
- Commit window inspected: no commits found since `2026-06-23T15:01:25.799Z`; used current-default-branch high-risk inspection instead of scanning older history
- High-risk areas inspected:
  - Shared contract DTOs in `Sources/ArcusCore/DevicePreferenceSyncPayload.swift` and `Sources/ArcusCore/DevicePreferenceSyncAcceptedResponse.swift`
  - Existing wire-contract types and enum helpers in `Sources/ArcusCore/DeviceAlertPayload.swift`, `Sources/ArcusCore/LocationSnapshotPushPayload.swift`, `Sources/ArcusCore/HotAlertAPNsPayload.swift`, and `Sources/ArcusCore/LocationUploadSource.swift`
  - Existing contract tests in `Tests/ArcusCoreTests/ArcusCoreTests.swift`
- Files inspected:
  - `Sources/ArcusCore/DeviceAlertPayload.swift`
  - `Sources/ArcusCore/DevicePreferenceSyncAcceptedResponse.swift`
  - `Sources/ArcusCore/DevicePreferenceSyncPayload.swift`
  - `Sources/ArcusCore/HotAlertAPNsPayload.swift`
  - `Sources/ArcusCore/LocationSnapshotPushPayload.swift`
  - `Sources/ArcusCore/LocationUploadSource.swift`
  - `Tests/ArcusCoreTests/ArcusCoreTests.swift`
  - `Package.swift`
  - `README.md`
- Existing relevant tests found:
  - `deviceAlertPayloadDecodesPolygonWireFormat`
  - `deviceAlertPayloadEncodesMultiPolygonWireFormat`
  - `locationSnapshotPushPayloadDecodesWireFormat`
  - `locationSnapshotPushPayloadEncodesStableWireKeys`
  - `locationUploadSourceRoundTripsAllCasesThroughCodable`
  - `hotAlertAPNsPayloadDecodesCanonicalKey`
  - `hotAlertAPNsPayloadEncodesCanonicalKeys`
  - `hotAlertAPNsPayloadRoundTripPreservesCanonicalIdentifierAndRevisionSent`
- Top recommended test:
  - Add a focused Codable contract test for `DevicePreferenceSyncPayload` that round-trips the full payload and asserts the stable wire keys remain unchanged.
- Watchlist:
  - Add a contract test for `DevicePreferenceSyncAcceptedResponse` once the intended JSON date strategy is documented locally; current repo evidence does not pin the wire format.
- Implementation status: implemented
- Validation: `swift test` passed with 10 tests
- Out-of-scope repositories intentionally not scanned: none

## 2026-07-07
- Repository reviewed: `ArcusCore`
- Commit window inspected: no commits found since `2026-06-30T15:01:25.799Z`; used current-default-branch high-risk inspection instead of scanning older history
- High-risk areas inspected:
  - Shared contract DTOs in `Sources/ArcusCore/DevicePreferenceSyncPayload.swift` and `Sources/ArcusCore/DevicePreferenceSyncAcceptedResponse.swift`
  - Shared enum contract in `Sources/ArcusCore/LocationUploadSource.swift`
  - Existing contract tests in `Tests/ArcusCoreTests/ArcusCoreTests.swift`
- Files inspected:
  - `Sources/ArcusCore/DevicePreferenceSyncAcceptedResponse.swift`
  - `Sources/ArcusCore/DevicePreferenceSyncPayload.swift`
  - `Sources/ArcusCore/LocationUploadSource.swift`
  - `Tests/ArcusCoreTests/ArcusCoreTests.swift`
  - `Package.swift`
  - `docs/audits/weekly-test-gap-audit.md`
- Existing relevant tests found:
  - `deviceAlertPayloadDecodesPolygonWireFormat`
  - `deviceAlertPayloadEncodesMultiPolygonWireFormat`
  - `locationSnapshotPushPayloadDecodesWireFormat`
  - `locationSnapshotPushPayloadEncodesStableWireKeys`
  - `locationUploadSourceRoundTripsAllCasesThroughCodable`
  - `hotAlertAPNsPayloadDecodesCanonicalKey`
  - `hotAlertAPNsPayloadEncodesCanonicalKeys`
  - `hotAlertAPNsPayloadRoundTripPreservesCanonicalIdentifierAndRevisionSent`
- Recommended test gaps table:
  - Behavior: Codable contract coverage for `DevicePreferenceSyncPayload` stable wire keys and full round-trip
    Repo: `ArcusCore`
    Evidence: `Sources/ArcusCore/DevicePreferenceSyncPayload.swift:10-51` defines a public shared DTO with explicit `CodingKeys`, while `Tests/ArcusCoreTests/ArcusCoreTests.swift` has no coverage for this type; the repo already contains similar contract tests for `LocationSnapshotPushPayload`, `HotAlertAPNsPayload`, and `LocationUploadSource`.
    Risk reduced: Prevents silent app/server contract drift if a field is renamed, removed, or encoded under the wrong key.
    Test type: decoding/encoding
    Suggested test name: `devicePreferenceSyncPayloadRoundTripsStableWireKeys`
    Size: S
    Confidence: High
- Top recommended test:
  - Add `devicePreferenceSyncPayloadRoundTripsStableWireKeys` in `Tests/ArcusCoreTests/ArcusCoreTests.swift` first.
  - Why it matters: this is the only shared DTO in the current repo with explicit wire keys and no contract test, so it is the easiest place for accidental API drift to slip through.
  - Expected files touched: `Tests/ArcusCoreTests/ArcusCoreTests.swift`
  - Estimated churn: low, roughly 20-30 lines
  - Regression risk: low; the test is deterministic and mirrors the repo’s existing contract-test style
- Watchlist:
  - `DevicePreferenceSyncAcceptedResponse` still lacks a pinned local JSON date strategy or fixture, so a contract test would be guesswork until the wire format is documented in this repository.
  - `LocationUploadSource` is already covered by `locationUploadSourceRoundTripsAllCasesThroughCodable`; no further action needed unless new enum cases are added.
- Implementation status: implemented
- Validation: `swift test` passed with 10 tests
- Out-of-scope repositories intentionally not scanned: none
