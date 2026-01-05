import XCTest
import Common
@testable import SearchFeature

/// Tests for SearchViewModel.
@MainActor
final class SearchViewModelTests: XCTestCase {
    // MARK: - Initial State

    func test_init_startsWithEmptyState() {
        // Arrange
        let (sut, _) = makeSUT()

        // Assert
        XCTAssertTrue(
            sut.games.isEmpty,
            "Expected games to be empty on init"
        )
        XCTAssertFalse(
            sut.isLoading,
            "Expected isLoading to be false on init"
        )
        XCTAssertNil(
            sut.error,
            "Expected error to be nil on init"
        )
        XCTAssertTrue(
            sut.searchQuery.isEmpty,
            "Expected searchQuery to be empty on init"
        )
    }

    // MARK: - Search

    func test_search_populatesGamesOnSuccess() async throws {
        // Arrange
        let expectedGames = [makeGameEntity(id: 1), makeGameEntity(id: 2)]
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = makeSuccessResponse(games: expectedGames)

        // Act - set query and wait for debounce
        sut.searchQuery = "witcher"
        try await Task.sleep(nanoseconds: 400_000_000) // 400ms > 300ms debounce

        // Assert
        XCTAssertEqual(
            sut.games.count,
            2,
            "Expected 2 games after successful search, got \(sut.games.count)"
        )
        XCTAssertNil(
            sut.error,
            "Expected error to be nil after successful search"
        )
    }

    func test_search_setsErrorOnFailure() async throws {
        // Arrange
        let expectedError = NSError(domain: "test", code: 1)
        let (sut, repository) = makeSUT()
        repository.stubbedError = expectedError

        // Act
        sut.searchQuery = "error"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Assert
        XCTAssertNotNil(
            sut.error,
            "Expected error to be set when search fails"
        )
        XCTAssertTrue(
            sut.games.isEmpty,
            "Expected games to remain empty on search error"
        )
    }

    func test_clearSearch_resetsState() async throws {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = makeSuccessResponse(games: [makeGameEntity()])
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Pre-condition
        XCTAssertFalse(
            sut.games.isEmpty,
            "Pre-condition: Expected games to be populated before clear"
        )

        // Act
        sut.clearSearch()

        // Assert
        XCTAssertTrue(
            sut.games.isEmpty,
            "Expected games to be empty after clearSearch"
        )
        XCTAssertTrue(
            sut.searchQuery.isEmpty,
            "Expected searchQuery to be empty after clearSearch"
        )
    }

    // MARK: - Empty Query Handling

    func test_search_withEmptyQuery_clearsResults() async throws {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = makeSuccessResponse(games: [makeGameEntity()])
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertFalse(sut.games.isEmpty, "Pre-condition: games should be populated")

        // Act - set empty query
        sut.searchQuery = ""
        try await Task.sleep(nanoseconds: 400_000_000)

        // Assert
        XCTAssertTrue(
            sut.games.isEmpty,
            "Expected games to be cleared when query is empty"
        )
    }

    func test_search_withWhitespaceQuery_clearsResults() async throws {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = makeSuccessResponse(games: [makeGameEntity()])

        // Act - set whitespace-only query
        sut.searchQuery = "   "
        try await Task.sleep(nanoseconds: 400_000_000)

        // Assert
        XCTAssertTrue(
            sut.games.isEmpty,
            "Expected games to be empty when query is whitespace only"
        )
    }

    // MARK: - Pagination State

    func test_hasMorePages_setsToTrueWhenNextPageExists() async throws {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = PaginatedEntity(
            count: 100,
            hasNextPage: true,
            hasPreviousPage: false,
            results: [makeGameEntity()]
        )

        // Act
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Assert
        XCTAssertTrue(
            sut.hasMorePages,
            "Expected hasMorePages to be true when next page exists"
        )
    }

    func test_hasMorePages_setsToFalseWhenNoMorePages() async throws {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = PaginatedEntity(
            count: 1,
            hasNextPage: false,
            hasPreviousPage: false,
            results: [makeGameEntity()]
        )

        // Act
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Assert
        XCTAssertFalse(
            sut.hasMorePages,
            "Expected hasMorePages to be false when no more pages"
        )
    }

    func test_clearSearch_resetsHasMorePages() async throws {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = PaginatedEntity(
            count: 100,
            hasNextPage: true,
            hasPreviousPage: false,
            results: [makeGameEntity()]
        )
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Act
        sut.clearSearch()

        // Assert
        XCTAssertTrue(
            sut.hasMorePages,
            "Expected hasMorePages to be reset to true after clear"
        )
    }

    // MARK: - loadMoreIfNeeded Tests

