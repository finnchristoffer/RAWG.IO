import Foundation
import Common

/// Use case for searching games.
public final class SearchGamesUseCase: Sendable {
    // MARK: - Dependencies

    private let repository: GamesRepositoryProtocol

    // MARK: - Init

    public init(repository: GamesRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Execute

    /// Searches games by query.
    /// - Parameter input: The search input with query and page.
    /// - Returns: Paginated entity of games matching the search.
    public func execute(_ input: SearchGamesInput) async throws -> PaginatedEntity<GameEntity> {
        try await repository.searchGames(input)
    }
}
