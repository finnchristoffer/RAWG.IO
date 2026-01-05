import XCTest
@testable import DetailFeature

/// Tests for ShareItem.
final class ShareItemTests: XCTestCase {
    // MARK: - Initialization Tests

    func test_init_createsCorrectText() {
        // Arrange & Act
        let shareItem = ShareItem(gameName: "The Witcher 3", gameId: 3498)

        // Assert
        XCTAssertEqual(
            shareItem.text,
            "Check out The Witcher 3 on RAWG.io!",
            "Expected text to include game name"
        )
    }

    func test_init_createsCorrectURL() {
        // Arrange & Act
        let shareItem = ShareItem(gameName: "Game", gameId: 12345)

        // Assert
        XCTAssertEqual(
            shareItem.url?.absoluteString,
            "https://rawg.io/games/12345",
            "Expected URL to contain game ID"
        )
    }

    func test_url_isNotNil() {
        // Arrange & Act
        let shareItem = ShareItem(gameName: "Test", gameId: 1)

        // Assert
        XCTAssertNotNil(
            shareItem.url,
            "Expected URL to be non-nil"
        )
    }

    // MARK: - Activity Items Tests

    func test_activityItems_containsText() {
        // Arrange
        let shareItem = ShareItem(gameName: "Game", gameId: 1)

        // Act
        let items = shareItem.activityItems

        // Assert
        XCTAssertTrue(
            items.contains { ($0 as? String) == shareItem.text },
            "Expected activityItems to contain text"
        )
    }

    func test_activityItems_containsURL() {
        // Arrange
        let shareItem = ShareItem(gameName: "Game", gameId: 1)

        // Act
        let items = shareItem.activityItems

        // Assert
        XCTAssertTrue(
            items.contains { ($0 as? URL) == shareItem.url },
            "Expected activityItems to contain URL"
        )
    }

    func test_activityItems_hasTwoItems() {
        // Arrange
        let shareItem = ShareItem(gameName: "Game", gameId: 1)

        // Act
        let items = shareItem.activityItems

        // Assert
        XCTAssertEqual(
            items.count,
            2,
            "Expected 2 activity items (text and URL)"
        )
    }

    // MARK: - Edge Cases

    func test_init_handlesSpecialCharactersInName() {
        // Arrange & Act
        let shareItem = ShareItem(gameName: "Game: With—Special 'Characters'", gameId: 1)

        // Assert
        XCTAssertTrue(
            shareItem.text.contains("Game: With—Special 'Characters'"),
            "Expected text to include special characters"
        )
    }

    func test_init_handlesLargeGameId() {
        // Arrange & Act
        let shareItem = ShareItem(gameName: "Game", gameId: 999999999)

        // Assert
        XCTAssertEqual(
            shareItem.url?.absoluteString,
            "https://rawg.io/games/999999999",
            "Expected URL to handle large game ID"
        )
    }

    func test_init_handlesEmptyGameName() {
        // Arrange & Act
        let shareItem = ShareItem(gameName: "", gameId: 1)

        // Assert
        XCTAssertEqual(
            shareItem.text,
            "Check out  on RAWG.io!",
            "Expected text to handle empty game name"
        )
    }

    // MARK: - Sendable Conformance

    func test_shareItem_isSendable() {
        // Arrange
        let shareItem = ShareItem(gameName: "Game", gameId: 1)

        // Act - Send to another task
        Task {
            _ = shareItem.text
            _ = shareItem.url
        }

        // Assert - Would not compile if not Sendable
        XCTAssertTrue(true, "ShareItem conforms to Sendable")
    }
}
