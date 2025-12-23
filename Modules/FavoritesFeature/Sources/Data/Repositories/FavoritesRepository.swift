import Foundation
import Common

/// Repository implementing favorites operations.
public final class FavoritesRepository: FavoritesRepositoryProtocol, @unchecked Sendable {
    private let localDataSource: FavoritesLocalDataSourceProtocol

    public init(localDataSource: FavoritesLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    @MainActor
    public func addFavorite(_ game: GameEntity) async throws {
        let favorite = FavoriteGame(
            gameId: game.id,
            name: game.name,
            slug: game.slug,
            backgroundImage: game.backgroundImage?.absoluteString,
            rating: game.rating,
            ratingsCount: game.ratingsCount,
            metacritic: game.metacritic
        )
        try localDataSource.insert(favorite)
    }

    @MainActor
    public func removeFavorite(gameId: Int) async throws {
        try localDataSource.delete(gameId: gameId)
    }

    @MainActor
    public func getAllFavorites() async throws -> [GameEntity] {
        let favorites = try localDataSource.fetchAll()
        return favorites.map { mapToEntity($0) }
    }

    @MainActor
    public func isFavorite(gameId: Int) async throws -> Bool {
        try localDataSource.exists(gameId: gameId)
    }

    // MARK: - Mapping

    private func mapToEntity(_ favorite: FavoriteGame) -> GameEntity {
        GameEntity(
            id: favorite.gameId,
            slug: favorite.slug,
            name: favorite.name,
            released: nil,
            backgroundImage: favorite.backgroundImage.flatMap { URL(string: $0) },
            rating: favorite.rating,
            ratingsCount: favorite.ratingsCount,
            metacritic: favorite.metacritic,
            playtime: 0,
            platforms: [],
            genres: []
        )
    }
}
