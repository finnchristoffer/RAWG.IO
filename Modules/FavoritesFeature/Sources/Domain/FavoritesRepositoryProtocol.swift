import Foundation
import Common

/// Protocol for favorites repository.
public protocol FavoritesRepositoryProtocol: Sendable {
    /// Adds a game to favorites.
    @MainActor func addFavorite(_ game: GameEntity) async throws

    /// Removes a game from favorites.
    @MainActor func removeFavorite(gameId: Int) async throws

    /// Gets all favorite games.
    @MainActor func getAllFavorites() async throws -> [GameEntity]

    /// Checks if a game is in favorites.
    @MainActor func isFavorite(gameId: Int) async throws -> Bool
}
