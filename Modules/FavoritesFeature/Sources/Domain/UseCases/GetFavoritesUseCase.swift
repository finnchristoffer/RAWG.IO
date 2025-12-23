import Foundation
import Common

/// Use case for getting all favorite games.
public final class GetFavoritesUseCase: Sendable {
    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    @MainActor
    public func execute() async throws -> [GameEntity] {
        try await repository.getAllFavorites()
    }
}
