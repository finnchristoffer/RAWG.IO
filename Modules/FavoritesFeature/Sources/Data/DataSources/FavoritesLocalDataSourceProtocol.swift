import Foundation

/// Protocol for favorites local data source operations.
@MainActor
public protocol FavoritesLocalDataSourceProtocol {
    /// Inserts a favorite game.
    func insert(_ favorite: FavoriteGame) throws

    /// Deletes a favorite by game ID.
    func delete(gameId: Int) throws

    /// Fetches all favorites sorted by added date.
    func fetchAll() throws -> [FavoriteGame]

    /// Checks if a game is favorited.
    func exists(gameId: Int) throws -> Bool
}
