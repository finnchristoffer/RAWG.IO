import Foundation

// MARK: - Favorites UseCases

/// UseCase protocol for adding a game to favorites.
public protocol AddFavoriteUseCaseProtocol: Sendable {
    @MainActor func execute(_ game: GameEntity) async throws
}

/// UseCase protocol for removing a game from favorites.
public protocol RemoveFavoriteUseCaseProtocol: Sendable {
    @MainActor func execute(gameId: Int) async throws
}

/// UseCase protocol for checking if a game is in favorites.
public protocol IsFavoriteUseCaseProtocol: Sendable {
    @MainActor func execute(gameId: Int) async throws -> Bool
}

/// UseCase protocol for getting all favorites.
public protocol GetFavoritesUseCaseProtocol: Sendable {
    @MainActor func execute() async throws -> [GameEntity]
}
