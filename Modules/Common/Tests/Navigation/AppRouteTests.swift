import XCTest
@testable import Common

/// Tests for AppRoute navigation enum.
final class AppRouteTests: XCTestCase {
    // MARK: - Game Detail Route Tests

    func test_gameDetail_storesGameId() {
        // Arrange & Act
        let route = AppRoute.gameDetail(gameId: 123, name: "Test Game")

        // Assert
        if case let .gameDetail(gameId, _, _) = route {
            XCTAssertEqual(
                gameId,
                123,
                "Expected gameId to be 123"
            )
        } else {
            XCTFail("Expected gameDetail route")
        }
    }

    func test_gameDetail_storesGameName() {
        // Arrange & Act
        let route = AppRoute.gameDetail(gameId: 1, name: "The Witcher 3")

        // Assert
        if case let .gameDetail(_, name, _) = route {
            XCTAssertEqual(
                name,
                "The Witcher 3",
                "Expected name to match"
            )
        } else {
            XCTFail("Expected gameDetail route")
        }
    }

    func test_gameDetail_storesBackgroundImageURL() {
        // Arrange
        let url = URL(string: "https://example.com/image.jpg")

        // Act
        let route = AppRoute.gameDetail(gameId: 1, name: "Game", backgroundImageURL: url)

        // Assert
        if case let .gameDetail(_, _, imageURL) = route {
            XCTAssertEqual(
                imageURL?.absoluteString,
                "https://example.com/image.jpg",
                "Expected backgroundImageURL to match"
            )
        } else {
            XCTFail("Expected gameDetail route")
        }
    }

    func test_gameDetail_backgroundImageURLDefaultsToNil() {
        // Arrange & Act
        let route = AppRoute.gameDetail(gameId: 1, name: "Game")

        // Assert
        if case let .gameDetail(_, _, imageURL) = route {
            XCTAssertNil(
                imageURL,
                "Expected backgroundImageURL to be nil by default"
            )
        } else {
            XCTFail("Expected gameDetail route")
        }
    }

    // MARK: - Favorites Route Tests

    func test_favorites_createsRoute() {
        // Arrange & Act
        let route = AppRoute.favorites

        // Assert
        if case .favorites = route {
            XCTAssertTrue(true, "favorites route created successfully")
        } else {
            XCTFail("Expected favorites route")
        }
    }

    // MARK: - Search Route Tests

    func test_search_createsRoute() {
        // Arrange & Act
        let route = AppRoute.search

        // Assert
        if case .search = route {
            XCTAssertTrue(true, "search route created successfully")
        } else {
            XCTFail("Expected search route")
        }
    }

    // MARK: - Hashable Tests

    func test_gameDetail_sameValuesAreEqual() {
        // Arrange
        let route1 = AppRoute.gameDetail(gameId: 1, name: "Game")
        let route2 = AppRoute.gameDetail(gameId: 1, name: "Game")

        // Assert
        XCTAssertEqual(
            route1,
            route2,
            "Expected routes with same values to be equal"
        )
    }

    func test_gameDetail_differentValuesAreNotEqual() {
        // Arrange
        let route1 = AppRoute.gameDetail(gameId: 1, name: "Game 1")
        let route2 = AppRoute.gameDetail(gameId: 2, name: "Game 2")

        // Assert
        XCTAssertNotEqual(
            route1,
            route2,
            "Expected routes with different values to not be equal"
        )
    }

    func test_differentRouteTypesAreNotEqual() {
        // Arrange
        let favorites = AppRoute.favorites
        let search = AppRoute.search

        // Assert
        XCTAssertNotEqual(
            favorites,
            search,
            "Expected different route types to not be equal"
        )
    }

    // MARK: - Hash Tests

    func test_routes_canBeUsedAsSetElements() {
        // Arrange
        var routeSet = Set<AppRoute>()

        // Act
        routeSet.insert(.favorites)
        routeSet.insert(.search)
        routeSet.insert(.gameDetail(gameId: 1, name: "Game"))

        // Assert
        XCTAssertEqual(
            routeSet.count,
            3,
            "Expected 3 unique routes in set"
        )
    }

    func test_routes_duplicatesNotAddedToSet() {
        // Arrange
        var routeSet = Set<AppRoute>()

        // Act
        routeSet.insert(.favorites)
        routeSet.insert(.favorites)

        // Assert
        XCTAssertEqual(
            routeSet.count,
            1,
            "Expected duplicate favorites to not be added"
        )
    }
}
