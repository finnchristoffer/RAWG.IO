import Foundation

/// Use case for removing a game from favorites.
public final class RemoveFavoriteUseCase: Sendable {
    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    public func execute(gameId: Int) async throws {
        try await repository.removeFavorite(gameId: gameId)
    }
}
