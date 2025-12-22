import Foundation

// MARK: - Repository Protocols (Dependency Inversion)
// Domain layer defines these - implementation is in infrastructure

/// Protocol for games data operations.
///
/// Domain layer depends on this abstraction, not concrete implementations.
///
/// ## Usage
/// ```swift
/// class GamesViewModel {
///     private let repository: GamesRepositoryProtocol
///
///     func loadGames() async throws {
///         let input = GamesInput(page: 1)
///         let games = try await repository.getGames(input)
///     }
/// }
/// ```
public protocol GamesRepositoryProtocol: Sendable {
    /// Fetches a paginated list of games.
    func getGames(_ input: GamesInput) async throws -> PaginatedResponse<Game>

    /// Fetches details for a specific game.
    func getGameDetail(_ input: GameDetailInput) async throws -> GameDetail

    /// Searches for games matching a query.
    func searchGames(_ input: SearchGamesInput) async throws -> PaginatedResponse<Game>
}
