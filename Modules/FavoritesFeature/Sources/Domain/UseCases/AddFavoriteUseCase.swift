import Foundation
import Common

/// Use case for adding a game to favorites.
public final class AddFavoriteUseCase: Sendable {
    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    public func execute(_ game: GameEntity) async throws {
        try await repository.addFavorite(game)
    }
}
