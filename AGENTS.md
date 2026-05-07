# AGENTS.md — ArcusCore Repository Guidance

## Purpose

ArcusCore is the small shared Swift package used by Project Arcus / SkyAware and Arcus-Signal.

This package exists to share stable contracts, pure value types, and tiny deterministic helpers across the app and server.

Keep it boring.

ArcusCore should reduce duplication and contract drift. It should not become a dumping ground for app logic, server logic, persistence models, UI behavior, or orchestration.

## Core Rule

ArcusCore shares language, not ownership.

Good shared code:
- describes data
- validates data
- encodes/decodes data
- represents cross-system concepts
- remains platform-neutral
- remains deterministic and testable

Bad shared code:
- fetches data
- stores data
- renders UI
- sends notifications
- talks to databases
- depends on app lifecycle
- depends on Vapor lifecycle
- depends on Apple platform frameworks

## Package Scope

Allowed:
- `Codable`, `Sendable`, `Equatable`, `Hashable` value types
- API request and response DTOs
- shared domain enums
- shared identifiers and lightweight wrappers
- small pure validation helpers
- simple date/window helpers when they are cross-system contract behavior
- protocol-free data contracts when possible
- Foundation-only types

Avoid:
- SwiftUI
- SwiftData
- Observation
- CoreLocation
- MapKit
- WeatherKit
- WidgetKit
- UserNotifications
- Vapor
- Fluent
- SQLKit
- PostgresNIO
- APNs clients
- database models
- repository types
- service/orchestration types
- dependency containers

If a type requires one of those frameworks, it probably does not belong in ArcusCore.

## Design Principles

- Prefer value types.
- Prefer explicit, boring names.
- Prefer immutability.
- Prefer small files with one primary type per file.
- Prefer stable public APIs over clever abstractions.
- Do not introduce inheritance.
- Do not introduce global mutable state.
- Do not introduce singletons.
- Do not introduce runtime environment detection.
- Do not add third-party dependencies unless explicitly approved.
- Do not add FoundationNetworking unless server-side tests or Linux support require it.

## Swift and Concurrency

- Use Swift 6+.
- Assume strict concurrency.
- Public shared types should be `Sendable` whenever practical.
- Public DTOs should usually be:
  - `public struct`
  - `Codable`
  - `Sendable`
  - `Equatable`
  - `Hashable` when identity or set membership matters
- Do not use `@MainActor`.
- Do not use actors unless there is a very strong reason. There usually is not.
- Avoid `@unchecked Sendable`. Fix the type instead.

## Contract Stability

ArcusCore types may be consumed by both app and server, so changes need extra care.

Before changing a public type:
1. Identify which repo consumes it.
2. Decide whether the change is additive or breaking.
3. Prefer additive changes for request/response models.
4. Preserve decoding compatibility when practical.
5. Add tests for encoding and decoding behavior.
6. Document intentional breaking changes in the PR.

For DTO evolution:
- Prefer adding optional properties over renaming existing properties.
- Prefer explicit custom `CodingKeys` when wire names matter.
- Do not casually change enum raw values.
- Do not expose implementation-specific names from either the app or server.

## Naming Guidance

Use names that describe shared domain meaning, not local implementation details.

Good:
- `DevicePresencePayload`
- `AlertRevisionReference`
- `WeatherRiskSummary`
- `H3CellID`
- `GeoCoordinate`
- `NotificationIntent`

Avoid:
- `SwiftDataAlertModel`
- `VaporAlertResponse`
- `AlertControllerPayload`
- `SummaryViewModelData`
- `PostgresAlertRecord`

## Migration Criteria

A type is a good ArcusCore candidate when:

- both Project Arcus and Arcus-Signal need the same shape
- it crosses the app/server API boundary
- duplicate definitions would create drift risk
- it is pure data or pure deterministic logic
- it does not depend on platform, persistence, transport, or UI concerns

A type is not a good candidate when:

- only one repo uses it
- it exists to satisfy a framework
- it owns lifecycle or orchestration
- it contains database behavior
- it contains UI behavior
- it requires network calls
- sharing it would force either repo to know too much about the other

When unsure, do not migrate yet. Duplication is cheaper than the wrong abstraction.

## Testing Expectations

Use Swift Testing unless the package already uses XCTest.

Tests should cover:
- JSON encoding and decoding
- enum raw values
- unknown/optional field behavior
- validation helpers
- date/window helpers
- equality/hash behavior for identifier types

Tests should be deterministic and should not hit live NWS, SPC, WeatherKit, APNs, or Arcus-Signal endpoints.

## Documentation Expectations

For each public type:
- Add concise documentation when the type crosses repo boundaries.
- Explain domain meaning, not obvious syntax.
- Mention wire-format expectations when relevant.
- Do not over-document trivial properties.

## Definition of Done

A change is done when:

- the package builds
- relevant tests pass or skipped validation is clearly stated
- public API changes are intentional
- app/server coupling has not increased
- no platform/server-only dependencies were introduced
- the change is small enough to review without archaeology gear

## Agent Behavior

- Keep changes minimal and reviewable.
- Do not broaden the package scope.
- Do not migrate code opportunistically while implementing unrelated work.
- If you discover a migration candidate, document it as a candidate unless the task explicitly asks for migration.
- Prefer one clean shared contract over a generalized abstraction.
- Challenge vague sharing proposals. Shared code is a commitment, not a convenience.