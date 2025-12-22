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
        XCTAssertTrue(sut.games.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertTrue(sut.searchQuery.isEmpty)
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
        XCTAssertEqual(sut.games.count, 2)
        XCTAssertNil(sut.error)
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
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.games.isEmpty)
    }

    func test_clearSearch_resetsState() async throws {
        // Arrange
        let (sut, repository) = makeSUT()
        repository.stubbedSearchResult = makeSuccessResponse(games: [makeGameEntity()])
        sut.searchQuery = "test"
        try await Task.sleep(nanoseconds: 400_000_000)

        // Pre-condition
        XCTAssertFalse(sut.games.isEmpty)

        // Act
        sut.clearSearch()

        // Assert
        XCTAssertTrue(sut.games.isEmpty)
        XCTAssertTrue(sut.searchQuery.isEmpty)
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
