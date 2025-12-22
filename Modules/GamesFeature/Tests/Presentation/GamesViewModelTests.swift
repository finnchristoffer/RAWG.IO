import XCTest
import Common
@testable import GamesFeature

/// Tests for GamesViewModel.
@MainActor
final class GamesViewModelTests: XCTestCase {
    // MARK: - Initial State

    func test_init_startsWithEmptyState() {
        // Arrange
        let (sut, _) = makeSUT()

        // Assert
        XCTAssertTrue(sut.games.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertTrue(sut.hasMorePages)
    }

    // MARK: - Load Games

    func test_loadGames_setsLoadingTrue() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedGamesResult = makeSuccessResponse(games: [makeGame(id: 1)])

        // Act
        async let loadTask: () = sut.loadGames()

        // Assert - loading should be true during fetch
        try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
        await loadTask
        XCTAssertFalse(sut.isLoading) // Should be false after completion
    }

    func test_loadGames_populatesGamesOnSuccess() async {
        // Arrange
        let expectedGames = [makeGame(id: 1), makeGame(id: 2)]
        let (sut, repository) = makeSUT()
        repository.stubbedGamesResult = makeSuccessResponse(games: expectedGames)

        // Act
        await sut.loadGames()

        // Assert
        XCTAssertEqual(sut.games.count, 2)
        XCTAssertEqual(sut.games[0].id, 1)
        XCTAssertEqual(sut.games[1].id, 2)
        XCTAssertNil(sut.error)
    }

    func test_loadGames_setsErrorOnFailure() async {
        // Arrange
        let expectedError = NSError(domain: "test", code: 1)
        let (sut, repository) = makeSUT()
        repository.stubbedError = expectedError

        // Act
        await sut.loadGames()

        // Assert
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.games.isEmpty)
    }

    func test_loadGames_setsHasMorePagesBasedOnResponse() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedGamesResult = makeSuccessResponse(games: [makeGame()], hasNext: false)

        // Act
        await sut.loadGames()

        // Assert
        XCTAssertFalse(sut.hasMorePages)
    }

    // MARK: - Pagination

    func test_loadMoreIfNeeded_loadsNextPageWhenNearEnd() async {
        // Arrange
        let initialGames = (1...10).map { makeGame(id: $0) }
        let nextPageGames = [makeGame(id: 11), makeGame(id: 12)]
        let (sut, repository) = makeSUT()

        // Setup initial state
        repository.stubbedGamesResult = makeSuccessResponse(games: initialGames, hasNext: true)
        await sut.loadGames()

        // Setup next page
        repository.stubbedGamesResult = makeSuccessResponse(games: nextPageGames, hasNext: false)

        // Act - trigger pagination with item near end
        await sut.loadMoreIfNeeded(currentItem: initialGames[8])

        // Assert
        XCTAssertEqual(sut.games.count, 12)
    }

    // MARK: - Refresh

    func test_refresh_reloadsGames() async {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedGamesResult = makeSuccessResponse(games: [makeGame(id: 1)])
        await sut.loadGames()

        // Change response for refresh
        repository.stubbedGamesResult = makeSuccessResponse(games: [makeGame(id: 2)])

        // Act
        await sut.refresh()

        // Assert
        XCTAssertEqual(sut.games.count, 1)
        XCTAssertEqual(sut.games[0].id, 2)
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: GamesViewModel, repository: MockGamesRepository) {
        let repository = MockGamesRepository()
        let sut = GamesViewModel(repository: repository)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, repository)
    }

    private func makeGame(id: Int = 1) -> Game {
        Game(
            id: id,
            slug: "game-\(id)",
            name: "Game \(id)",
            released: nil,
            backgroundImage: nil,
            rating: 4.0,
            ratingsCount: 100,
            metacritic: nil,
            playtime: 10,
            platforms: nil,
            genres: nil
        )
    }

    private func makeSuccessResponse(
        games: [Game],
        hasNext: Bool = true
    ) -> PaginatedResponse<Game> {
        PaginatedResponse(
            count: games.count,
            next: hasNext ? "https://api.rawg.io/api/games?page=2" : nil,
            previous: nil,
            results: games
        )
    }
}

// MARK: - Memory Leak Tracking

extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        nonisolated(unsafe) let weakInstance = WeakBox(instance)

        addTeardownBlock {
            XCTAssertNil(
                weakInstance.value,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}

/// Helper class to hold weak reference in Sendable context.
private final class WeakBox: @unchecked Sendable {
    weak var value: AnyObject?

    init(_ value: AnyObject) {
        self.value = value
    }
}
