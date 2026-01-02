import Foundation
import Common

/// Use case for fetching games list.
/// Internal - only for GamesFeature.
final class GetGamesUseCase: Sendable {
    private let repository: GamesRepositoryProtocol

    init(repository: GamesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ input: GamesInput) async throws -> PaginatedEntity<GameEntity> {
        try await repository.getGames(input)
    }
}
