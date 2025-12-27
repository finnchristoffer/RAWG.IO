import XCTest
@testable import DetailFeature

/// Unit tests for ShareSheet functionality.
final class ShareSheetTests: XCTestCase {
    // MARK: - Share Item Tests

    func test_shareItem_containsGameName() {
        // Arrange
        let gameName = "The Witcher 3: Wild Hunt"
        let gameId = 123

        // Act
        let shareItem = ShareItem(gameName: gameName, gameId: gameId)

        // Assert
        XCTAssertTrue(shareItem.text.contains(gameName))
    }

    func test_shareItem_containsRAWGUrl() {
        // Arrange
        let gameName = "Test Game"
        let gameId = 456

        // Act
        let shareItem = ShareItem(gameName: gameName, gameId: gameId)

        // Assert
        XCTAssertNotNil(shareItem.url)
        XCTAssertTrue(shareItem.url?.absoluteString.contains("rawg.io") ?? false)
    }

    func test_shareItem_generatesValidUrl() {
        // Arrange
        let gameId = 789

        // Act
        let shareItem = ShareItem(gameName: "Test", gameId: gameId)

        // Assert
        XCTAssertEqual(shareItem.url?.absoluteString, "https://rawg.io/games/\(gameId)")
    }
}
