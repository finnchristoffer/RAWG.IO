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
        XCTAssertTrue(
            sut.favorites.isEmpty,
            "Expected favorites to be empty on init"
        )
        XCTAssertFalse(
            sut.isLoading,
            "Expected isLoading to be false on init"
        )
        XCTAssertNil(
            sut.error,
            "Expected error to be nil on init"
        )
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
        XCTAssertEqual(
            sut.favorites.count,
            2,
            "Expected 2 favorites after loading, got \(sut.favorites.count)"
        )
        XCTAssertNil(
            sut.error,
            "Expected error to be nil after successful load"
        )
        XCTAssertFalse(
            sut.isLoading,
            "Expected isLoading to be false after load completes"
        )
    }

    func test_loadFavorites_setsErrorOnFailure() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedError = NSError(domain: "test", code: 1)

        // Act
        await sut.loadFavorites()

        // Assert
        XCTAssertNotNil(
            sut.error,
            "Expected error to be set when load fails"
        )
        XCTAssertTrue(
            sut.favorites.isEmpty,
            "Expected favorites to remain empty on error"
        )
    }

    // MARK: - Remove Favorite

    func test_removeFavorite_removesFromList() async {
        // Arrange
        let game = makeGameEntity(id: 1)
        let (sut, repository) = makeSUT()
        repository.stubbedFavorites = [game]
        await sut.loadFavorites()
        XCTAssertEqual(
            sut.favorites.count,
            1,
            "Pre-condition: Expected 1 favorite before removal"
        )

        // Act
        await sut.removeFavorite(gameId: 1)

        // Assert
        XCTAssertTrue(
            sut.favorites.isEmpty,
            "Expected favorites to be empty after removing the only item"
        )
    }

    func test_removeFavorite_keepsOtherFavorites() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedFavorites = [
            makeGameEntity(id: 1),
            makeGameEntity(id: 2),
            makeGameEntity(id: 3)
        ]
        await sut.loadFavorites()

        // Act
        await sut.removeFavorite(gameId: 2)

        // Assert
        XCTAssertEqual(
            sut.favorites.count,
            2,
            "Expected 2 favorites remaining after removing 1"
        )
        XCTAssertTrue(
            sut.favorites.contains { $0.id == 1 },
            "Expected game 1 to still be in favorites"
        )
        XCTAssertTrue(
            sut.favorites.contains { $0.id == 3 },
            "Expected game 3 to still be in favorites"
        )
        XCTAssertFalse(
            sut.favorites.contains { $0.id == 2 },
            "Expected game 2 to be removed"
        )
    }

    func test_removeFavorite_setsErrorOnFailure() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedFavorites = [makeGameEntity(id: 1)]
        await sut.loadFavorites()
        repository.stubbedError = NSError(domain: "test", code: 1)

        // Act
        await sut.removeFavorite(gameId: 1)

        // Assert
        XCTAssertNotNil(
            sut.error,
            "Expected error to be set when remove fails"
        )
    }

    // MARK: - Loading State Tests

    func test_loadFavorites_setsLoadingToTrueDuringFetch() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedFavorites = []

        // Assert initial state
        XCTAssertFalse(sut.isLoading, "Expected isLoading to be false initially")

        // Act
        await sut.loadFavorites()

        // Assert final state
        XCTAssertFalse(sut.isLoading, "Expected isLoading to be false after completion")
    }

    func test_loadFavorites_clearsErrorBeforeLoading() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedError = NSError(domain: "test", code: 1)
        await sut.loadFavorites()
        XCTAssertNotNil(sut.error, "Pre-condition: error should be set")

        // Act - retry with success
        repository.stubbedError = nil
        repository.stubbedFavorites = [makeGameEntity(id: 1)]
        await sut.loadFavorites()

        // Assert
        XCTAssertNil(
            sut.error,
            "Expected error to be cleared after successful retry"
        )
    }

    // MARK: - Empty State Tests

    func test_loadFavorites_handlesEmptyArrayCorrectly() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedFavorites = []

        // Act
        await sut.loadFavorites()

        // Assert
        XCTAssertTrue(
            sut.favorites.isEmpty,
            "Expected favorites to be empty"
        )
        XCTAssertNil(
            sut.error,
            "Expected no error for empty favorites"
        )
    }

    // MARK: - Remove Non-Existent

    func test_removeFavorite_withNonExistentId_doesNotCrash() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedFavorites = [makeGameEntity(id: 1)]
        await sut.loadFavorites()

        // Act - remove ID that doesn't exist
        await sut.removeFavorite(gameId: 999)

        // Assert - should not crash, favorites unchanged
        XCTAssertEqual(
            sut.favorites.count,
            1,
            "Expected favorites count to remain 1"
        )
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
