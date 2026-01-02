import Foundation
import Common

/// Use case for searching games.
/// Internal - only for SearchFeature.
final class SearchGamesUseCase: Sendable {
    private let repository: GamesRepositoryProtocol

    init(repository: GamesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ input: SearchGamesInput) async throws -> PaginatedEntity<GameEntity> {
        try await repository.searchGames(input)
    }
}
