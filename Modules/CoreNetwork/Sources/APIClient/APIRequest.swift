import Foundation

/// Protocol defining requirements for API requests.
///
/// Generic and reusable across projects.
///
/// ## Usage
/// ```swift
/// struct GamesRequest: APIRequest {
///     typealias Response = GamesResponse
///     let path = "/games"
///     let method: HTTPMethod = .get
/// }
/// ```
public protocol APIRequest: Sendable {
    /// The response type expected from the API.
    associatedtype Response: Decodable & Sendable

    /// The path component of the URL (e.g., "/games").
    var path: String { get }

    /// The HTTP method for the request.
    var method: HTTPMethod { get }

    /// Additional HTTP headers.
    var headers: [String: String] { get }

    /// Query parameters for GET requests.
    var queryItems: [URLQueryItem] { get }

    /// The request body for POST/PUT/PATCH requests.
    var body: Data? { get }
}

// MARK: - Default Implementation

public extension APIRequest {
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
    var body: Data? { nil }
}
