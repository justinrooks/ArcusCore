/// Request to bind an installation UUID to a client-generated credential.
/// The credential is base64url-encoded 32 cryptographically random bytes.
/// Persist it before enrollment and reuse it for retries; never log it.
public struct InstallationEnrollmentRequest: Sendable, Codable, Equatable {
    public let installationId: String
    public let credential: String

    public init(installationId: String, credential: String) {
        self.installationId = installationId
        self.credential = credential
    }
}
