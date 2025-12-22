import Foundation
import Common

/// Use case for fetching game detail.
public final class GetGameDetailUseCase: Sendable {
    // MARK: - Dependencies

    private let repository: GamesRepositoryProtocol

    // MARK: - Init

    public init(repository: GamesRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Execute

    /// Fetches detailed information for a game.
    /// - Parameter input: The input with game ID.
    /// - Returns: Game detail entity.
    public func execute(_ input: GameDetailInput) async throws -> GameDetailEntity {
        try await repository.getGameDetail(input)
    }
}
