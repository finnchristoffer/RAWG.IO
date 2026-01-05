import XCTest
@testable import FavoritesFeature

/// Tests for FavoriteGame SwiftData model.
final class FavoriteGameTests: XCTestCase {
    // MARK: - Initialization Tests

    // swiftlint:disable:next function_body_length
    func test_init_setsAllProperties() {
        // Arrange
        let date = Date()

        // Act
        let favorite = FavoriteGame(
            gameId: 1,
            name: "The Witcher 3",
            slug: "witcher-3",
            backgroundImage: "https://example.com/image.jpg",
            rating: 4.8,
            ratingsCount: 5000,
            metacritic: 93,
            addedAt: date
        )

        // Assert
        XCTAssertEqual(
            favorite.gameId,
            1,
            "Expected gameId to be 1"
        )
        XCTAssertEqual(
            favorite.name,
            "The Witcher 3",
            "Expected name to match"
        )
        XCTAssertEqual(
            favorite.slug,
            "witcher-3",
            "Expected slug to match"
        )
        XCTAssertEqual(
            favorite.backgroundImage,
            "https://example.com/image.jpg",
            "Expected backgroundImage to match"
        )
        XCTAssertEqual(
            favorite.rating,
            4.8,
            "Expected rating to be 4.8"
        )
        XCTAssertEqual(
            favorite.ratingsCount,
            5000,
            "Expected ratingsCount to be 5000"
        )
        XCTAssertEqual(
            favorite.metacritic,
            93,
            "Expected metacritic to be 93"
        )
        XCTAssertEqual(
            favorite.addedAt,
            date,
            "Expected addedAt to match"
        )
    }

    func test_init_withDefaultValues() {
        // Arrange & Act
        let favorite = FavoriteGame(
            gameId: 1,
            name: "Game",
            slug: "game",
            rating: 4.0,
            ratingsCount: 100
        )

        // Assert
        XCTAssertNil(
            favorite.backgroundImage,
            "Expected backgroundImage to be nil by default"
        )
        XCTAssertNil(
            favorite.metacritic,
            "Expected metacritic to be nil by default"
        )
        XCTAssertNotNil(
            favorite.addedAt,
            "Expected addedAt to have default value"
        )
    }

    func test_init_addedAtDefaultsToNow() {
        // Arrange
        let beforeInit = Date()

        // Act
        let favorite = FavoriteGame(
            gameId: 1,
            name: "Game",
            slug: "game",
            rating: 4.0,
            ratingsCount: 100
        )
        let afterInit = Date()

        // Assert
        XCTAssertGreaterThanOrEqual(
            favorite.addedAt,
            beforeInit,
            "Expected addedAt to be >= beforeInit"
        )
        XCTAssertLessThanOrEqual(
            favorite.addedAt,
            afterInit,
            "Expected addedAt to be <= afterInit"
        )
    }

    // MARK: - Property Tests

    func test_gameId_isUnique() {
        // This test documents that gameId should be unique
        // The @Attribute(.unique) decorator enforces this at the SwiftData level
        let favorite = FavoriteGame(
            gameId: 42,
            name: "Game",
            slug: "game",
            rating: 4.0,
            ratingsCount: 100
        )

        XCTAssertEqual(
            favorite.gameId,
            42,
            "Expected gameId to be 42"
        )
    }

    func test_backgroundImage_canBeNil() {
        // Arrange & Act
        let favorite = FavoriteGame(
            gameId: 1,
            name: "Game",
            slug: "game",
            backgroundImage: nil,
            rating: 4.0,
            ratingsCount: 100
        )

        // Assert
        XCTAssertNil(
            favorite.backgroundImage,
            "Expected backgroundImage to be nil"
        )
    }

    func test_metacritic_canBeNil() {
        // Arrange & Act
        let favorite = FavoriteGame(
            gameId: 1,
            name: "Game",
            slug: "game",
            rating: 4.0,
            ratingsCount: 100,
            metacritic: nil
        )

        // Assert
        XCTAssertNil(
            favorite.metacritic,
            "Expected metacritic to be nil"
        )
    }

    func test_rating_acceptsZero() {
        // Arrange & Act
        let favorite = FavoriteGame(
            gameId: 1,
            name: "Game",
            slug: "game",
            rating: 0,
            ratingsCount: 0
        )

        // Assert
        XCTAssertEqual(
            favorite.rating,
            0,
            "Expected rating to be 0"
        )
        XCTAssertEqual(
            favorite.ratingsCount,
            0,
            "Expected ratingsCount to be 0"
        )
    }
}
