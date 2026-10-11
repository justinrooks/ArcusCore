# Changelog

Release notes for the [ArcusCore](https://github.com/justinrooks/ArcusCore) Swift package. Each version below links to its existing Git tag, with a comparison against the preceding tag. This is a record of shipped *contracts*, not a raw commit log.

## [0.5.0](https://github.com/justinrooks/ArcusCore/tree/0.5.0) ([changes since 0.4.4](https://github.com/justinrooks/ArcusCore/compare/0.4.4...0.5.0))

- **Mesoscale discussion contract:** Added `MesoscaleDiscussionPayload`, parsed threat/coordinate types, and a year-qualified product ID (`SPC-MD-<year>-<number>`) so annual SPC MD-number reuse cannot collide. Preserves probability values and source text.
- **Client preference:** Added optional `mesoNotificationsEnabled` to location snapshot and device preference sync payloads. Missing means unknown/legacy, `false` means opted out, and `true` means opted in; existing `isSubscribed` remains independent.
- **Server delivery ownership:** Added optional `serverOwnsMesoNotificationDelivery` to `DevicePreferenceSyncAcceptedResponse` so the server can explicitly acknowledge notification responsibility.
- **Typed remote pushes:** Extended `HotAlertAPNsPayload` with `RemoteWeatherProductKind` and a resource ID for NWS alerts or SPC mesoscale discussions. Retained `arcusAlertId`/`revisionSent` support for legacy alert payloads, while keeping CAP revision semantics out of meso payloads.
- Added Codable and compatibility tests for these shared contracts.
- **Rollout note:** Deploy server/app consumers with capability-aware handling. Existing alert push compatibility is preserved, but older app versions do not understand the new meso resource kind.
- Related issues: [#2](https://github.com/justinrooks/ArcusCore/issues/2), [#3](https://github.com/justinrooks/ArcusCore/issues/3), [#4](https://github.com/justinrooks/ArcusCore/issues/4), [#5](https://github.com/justinrooks/ArcusCore/issues/5).

## [0.4.4](https://github.com/justinrooks/ArcusCore/tree/0.4.4) ([changes since 0.4.3](https://github.com/justinrooks/ArcusCore/compare/0.4.3...0.4.4))

- Added `AirQualityCurrentResponse`, a shared air-quality response contract.

## [0.4.3](https://github.com/justinrooks/ArcusCore/tree/0.4.3) ([changes since 0.4.2](https://github.com/justinrooks/ArcusCore/compare/0.4.2...0.4.3))

- Restored backward-compatible decoding of legacy tornado viability enum representations in Storm Setup contracts, with regression tests.

## [0.4.2](https://github.com/justinrooks/ArcusCore/tree/0.4.2) ([changes since 0.4.1](https://github.com/justinrooks/ArcusCore/compare/0.4.1...0.4.2))

- Corrected custom coding-key behavior for tornado viability types and adjusted corresponding tests.

## [0.4.1](https://github.com/justinrooks/ArcusCore/tree/0.4.1) ([changes since 0.4.0](https://github.com/justinrooks/ArcusCore/compare/0.4.0...0.4.1))

- Removed server-specific details from the public Storm Setup models, narrowing ArcusCore to shared contracts; updated associated tests.

## [0.4.0](https://github.com/justinrooks/ArcusCore/tree/0.4.0) ([changes since 0.3.5](https://github.com/justinrooks/ArcusCore/compare/0.3.5...0.4.0))

- Added shared Storm Setup transport models, including current response, source data, tornado ingredients/raw parameters, and Anvil analysis profile response.
- Expanded DTO tests and contract coverage.

## [0.3.5](https://github.com/justinrooks/ArcusCore/tree/0.3.5) ([changes since 0.3.4](https://github.com/justinrooks/ArcusCore/compare/0.3.4...0.3.5))

- Added an upload-status value to `LocationUploadSource`.

## [0.3.4](https://github.com/justinrooks/ArcusCore/tree/0.3.4) ([changes since 0.3.3](https://github.com/justinrooks/ArcusCore/compare/0.3.3...0.3.4))

- Added `DevicePreferenceSyncAcceptedResponse` and updated the device preference sync contract.

## [0.3.3](https://github.com/justinrooks/ArcusCore/tree/0.3.3) ([changes since 0.3.2](https://github.com/justinrooks/ArcusCore/compare/0.3.2...0.3.3))

- Added shared `DevicePreferenceSyncPayload` for device notification preference updates.

## [0.3.2](https://github.com/justinrooks/ArcusCore/tree/0.3.2) ([changes since 0.3.1](https://github.com/justinrooks/ArcusCore/compare/0.3.1...0.3.2))

- Added `LocationUploadSource` as a shared source model for location uploads.

## [0.3.1](https://github.com/justinrooks/ArcusCore/tree/0.3.1) ([changes since 0.3.0](https://github.com/justinrooks/ArcusCore/compare/0.3.0...0.3.1))

- Refined `HotAlertAPNsPayload` alert identity field naming and associated tests.

## [0.3.0](https://github.com/justinrooks/ArcusCore/tree/0.3.0) ([changes since 0.2.0](https://github.com/justinrooks/ArcusCore/compare/0.2.0...0.3.0))

- Added `HotAlertAPNsPayload`, a shared contract for remote alert push metadata, with tests.

## [0.2.0](https://github.com/justinrooks/ArcusCore/tree/0.2.0) ([changes since 0.1.0](https://github.com/justinrooks/ArcusCore/compare/0.1.0...0.2.0))

- Added `LocationSnapshotPushPayload` for app-to-server location and device metadata uploads, with tests.

## [0.1.0](https://github.com/justinrooks/ArcusCore/tree/0.1.0)

- Initial ArcusCore shared `DeviceAlertPayload` contract, including alert metadata and GeoJSON-like polygon/multipolygon coordinates.

