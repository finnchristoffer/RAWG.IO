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
        XCTAssertEqual(repository.addedGames.count, 1)
        XCTAssertEqual(repository.addedGames.first?.id, 1)
    }

    func test_addFavoriteUseCase_throwsOnError() async {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedError = NSError(domain: "test", code: 1)
        let sut = AddFavoriteUseCase(repository: repository)

        // Act & Assert
        do {
            try await sut.execute(makeGameEntity())
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - RemoveFavoriteUseCase

    func test_removeFavoriteUseCase_callsRepository() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        let sut = RemoveFavoriteUseCase(repository: repository)

        // Act
        try await sut.execute(gameId: 42)

        // Assert
        XCTAssertEqual(repository.removedGameIds, [42])
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
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, 1)
        XCTAssertEqual(result[1].id, 2)
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
        XCTAssertTrue(result)
    }

    func test_isFavoriteUseCase_returnsFalseWhenNotFavorited() async throws {
        // Arrange
        let repository = MockFavoritesRepository()
        repository.stubbedFavorites = []
        let sut = IsFavoriteUseCase(repository: repository)

        // Act
        let result = try await sut.execute(gameId: 999)

        // Assert
        XCTAssertFalse(result)
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