    func test_loadMoreIfNeeded_appendsNextPageResults() async throws {
        // Arrange
        let firstPageGames = [makeGameEntity(id: 1), makeGameEntity(id: 2)]
        let secondPageGames = [makeGameEntity(id: 3), makeGameEntity(id: 4)]
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = PaginatedEntity(
            count: 4,
            hasNextPage: true,
            hasPreviousPage: false,
            results: firstPageGames
        )

        // Load first page
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertEqual(sut.games.count, 2, "Pre-condition: first page loaded")

        // Setup second page response
        repository.stubbedSearchResult = PaginatedEntity(
            count: 4,
            hasNextPage: false,
            hasPreviousPage: true,
            results: secondPageGames
        )

        // Act - trigger load more with last item
        await sut.loadMoreIfNeeded(currentItem: firstPageGames[1])

        // Assert
        XCTAssertEqual(
            sut.games.count,
            4,
            "Expected 4 games after loading second page"
        )
    }

    func test_loadMoreIfNeeded_doesNotLoadWhenNotLastItem() async throws {
        // Arrange
        let games = [makeGameEntity(id: 1), makeGameEntity(id: 2)]
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = PaginatedEntity(
            count: 100,
            hasNextPage: true,
            hasPreviousPage: false,
            results: games
        )
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Act - trigger with first item (not last)
        await sut.loadMoreIfNeeded(currentItem: games[0])

        // Assert
        XCTAssertEqual(
            sut.games.count,
            2,
            "Expected games count to remain 2 (no loading when not last item)"
        )
    }

    func test_loadMoreIfNeeded_doesNotLoadWhenNoMorePages() async throws {
        // Arrange
        let games = [makeGameEntity(id: 1)]
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = PaginatedEntity(
            count: 1,
            hasNextPage: false,
            hasPreviousPage: false,
            results: games
        )
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Act - trigger with last item but no more pages
        await sut.loadMoreIfNeeded(currentItem: games[0])

        // Assert
        XCTAssertEqual(
            sut.games.count,
            1,
            "Expected games count to remain 1 (no loading when no more pages)"
        )
    }

    func test_loadMoreIfNeeded_updatesHasMorePagesAfterLoad() async throws {
        // Arrange
        let firstPageGames = [makeGameEntity(id: 1)]
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = PaginatedEntity(
            count: 2,
            hasNextPage: true,
            hasPreviousPage: false,
            results: firstPageGames
        )
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertTrue(sut.hasMorePages, "Pre-condition: hasMorePages should be true")

        // Setup second page (last page)
        repository.stubbedSearchResult = PaginatedEntity(
            count: 2,
            hasNextPage: false,
            hasPreviousPage: true,
            results: [makeGameEntity(id: 2)]
        )

        // Act
        await sut.loadMoreIfNeeded(currentItem: firstPageGames[0])

        // Assert
        XCTAssertFalse(
            sut.hasMorePages,
            "Expected hasMorePages to be false after loading last page"
        )
    }

    // MARK: - Debounce Tests

    func test_search_debouncesPreviousQueries() async throws {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = makeSuccessResponse(games: [makeGameEntity(id: 99)])

        // Act - rapid queries (only last should be executed)
        sut.searchQuery = "a"
        sut.searchQuery = "ab"
        sut.searchQuery = "abc"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Assert - should only have results from "abc" query
        XCTAssertEqual(
            sut.games.count,
            1,
            "Expected 1 game from debounced search"
        )
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: SearchViewModel, repository: MockSearchRepository) {
        let repository = MockSearchRepository()
        let useCase = SearchGamesUseCase(repository: repository)
        let sut = SearchViewModel(searchGamesUseCase: useCase)
        return (sut, repository)
    }

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
            playtime: 10,
            platforms: [],
            genres: []
        )
    }

    private func makeSuccessResponse(
        games: [GameEntity],
        hasNext: Bool = true
    ) -> PaginatedEntity<GameEntity> {
        PaginatedEntity(
            count: games.count,
            hasNextPage: hasNext,
            hasPreviousPage: false,
            results: games
        )
    }
}

// MARK: - Mock

final class MockSearchRepository: GamesRepositoryProtocol, @unchecked Sendable {
    var stubbedSearchResult: PaginatedEntity<GameEntity>?
    var stubbedError: Error?

    // swiftlint:disable:next unavailable_function
    func getGames(_ input: GamesInput) async throws -> PaginatedEntity<GameEntity> {
        fatalError("Not used in search tests")
    }

    // swiftlint:disable:next unavailable_function
    func getGameDetail(_ input: GameDetailInput) async throws -> GameDetailEntity {
        fatalError("Not used in search tests")
    }

    func searchGames(_ input: SearchGamesInput) async throws -> PaginatedEntity<GameEntity> {
        if let error = stubbedError {
            throw error
        }
        return stubbedSearchResult ?? PaginatedEntity(
            count: 0, hasNextPage: false, hasPreviousPage: false, results: []
        )
    }
}
