import Foundation

/// Use case for checking if a game is in favorites.
public final class IsFavoriteUseCase: Sendable {
    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    public func execute(gameId: Int) async throws -> Bool {
        try await repository.isFavorite(gameId: gameId)
    }
}
