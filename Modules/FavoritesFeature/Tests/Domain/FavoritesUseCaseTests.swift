import XCTest
import Common
@testable import FavoritesFeature

/// Tests for FavoritesFeature UseCases.
@MainActor
final class FavoritesUseCaseTests: XCTestCase {
    // MARK: - AddFavoriteUseCase

    func test_addFavoriteUseCase_callsRepository() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        let sut = AddFavoriteUseCase(repository: repository)
        let game = makeGameEntity(id: 1)

        // Act
        try await sut.execute(game)

        // Assert
        XCTAssertEqual(
            repository.addedGames.count,
            1,
            "Expected exactly 1 game to be added to repository, got \(repository.addedGames.count)"
        )
        XCTAssertEqual(
            repository.addedGames.first?.id,
            1,
            "Expected added game ID to be 1, got \(repository.addedGames.first?.id ?? -1)"
        )
    }

    func test_addFavoriteUseCase_throwsOnError() async {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedError = NSError(domain: "test", code: 1)
        let sut = AddFavoriteUseCase(repository: repository)

        // Act & Assert
        do {
            try await sut.execute(makeGameEntity())
            XCTFail("Expected AddFavoriteUseCase to throw error when repository fails")
        } catch {
            XCTAssertNotNil(
                error,
                "Expected error to be non-nil when repository throws"
            )
        }
    }

    func test_addFavoriteUseCase_addsMultipleGamesSequentially() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        let sut = AddFavoriteUseCase(repository: repository)

        // Act
        try await sut.execute(makeGameEntity(id: 1))
        try await sut.execute(makeGameEntity(id: 2))
        try await sut.execute(makeGameEntity(id: 3))

        // Assert
        XCTAssertEqual(
            repository.addedGames.count,
            3,
            "Expected 3 games to be added sequentially, got \(repository.addedGames.count)"
        )
    }

    // MARK: - RemoveFavoriteUseCase

    func test_removeFavoriteUseCase_callsRepository() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        let sut = RemoveFavoriteUseCase(repository: repository)

        // Act
        try await sut.execute(gameId: 42)

        // Assert
        XCTAssertEqual(
            repository.removedGameIds,
            [42],
            "Expected repository to receive removal request for game ID 42"
        )
    }

    func test_removeFavoriteUseCase_throwsOnError() async {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedError = NSError(domain: "test", code: 1)
        let sut = RemoveFavoriteUseCase(repository: repository)

        // Act & Assert
        do {
            try await sut.execute(gameId: 1)
            XCTFail("Expected RemoveFavoriteUseCase to throw error when repository fails")
        } catch {
            XCTAssertNotNil(
                error,
                "Expected error to be non-nil when repository throws"
            )
        }
    }

    // MARK: - GetFavoritesUseCase

    func test_getFavoritesUseCase_returnsFavorites() async throws {
        // Arrange
        let expectedGames = [makeGameEntity(id: 1), makeGameEntity(id: 2)]
        let repository = MockFavoritesRepository()
        repository.stubbedFavorites = expectedGames
        let sut = GetFavoritesUseCase(repository: repository)

        // Act
        let result = try await sut.execute()

        // Assert
        XCTAssertEqual(
            result.count,
            2,
            "Expected 2 favorites to be returned, got \(result.count)"
        )
        XCTAssertEqual(
            result[0].id,
            1,
            "Expected first favorite ID to be 1, got \(result[0].id)"
        )
        XCTAssertEqual(
            result[1].id,
            2,
            "Expected second favorite ID to be 2, got \(result[1].id)"
        )
    }

    func test_getFavoritesUseCase_returnsEmptyArrayWhenNoFavorites() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedFavorites = []
        let sut = GetFavoritesUseCase(repository: repository)

        // Act
        let result = try await sut.execute()

        // Assert
        XCTAssertTrue(
            result.isEmpty,
            "Expected empty array when no favorites exist, got \(result.count) items"
        )
    }

    func test_getFavoritesUseCase_throwsOnError() async {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedError = NSError(domain: "test", code: 1)
        let sut = GetFavoritesUseCase(repository: repository)

        // Act & Assert
        do {
            _ = try await sut.execute()
            XCTFail("Expected GetFavoritesUseCase to throw error when repository fails")
        } catch {
            XCTAssertNotNil(
                error,
                "Expected error to be non-nil when repository throws"
            )
        }
    }

    // MARK: - IsFavoriteUseCase

    func test_isFavoriteUseCase_returnsTrueWhenFavorited() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedFavorites = [makeGameEntity(id: 5)]
        let sut = IsFavoriteUseCase(repository: repository)

        // Act
        let result = try await sut.execute(gameId: 5)

        // Assert
        XCTAssertTrue(
            result,
            "Expected isFavorite to return true when game exists in favorites"
        )
    }

    func test_isFavoriteUseCase_returnsFalseWhenNotFavorited() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedFavorites = []
        let sut = IsFavoriteUseCase(repository: repository)

        // Act
        let result = try await sut.execute(gameId: 999)

        // Assert
        XCTAssertFalse(
            result,
            "Expected isFavorite to return false when game is not in favorites"
        )
    }

    func test_isFavoriteUseCase_returnsFalseForDifferentGameId() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedFavorites = [makeGameEntity(id: 1), makeGameEntity(id: 2)]
        let sut = IsFavoriteUseCase(repository: repository)

        // Act
        let result = try await sut.execute(gameId: 100)

        // Assert
        XCTAssertFalse(
            result,
            "Expected isFavorite to return false for game ID not in favorites list"
        )
    }

    func test_isFavoriteUseCase_throwsOnError() async {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedError = NSError(domain: "test", code: 1)
        let sut = IsFavoriteUseCase(repository: repository)

        // Act & Assert
        do {
            _ = try await sut.execute(gameId: 1)
            XCTFail("Expected IsFavoriteUseCase to throw error when repository fails")
        } catch {
            XCTAssertNotNil(
                error,
                "Expected error to be non-nil when repository throws"
            )
        }
    }

    // MARK: - Helpers

    private func makeGameEntity(id: Int = 1) -> GameEntity {
        GameEntity(
            id: id,
            slug: "game-\(id)",
            name: "Game \(id)",
            released: nil,
            backgroundImage: nil,
            rating: 4.0,
            ratingsCount: 100,
            metacritic: nil,
            playtime: 0,
            platforms: [],
            genres: []
        )
    }
}
