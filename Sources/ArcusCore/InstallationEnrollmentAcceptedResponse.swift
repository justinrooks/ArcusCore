/// Acknowledgment of a new claim or an idempotent same-credential retry.
/// A successful enrollment returns the status `accepted`.
public struct InstallationEnrollmentAcceptedResponse: Sendable, Codable, Equatable {
    public let status: String

    public init(status: String) {
        self.status = status
    }
}
