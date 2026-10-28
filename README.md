# ArcusCore
Common components shared between arcus-signal and project-arcus

## Publishing
After making changes and pushing to github tag the release with the next version by running these commands

```bash
git tag 0.1.0
git push origin 0.1.0
```

## Versioning
Guideline for versioning changes in this package
```bash
0.1.0  initial usable contract
0.1.1  bug fix / test fix / no contract change
0.2.0  additive shared type or additive property
0.3.0  another additive contract slice
1.0.0  once app + server both depend on it and contracts feel stable
```

## Release notes
See [CHANGELOG.md](CHANGELOG.md) for release notes linked to each Git tag, including a comparison with the previous version.

## Installation enrollment v2

`InstallationEnrollmentRequest` is the JSON body for `POST /v2/devices/enroll` (also available at `/api/v2/devices/enroll`) over HTTPS. `installationId` is a UUID string; `credential` is the base64url encoding of 32 cryptographically random bytes. The client persists the credential before enrollment and retries a lost response with the same UUID and credential. These DTOs describe the wire shape; the server must validate the UUID and credential format.

HTTP 200 with `InstallationEnrollmentAcceptedResponse` status `accepted` acknowledges a new installation, an eligible unclaimed legacy installation, or a same-credential retry. A malformed request returns 400 and a different credential for a claimed UUID returns 409. No credential is returned. Subsequent protected v2 writes use `Authorization: Bearer <credential>`; missing or invalid authorization returns 401. Enrollment does not require an APNs token or permission. Credentials must not be logged or embedded in other device payloads.

Adopt a reviewed ArcusCore revision in Signal #386 first, deploy the compatible server, then adopt it in SkyAware #796 before the client release. Consent ordering remains owned by Signal #379; v1 retirement requires separate approval.
