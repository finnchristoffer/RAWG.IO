import XCTest
@testable import DetailFeature

/// Unit tests for GameDetailViewModel.
@MainActor
final class GameDetailViewModelTests: XCTestCase {
    // MARK: - Initialization Tests

    func test_init_setsGameIdAndName() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(gameId: 123, gameName: "The Witcher 3")

        // Assert
        XCTAssertEqual(viewModel.gameId, 123)
        XCTAssertEqual(viewModel.gameName, "The Witcher 3")
    }

    func test_init_startsWithLoadingFalse() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Assert
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_init_startsWithNoError() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Assert
        XCTAssertNil(viewModel.error)
    }

    // MARK: - Image URL Tests

    func test_init_withBackgroundImageURL_setsURL() {
        // Arrange
        let expectedURL = URL(string: "https://media.rawg.io/games/image.jpg")

        // Act
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            backgroundImageURL: expectedURL
        )

        // Assert
        XCTAssertEqual(viewModel.backgroundImageURL, expectedURL)
    }

    func test_init_withoutBackgroundImageURL_defaultsToNil() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Assert
        XCTAssertNil(viewModel.backgroundImageURL)
    }

    // MARK: - Loading Tests

    func test_loadDetails_setsLoadingThenCompletes() async {
        // Arrange
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Act
        await viewModel.loadDetails()

        // Assert - loading should be false after completion
        XCTAssertFalse(viewModel.isLoading)
    }
}
