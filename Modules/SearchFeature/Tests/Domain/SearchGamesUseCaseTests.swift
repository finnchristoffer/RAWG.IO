import XCTest
import Common
@testable import SearchFeature

/// Tests for SearchGamesUseCase.
final class SearchGamesUseCaseTests: XCTestCase {
    // MARK: - Success Cases

    func test_execute_returnsSearchResults() async throws {
        // Arrange
        let expectedGames = [makeGameEntity(id: 1), makeGameEntity(id: 2)]
        let repository = UseCaseMockSearchRepository()
        repository.stubbedSearchResult = makePaginatedResult(games: expectedGames)
        let sut = SearchGamesUseCase(repository: repository)
        let input = SearchGamesInput(query: "witcher", page: 1)

        // Act
        let result = try await sut.execute(input)

        // Assert
        XCTAssertEqual(
            result.results.count,
            2,
            "Expected 2 search results, got \(result.results.count)"
        )
        XCTAssertEqual(
            result.results[0].id,
            1,
            "Expected first result ID to be 1, got \(result.results[0].id)"
        )
    }

    func test_execute_passesCorrectInputToRepository() async throws {
        // Arrange
        let repository = UseCaseMockSearchRepository()
        repository.stubbedSearchResult = makePaginatedResult(games: [])
        let sut = SearchGamesUseCase(repository: repository)
        let input = SearchGamesInput(query: "zelda", page: 2)

        // Act
        _ = try await sut.execute(input)

        // Assert
        XCTAssertEqual(
            repository.capturedSearchInput?.query,
            "zelda",
            "Expected query 'zelda' to be passed to repository"
        )
        XCTAssertEqual(
            repository.capturedSearchInput?.page,
            2,
            "Expected page 2 to be passed to repository"
        )
    }

    func test_execute_returnsEmptyResultsForNoMatches() async throws {
        // Arrange
        let repository = UseCaseMockSearchRepository()
        repository.stubbedSearchResult = makePaginatedResult(games: [])
        let sut = SearchGamesUseCase(repository: repository)
        let input = SearchGamesInput(query: "nonexistent", page: 1)

        // Act
        let result = try await sut.execute(input)

        // Assert
        XCTAssertTrue(
            result.results.isEmpty,
            "Expected empty results for non-matching query"
        )
        XCTAssertEqual(
            result.count,
            0,
            "Expected count to be 0 for no matches"
        )
    }

    // MARK: - Pagination

    func test_execute_returnsPaginationInfo() async throws {
        // Arrange
        let repository = UseCaseMockSearchRepository()
        repository.stubbedSearchResult = PaginatedEntity(
            count: 100,
            hasNextPage: true,
            hasPreviousPage: false,
            results: [makeGameEntity()]
        )
        let sut = SearchGamesUseCase(repository: repository)

        // Act
        let result = try await sut.execute(SearchGamesInput(query: "test", page: 1))

        // Assert
        XCTAssertEqual(
            result.count,
            100,
            "Expected total count to be 100"
        )
        XCTAssertTrue(
            result.hasNextPage,
            "Expected hasNextPage to be true when more results exist"
        )
        XCTAssertFalse(
            result.hasPreviousPage,
            "Expected hasPreviousPage to be false on first page"
        )
    }

    // MARK: - Error Cases

    func test_execute_throwsOnRepositoryError() async {
        // Arrange
        let repository = UseCaseMockSearchRepository()
        repository.stubbedError = NSError(domain: "test", code: 500)
        let sut = SearchGamesUseCase(repository: repository)

        // Act & Assert
        do {
            _ = try await sut.execute(SearchGamesInput(query: "test", page: 1))
            XCTFail("Expected SearchGamesUseCase to throw error when repository fails")
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
            playtime: 10,
            platforms: [],
            genres: []
        )
    }

    private func makePaginatedResult(games: [GameEntity]) -> PaginatedEntity<GameEntity> {
        PaginatedEntity(
            count: games.count,
            hasNextPage: false,
            hasPreviousPage: false,
            results: games
        )
    }
}

// MARK: - Mock (UseCase-specific to avoid name collisions)

final class UseCaseMockSearchRepository: GamesRepositoryProtocol, @unchecked Sendable {
    var stubbedSearchResult: PaginatedEntity<GameEntity>?
    var stubbedError: Error?
    var capturedSearchInput: SearchGamesInput?

    // swiftlint:disable:next unavailable_function
    func getGames(_ input: GamesInput) async throws -> PaginatedEntity<GameEntity> {
        fatalError("Not used in search tests")
    }

    // swiftlint:disable:next unavailable_function
    func getGameDetail(_ input: GameDetailInput) async throws -> GameDetailEntity {
        fatalError("Not used in search tests")
    }

    func searchGames(_ input: SearchGamesInput) async throws -> PaginatedEntity<GameEntity> {
        capturedSearchInput = input
        if let error = stubbedError {
            throw error
        }
        return stubbedSearchResult ?? PaginatedEntity(
            count: 0, hasNextPage: false, hasPreviousPage: false, results: []
        )
    }
}
