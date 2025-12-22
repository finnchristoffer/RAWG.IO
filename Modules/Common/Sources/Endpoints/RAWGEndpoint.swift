import Foundation
import CoreNetwork

/// RAWG API configuration.
///
/// Contains base URL and API key configuration.
public enum RAWGConfiguration: Sendable {
    /// The base URL for RAWG API.
    // swiftlint:disable:next force_unwrapping
    public static let baseURL = URL(string: "https://api.rawg.io/api")!

    /// Default page size for paginated requests.
    public static let defaultPageSize = 20

    /// API key storage using thread-safe approach.
    /// Configure via `RAWGConfiguration.setAPIKey(_:)`
    private static let apiKeyStorage = APIKeyStorage()

    /// Get the current API key.
    public static var apiKey: String {
        apiKeyStorage.value
    }

    /// Set the API key (call once at app startup).
    ///
    /// Get your free API key at: https://rawg.io/apidocs
    /// - Parameter key: Your RAWG API key
    public static func setAPIKey(_ key: String) {
        apiKeyStorage.setValue(key)
    }
}

/// Thread-safe storage for API key.
private final class APIKeyStorage: @unchecked Sendable {
    private var _value: String = ""
    private let lock = NSLock()

    var value: String {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }

    func setValue(_ newValue: String) {
        lock.lock()
        defer { lock.unlock() }
        _value = newValue
    }
}

/// RAWG API endpoints.
///
/// ## Usage
/// ```swift
/// let endpoint = RAWGEndpoint.games(page: 1)
/// let url = endpoint.url
/// ```
public enum RAWGEndpoint: Endpoint, Sendable {
    /// List of games with optional pagination.
    case games(page: Int = 1, pageSize: Int = RAWGConfiguration.defaultPageSize)

    /// Detail for a specific game.
    case gameDetail(id: Int)

    /// Search for games.
    case searchGames(query: String, page: Int = 1)

    // MARK: - Endpoint

    public var baseURL: URL {
        RAWGConfiguration.baseURL
    }

    public var path: String {
        switch self {
        case .games:
            return "/games"
        case .gameDetail(let id):
            return "/games/\(id)"
        case .searchGames:
            return "/games"
        }
    }

    public var method: HTTPMethod {
        .get
    }

    public var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []

        // Add API key if configured
        if !RAWGConfiguration.apiKey.isEmpty {
            items.append(URLQueryItem(name: "key", value: RAWGConfiguration.apiKey))
        }

        switch self {
        case .games(let page, let pageSize):
            items.append(contentsOf: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "page_size", value: String(pageSize))
            ])
        case .gameDetail:
            break
        case .searchGames(let query, let page):
            items.append(contentsOf: [
                URLQueryItem(name: "search", value: query),
                URLQueryItem(name: "page", value: String(page))
            ])
        }

        return items
    }
}
