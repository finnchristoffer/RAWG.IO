import Foundation

/// Protocol defining a base API endpoint configuration.
///
/// Use this protocol to define base configurations for different APIs.
///
/// ## Usage
/// ```swift
/// enum RAWGEndpoint: Endpoint {
///     case games
///     case gameDetail(id: Int)
///
///     var baseURL: URL { URL(string: "https://api.rawg.io/api")! }
///     var path: String {
///         switch self {
///         case .games: return "/games"
///         case .gameDetail(let id): return "/games/\(id)"
///         }
///     }
/// }
/// ```
public protocol Endpoint: Sendable {
    /// The base URL for the API.
    var baseURL: URL { get }

    /// The path component of the endpoint.
    var path: String { get }

    /// The HTTP method for the endpoint.
    var method: HTTPMethod { get }

    /// Additional HTTP headers.
    var headers: [String: String] { get }

    /// Query parameters.
    var queryItems: [URLQueryItem] { get }
}

// MARK: - Default Implementation

public extension Endpoint {
    var method: HTTPMethod { .get }
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
}

// MARK: - URL Building

public extension Endpoint {
    /// Builds the full URL for this endpoint.
    var url: URL? {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path += path
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
}
