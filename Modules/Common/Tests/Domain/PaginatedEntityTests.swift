import XCTest
@testable import Common

/// Tests for PaginatedEntity.
final class PaginatedEntityTests: XCTestCase {
    // MARK: - Initialization

    func test_init_setsAllProperties() {
        // Arrange & Act
        let entity = PaginatedEntity(
            count: 100,
            hasNextPage: true,
            hasPreviousPage: false,
            results: ["A", "B", "C"]
        )

        // Assert
        XCTAssertEqual(
            entity.count,
            100,
            "Expected count to be 100, got \(entity.count)"
        )
        XCTAssertTrue(
            entity.hasNextPage,
            "Expected hasNextPage to be true"
        )
        XCTAssertFalse(
            entity.hasPreviousPage,
            "Expected hasPreviousPage to be false"
        )
        XCTAssertEqual(
            entity.results.count,
            3,
            "Expected 3 results, got \(entity.results.count)"
        )
    }

    func test_init_withEmptyResults() {
        // Arrange & Act
        let entity = PaginatedEntity<Int>(
            count: 0,
            hasNextPage: false,
            hasPreviousPage: false,
            results: []
        )

        // Assert
        XCTAssertEqual(
            entity.count,
            0,
            "Expected count to be 0"
        )
        XCTAssertTrue(
            entity.results.isEmpty,
            "Expected results to be empty"
        )
    }

    func test_init_withGameEntityResults() {
        // Arrange
        let games = [
            makeGameEntity(id: 1),
            makeGameEntity(id: 2)
        ]

        // Act
        let entity = PaginatedEntity(
            count: 50,
            hasNextPage: true,
            hasPreviousPage: true,
            results: games
        )

        // Assert
        XCTAssertEqual(
            entity.results.count,
            2,
            "Expected 2 game results"
        )
        XCTAssertEqual(
            entity.results[0].id,
            1,
            "Expected first game ID to be 1"
        )
        XCTAssertTrue(
            entity.hasPreviousPage,
            "Expected hasPreviousPage to be true for middle page"
        )
    }

    // MARK: - Edge Cases

    func test_init_countCanDifferFromResultsCount() {
        // Arrange & Act - total count is 100 but we only have 20 results (one page)
        let entity = PaginatedEntity(
            count: 100,
            hasNextPage: true,
            hasPreviousPage: false,
            results: Array(1...20)
        )

        // Assert
        XCTAssertEqual(
            entity.count,
            100,
            "Total count should be 100 (all pages)"
        )
        XCTAssertEqual(
            entity.results.count,
            20,
            "Results count should be 20 (current page)"
        )
    }

    // MARK: - Helpers

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
            playtime: 10,
            platforms: [],
            genres: []
        )
    }
}
