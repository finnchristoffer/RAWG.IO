import Foundation
import CoreNetwork

/// Protocol for remote games data source.
public protocol GamesRemoteDataSourceProtocol: Sendable {
    /// Fetches games list from API.
    func fetchGames(_ input: GamesInput) async throws -> PaginatedResponseDTO<GameDTO>

    /// Fetches game detail from API.
    func fetchGameDetail(_ input: GameDetailInput) async throws -> GameDetailDTO

    /// Searches games from API.
    func searchGames(_ input: SearchGamesInput) async throws -> PaginatedResponseDTO<GameDTO>
}

/// Remote data source for games API.
public final class GamesRemoteDataSource: GamesRemoteDataSourceProtocol, @unchecked Sendable {
    // MARK: - Dependencies

    private let client: APIClient

    // MARK: - Init

    public init(client: APIClient) {
        self.client = client
    }

    // MARK: - GamesRemoteDataSourceProtocol

    public func fetchGames(_ input: GamesInput) async throws -> PaginatedResponseDTO<GameDTO> {
        try await client.send(GamesAPIRequest(input))
    }

    public func fetchGameDetail(_ input: GameDetailInput) async throws -> GameDetailDTO {
        try await client.send(GameDetailAPIRequest(input))
    }

    public func searchGames(_ input: SearchGamesInput) async throws -> PaginatedResponseDTO<GameDTO> {
        try await client.send(SearchGamesAPIRequest(input))
    }
}

// MARK: - API Requests (Internal)

private struct GamesAPIRequest: APIRequest {
    typealias Response = PaginatedResponseDTO<GameDTO>

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

private struct GameDetailAPIRequest: APIRequest {
    typealias Response = GameDetailDTO

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

private struct SearchGamesAPIRequest: APIRequest {
    typealias Response = PaginatedResponseDTO<GameDTO>

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
