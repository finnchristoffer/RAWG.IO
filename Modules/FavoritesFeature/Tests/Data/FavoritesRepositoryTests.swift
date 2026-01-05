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
        XCTAssertEqual(
            dataSource.insertedFavorites.count,
            1,
            "Expected 1 favorite to be inserted"
        )
        XCTAssertEqual(
            dataSource.insertedFavorites.first?.gameId,
            1,
            "Expected inserted favorite gameId to be 1"
        )
        XCTAssertEqual(
            dataSource.insertedFavorites.first?.name,
            "Test Game",
            "Expected inserted favorite name to match"
        )
    }

    func test_addFavorite_mapsAllGameProperties() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        let sut = FavoritesRepository(localDataSource: dataSource)
        let game = makeGameEntity(id: 5, name: "Witcher", rating: 4.8, metacritic: 93)

        // Act
        try await sut.addFavorite(game)

        // Assert
        let inserted = dataSource.insertedFavorites.first
        XCTAssertEqual(
            inserted?.rating,
            4.8,
            "Expected rating to be mapped correctly"
        )
        XCTAssertEqual(
            inserted?.metacritic,
            93,
            "Expected metacritic to be mapped correctly"
        )
    }

    func test_addFavorite_throwsOnDataSourceError() async {
        // Arrange
        let dataSource = MockLocalDataSource()
        dataSource.stubbedError = NSError(domain: "test", code: 1)
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act & Assert
        do {
            try await sut.addFavorite(makeGameEntity(id: 1))
            XCTFail("Expected error to be thrown when data source fails")
        } catch {
            XCTAssertNotNil(
                error,
                "Expected error to be non-nil"
            )
        }
    }

    // MARK: - Remove Favorite

    func test_removeFavorite_deletesViaDataSource() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act
        try await sut.removeFavorite(gameId: 42)

        // Assert
        XCTAssertEqual(
            dataSource.deletedGameIds,
            [42],
            "Expected delete to be called with gameId 42"
        )
    }

    func test_removeFavorite_throwsOnDataSourceError() async {
        // Arrange
        let dataSource = MockLocalDataSource()
        dataSource.stubbedError = NSError(domain: "test", code: 1)
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act & Assert
        do {
            try await sut.removeFavorite(gameId: 1)
            XCTFail("Expected error to be thrown when data source fails")
        } catch {
            XCTAssertNotNil(
                error,
                "Expected error to be non-nil"
            )
        }
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
        XCTAssertEqual(
            result.count,
            2,
            "Expected 2 favorites to be returned"
        )
        XCTAssertEqual(
            result[0].id,
            1,
            "Expected first entity ID to be 1"
        )
        XCTAssertEqual(
            result[0].name,
            "Game 1",
            "Expected first entity name to match"
        )
    }

    func test_getAllFavorites_returnsEmptyArrayWhenNoFavorites() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        dataSource.stubbedFavorites = []
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act
        let result = try await sut.getAllFavorites()

        // Assert
        XCTAssertTrue(
            result.isEmpty,
            "Expected empty array when no favorites exist"
        )
    }

    func test_getAllFavorites_mapsBackgroundImageToURL() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        dataSource.stubbedFavorites = [
            FavoriteGame(
                gameId: 1,
                name: "Game",
                slug: "game",
                backgroundImage: "https://example.com/img.jpg",
                rating: 4.0,
                ratingsCount: 100
            )
        ]
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act
        let result = try await sut.getAllFavorites()

        // Assert
        XCTAssertEqual(
            result[0].backgroundImage?.absoluteString,
            "https://example.com/img.jpg",
            "Expected backgroundImage to be mapped to URL"
        )
    }

    // MARK: - Is Favorite

    func test_isFavorite_returnsTrueWhenExists() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        dataSource.stubbedExists = true
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act
        let result = try await sut.isFavorite(gameId: 5)

        // Assert
        XCTAssertTrue(
            result,
            "Expected isFavorite to return true when game exists"
        )
        XCTAssertEqual(
            dataSource.existsCheckedGameIds,
            [5],
            "Expected exists to be called with gameId 5"
        )
    }

    func test_isFavorite_returnsFalseWhenNotExists() async throws {
        // Arrange
        let dataSource = MockLocalDataSource()
        dataSource.stubbedExists = false
        let sut = FavoritesRepository(localDataSource: dataSource)

        // Act
        let result = try await sut.isFavorite(gameId: 999)

        // Assert
        XCTAssertFalse(
            result,
            "Expected isFavorite to return false when game doesn't exist"
        )
    }

    // MARK: - Helpers

    private func makeGameEntity(
        id: Int,
        name: String = "Game",
        rating: Double = 4.0,
        metacritic: Int? = 85
    ) -> GameEntity {
        GameEntity(
            id: id,
            slug: "game-\(id)",
            name: name,
            released: nil,
            backgroundImage: URL(string: "https://example.com/image.jpg"),
            rating: rating,
            ratingsCount: 100,
            metacritic: metacritic,
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
