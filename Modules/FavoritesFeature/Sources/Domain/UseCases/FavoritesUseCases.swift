import Foundation
import Common

/// UseCase for adding a game to favorites.
/// Internal - only accessible within FavoritesFeature module.
final class AddFavoriteUseCase: AddFavoriteUseCaseProtocol, @unchecked Sendable {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    func execute(_ game: GameEntity) async throws {
        try await repository.addFavorite(game)
    }
}

/// UseCase for removing a game from favorites.
/// Internal - only accessible within FavoritesFeature module.
final class RemoveFavoriteUseCase: RemoveFavoriteUseCaseProtocol, @unchecked Sendable {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    func execute(gameId: Int) async throws {
        try await repository.removeFavorite(gameId: gameId)
    }
}

/// UseCase for checking if a game is in favorites.
/// Internal - only accessible within FavoritesFeature module.
final class IsFavoriteUseCase: IsFavoriteUseCaseProtocol, @unchecked Sendable {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    func execute(gameId: Int) async throws -> Bool {
        try await repository.isFavorite(gameId: gameId)
    }
}

/// UseCase for getting all favorites.
/// Internal - only accessible within FavoritesFeature module.
final class GetFavoritesUseCase: GetFavoritesUseCaseProtocol, @unchecked Sendable {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    func execute() async throws -> [GameEntity] {
        try await repository.getAllFavorites()
    }
}
