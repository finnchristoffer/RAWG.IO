import XCTest
import Common
@testable import FavoritesFeature

/// Tests for FavoritesViewModel.
@MainActor
final class FavoritesViewModelTests: XCTestCase {
    // MARK: - Initial State

    func test_init_startsWithEmptyState() {
        // Arrange
        let (sut, _) = makeSUT()

        // Assert
        XCTAssertTrue(sut.favorites.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }

    // MARK: - Load Favorites

    func test_loadFavorites_populatesFavoritesOnSuccess() async {
        // Arrange
        let expectedGames = [makeGameEntity(id: 1), makeGameEntity(id: 2)]
        let (sut, repository) = makeSUT()
        repository.stubbedFavorites = expectedGames

        // Act
        await sut.loadFavorites()

        // Assert
        XCTAssertEqual(sut.favorites.count, 2)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadFavorites_setsErrorOnFailure() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedError = NSError(domain: "test", code: 1)

        // Act
        await sut.loadFavorites()

        // Assert
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.favorites.isEmpty)
    }

    // MARK: - Remove Favorite

    func test_removeFavorite_removesFromList() async {
        // Arrange
        let game = makeGameEntity(id: 1)
        let (sut, repository) = makeSUT()
        repository.stubbedFavorites = [game]
        await sut.loadFavorites()
        XCTAssertEqual(sut.favorites.count, 1)

        // Act
        await sut.removeFavorite(gameId: 1)

        // Assert
        XCTAssertTrue(sut.favorites.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: FavoritesViewModel, repository: MockFavoritesRepository) {
        let repository = MockFavoritesRepository()
        let getUseCase = GetFavoritesUseCase(repository: repository)
        let removeUseCase = RemoveFavoriteUseCase(repository: repository)
        let sut = FavoritesViewModel(
            getFavoritesUseCase: getUseCase,
            removeFavoriteUseCase: removeUseCase
        )
        return (sut, repository)
    }

    private func makeGameEntity(id: Int) -> GameEntity {
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

// MARK: - Mock

final class MockFavoritesRepository: FavoritesRepositoryProtocol, @unchecked Sendable {
    var stubbedFavorites: [GameEntity] = []
    var stubbedError: Error?
    var addedGames: [GameEntity] = []
    var removedGameIds: [Int] = []

    @MainActor
    func addFavorite(_ game: GameEntity) async throws {
        if let error = stubbedError { throw error }
        addedGames.append(game)
        stubbedFavorites.append(game)
    }

    @MainActor
    func removeFavorite(gameId: Int) async throws {
        if let error = stubbedError { throw error }
        removedGameIds.append(gameId)
        stubbedFavorites.removeAll { $0.id == gameId }
    }

    @MainActor
    func getAllFavorites() async throws -> [GameEntity] {
        if let error = stubbedError { throw error }
        return stubbedFavorites
    }

    @MainActor
    func isFavorite(gameId: Int) async throws -> Bool {
        if let error = stubbedError { throw error }
        return stubbedFavorites.contains { $0.id == gameId }
    }
}
