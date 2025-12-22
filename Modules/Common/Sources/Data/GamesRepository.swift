import Foundation
import CoreNetwork

/// Implementation of GamesRepositoryProtocol using APIClient.
///
/// This is the infrastructure layer - implements the domain protocol.
public final class GamesRepository: GamesRepositoryProtocol, Sendable {
    // MARK: - Dependencies

    private let client: APIClient

    // MARK: - Init

    public init(client: APIClient) {
        self.client = client
    }

    // MARK: - GamesRepositoryProtocol

    public func getGames(_ input: GamesInput) async throws -> PaginatedResponse<Game> {
        try await client.send(GamesAPIRequest(input))
    }

    public func getGameDetail(_ input: GameDetailInput) async throws -> GameDetail {
        try await client.send(GameDetailAPIRequest(input))
    }

    public func searchGames(_ input: SearchGamesInput) async throws -> PaginatedResponse<Game> {
        try await client.send(SearchGamesAPIRequest(input))
    }
}
