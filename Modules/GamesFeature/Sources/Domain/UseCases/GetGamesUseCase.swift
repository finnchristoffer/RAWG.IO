import Foundation
import Common

/// Use case for fetching games list.
public final class GetGamesUseCase: Sendable {
    // MARK: - Dependencies

    private let repository: GamesRepositoryProtocol

    // MARK: - Init

    public init(repository: GamesRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Execute

    /// Fetches paginated games list.
    /// - Parameter input: The input with page and page size.
    /// - Returns: Paginated entity of games.
    public func execute(_ input: GamesInput) async throws -> PaginatedEntity<GameEntity> {
        try await repository.getGames(input)
    }
}
