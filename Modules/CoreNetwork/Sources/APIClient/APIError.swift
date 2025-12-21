import Foundation

/// API error types for network operations.
///
/// Generic and reusable across projects.
public enum APIError: Error, Equatable, Sendable {
    /// The URL could not be constructed.
    case invalidURL

    /// A network error occurred.
    case networkError(String)

    /// The response data could not be decoded.
    case decodingError(String)

    /// The server returned an HTTP error status code.
    case httpError(statusCode: Int)

    /// The request was cancelled.
    case cancelled

    /// No data was returned from the server.
    case noData
}

// MARK: - LocalizedError

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .cancelled:
            return "Request cancelled"
        case .noData:
            return "No data received"
        }
    }
}
