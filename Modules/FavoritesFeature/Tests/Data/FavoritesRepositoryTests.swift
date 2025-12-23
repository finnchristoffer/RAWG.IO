import XCTest
import Common
@testable import FavoritesFeature

/// Tests for FavoritesRepository.
@MainActor
final class FavoritesRepositoryTests: XCTestCase {
    // MARK: - Add Favorite

    func test_addFavorite_insertsViaDataSource() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        let sut = FavoritesRepository(localDataSource: dataSource)
        let game = makeGameEntity(id: 1, name: "Test Game")

        // Act
        try await sut.addFavorite(game)

        // Assert
        XCTAssertEqual(dataSource.insertedFavorites.count, 1)
        XCTAssertEqual(dataSource.insertedFavorites.first?.gameId, 1)
        XCTAssertEqual(dataSource.insertedFavorites.first?.name, "Test Game")
    }

    // MARK: - Remove Favorite

    func test_removeFavorite_deletesViaDataSource() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act
        try await sut.removeFavorite(gameId: 42)

        // Assert
        XCTAssertEqual(dataSource.deletedGameIds, [42])
    }

    // MARK: - Get All Favorites

    func test_getAllFavorites_mapsToEntities() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        dataSource.stubbedFavorites = [
            FavoriteGame(gameId: 1, name: "Game 1", slug: "game-1", rating: 4.0, ratingsCount: 100),
            FavoriteGame(gameId: 2, name: "Game 2", slug: "game-2", rating: 4.5, ratingsCount: 200)
        ]
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act
        let result = try await sut.getAllFavorites()

        // Assert
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[0].name, "Game 1")
        XCTAssertEqual(result[1].id, 2)
    }

    // MARK: - Is Favorite

    func test_isFavorite_returnsDataSourceResult() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        dataSource.stubbedExists = true
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act
        let result = try await sut.isFavorite(gameId: 5)

        // Assert
        XCTAssertTrue(result)
        XCTAssertEqual(dataSource.existsCheckedGameIds, [5])
    }

    // MARK: - Helpers

    private func makeGameEntity(id: Int, name: String = "Game") -> GameEntity {
        GameEntity(
            id: id,
            slug: "game-\(id)",
            name: name,
            released: nil,
            backgroundImage: URL(string: "https://example.com/image.jpg"),
            rating: 4.0,
            ratingsCount: 100,
            metacritic: 85,
            playtime: 0,
            platforms: [],
            genres: []
        )
    }
}

// MARK: - Mock LocalDataSource

final class MockLocalDataSource: FavoritesLocalDataSourceProtocol {
    var insertedFavorites: [FavoriteGame] = []
    var deletedGameIds: [Int] = []
    var stubbedFavorites: [FavoriteGame] = []
    var stubbedExists = false
    var existsCheckedGameIds: [Int] = []
    var stubbedError: Error?

    func insert(_ favorite: FavoriteGame) throws {
        if let error = stubbedError { throw error }
        insertedFavorites.append(favorite)
    }

    func delete(gameId: Int) throws {
        if let error = stubbedError { throw error }
        deletedGameIds.append(gameId)
    }

    func fetchAll() throws -> [FavoriteGame] {
        if let error = stubbedError { throw error }
        return stubbedFavorites
    }

    func exists(gameId: Int) throws -> Bool {
        if let error = stubbedError { throw error }
        existsCheckedGameIds.append(gameId)
        return stubbedExists
    }
}
