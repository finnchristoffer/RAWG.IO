import Foundation
import CoreNetwork

/// Updated repository protocol using Entities.
public protocol GamesRepositoryProtocol: Sendable {
    /// Fetches games list (cache-first).
    func getGames(_ input: GamesInput) async throws -> PaginatedEntity<GameEntity>

    /// Fetches game detail (cache-first).
    func getGameDetail(_ input: GameDetailInput) async throws -> GameDetailEntity

    /// Searches games (no cache).
    func searchGames(_ input: SearchGamesInput) async throws -> PaginatedEntity<GameEntity>
}
