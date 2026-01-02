import Foundation
import Common

/// Use case for fetching game detail.
/// Internal - only accessible within GamesFeature module.
final class GetGameDetailUseCase: GetGameDetailUseCaseProtocol, Sendable {
    // MARK: - Dependencies

    private let repository: GamesRepositoryProtocol

    // MARK: - Init

    init(repository: GamesRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Execute

    /// Fetches detailed information for a game by ID.
    func execute(id: Int) async throws -> GameDetailEntity {
        let input = GameDetailInput(id: id)
        return try await repository.getGameDetail(input)
    }

    /// Fetches detailed information for a game.
    func execute(_ input: GameDetailInput) async throws -> GameDetailEntity {
        try await repository.getGameDetail(input)
    }
}
