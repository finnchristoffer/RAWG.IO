import XCTest
@testable import Common

/// Tests for RAWGEndpoint.
final class RAWGEndpointTests: XCTestCase {
    // MARK: - Games Endpoint

    func test_games_endpoint_has_correct_path() {
        // Arrange
        let sut = RAWGEndpoint.games()

        // Act/Assert
        XCTAssertEqual(sut.path, "/games")
    }

    func test_games_endpoint_includes_pagination_query() {
        // Arrange
        let sut = RAWGEndpoint.games(page: 2, pageSize: 10)

        // Act
        let items = sut.queryItems

        // Assert
        XCTAssertTrue(items.contains { $0.name == "page" && $0.value == "2" })
        XCTAssertTrue(items.contains { $0.name == "page_size" && $0.value == "10" })
    }

    // MARK: - Game Detail Endpoint

    func test_gameDetail_endpoint_has_correct_path() {
        // Arrange
        let sut = RAWGEndpoint.gameDetail(id: 123)

        // Act/Assert
        XCTAssertEqual(sut.path, "/games/123")
    }

    // MARK: - Search Endpoint

    func test_searchGames_endpoint_has_correct_path() {
        // Arrange
        let sut = RAWGEndpoint.searchGames(query: "zelda")

        // Act/Assert
        XCTAssertEqual(sut.path, "/games")
    }

    func test_searchGames_endpoint_includes_search_query() {
        // Arrange
        let sut = RAWGEndpoint.searchGames(query: "zelda", page: 3)

        // Act
        let items = sut.queryItems

        // Assert
        XCTAssertTrue(items.contains { $0.name == "search" && $0.value == "zelda" })
        XCTAssertTrue(items.contains { $0.name == "page" && $0.value == "3" })
    }

    // MARK: - API Key

    func test_endpoint_includes_api_key_when_configured() {
        // Arrange
        RAWGConfiguration.setAPIKey("test_key")
        let sut = RAWGEndpoint.games()

        // Act
        let items = sut.queryItems

        // Assert
        XCTAssertTrue(items.contains { $0.name == "key" && $0.value == "test_key" })

        // Cleanup
        RAWGConfiguration.setAPIKey("")
    }

    func test_endpoint_excludes_api_key_when_empty() {
        // Arrange
        RAWGConfiguration.setAPIKey("")
        let sut = RAWGEndpoint.games()

        // Act
        let items = sut.queryItems

        // Assert
        XCTAssertFalse(items.contains { $0.name == "key" })
    }
}
