import Foundation
import CoreNetwork

// MARK: - API Requests
// These consume Input structs and convert to network format

/// API request for fetching games list.
struct GamesAPIRequest: APIRequest {
    typealias Response = PaginatedResponse<Game>

    private let input: GamesInput

    init(_ input: GamesInput) {
        self.input = input
    }

    var path: String { "/games" }
    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(input.page)),
            URLQueryItem(name: "page_size", value: String(input.pageSize))
        ]
        if !RAWGConfiguration.apiKey.isEmpty {
            items.insert(URLQueryItem(name: "key", value: RAWGConfiguration.apiKey), at: 0)
        }
        return items
    }
}

/// API request for fetching game details.
struct GameDetailAPIRequest: APIRequest {
    typealias Response = GameDetail

    private let input: GameDetailInput

    init(_ input: GameDetailInput) {
        self.input = input
    }

    var path: String { "/games/\(input.id)" }
    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] {
        guard !RAWGConfiguration.apiKey.isEmpty else { return [] }
        return [URLQueryItem(name: "key", value: RAWGConfiguration.apiKey)]
    }
}

/// API request for searching games.
struct SearchGamesAPIRequest: APIRequest {
    typealias Response = PaginatedResponse<Game>

    private let input: SearchGamesInput

    init(_ input: SearchGamesInput) {
        self.input = input
    }

    var path: String { "/games" }
    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "search", value: input.query),
            URLQueryItem(name: "page", value: String(input.page))
        ]
        if !RAWGConfiguration.apiKey.isEmpty {
            items.insert(URLQueryItem(name: "key", value: RAWGConfiguration.apiKey), at: 0)
        }
        return items
    }
}
