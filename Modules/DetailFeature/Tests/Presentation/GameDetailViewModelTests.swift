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
        XCTAssertEqual(
            viewModel.gameId,
            123,
            "Expected gameId to be 123, got \(viewModel.gameId)"
        )
        XCTAssertEqual(
            viewModel.gameName,
            "The Witcher 3",
            "Expected gameName to be 'The Witcher 3', got '\(viewModel.gameName)'"
        )
    }

    func test_init_startsWithLoadingFalse() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Assert
        XCTAssertFalse(
            viewModel.isLoading,
            "Expected isLoading to be false on init"
        )
    }

    func test_init_startsWithNoError() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Assert
        XCTAssertNil(
            viewModel.error,
            "Expected error to be nil on init"
        )
    }

    func test_init_setsOptionalParameters() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            rating: 4.5,
            platforms: ["PC", "PS5"],
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.rating,
            4.5,
            "Expected rating to be 4.5, got \(viewModel.rating)"
        )
        XCTAssertEqual(
            viewModel.platforms.count,
            2,
            "Expected 2 platforms, got \(viewModel.platforms.count)"
        )
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
        XCTAssertEqual(
            viewModel.backgroundImageURL,
            expectedURL,
            "Expected backgroundImageURL to match provided URL"
        )
    }

    func test_init_withoutBackgroundImageURL_defaultsToNil() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Assert
        XCTAssertNil(
            viewModel.backgroundImageURL,
            "Expected backgroundImageURL to be nil when not provided"
        )
    }

    // MARK: - Loading Tests

    func test_loadDetails_setsLoadingThenCompletes() async {
        // Arrange
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Act
        await viewModel.loadDetails()

        // Assert - loading should be false after completion
        XCTAssertFalse(
            viewModel.isLoading,
            "Expected isLoading to be false after loadDetails completes"
        )
    }

    // MARK: - Favorite Tests

    func test_isFavorite_defaultsToFalse() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(gameId: 1, gameName: "Test")

        // Assert
        XCTAssertFalse(
            viewModel.isFavorite,
            "Expected isFavorite to be false by default"
        )
    }

    // MARK: - Computed Properties Tests

    func test_ratingString_formatsToOneDecimal() {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            rating: 4.567,
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.ratingString,
            "4.6",
            "Expected rating to be formatted as '4.6', got '\(viewModel.ratingString)'"
        )
    }

    func test_releaseYear_extractsFirstFourCharacters() {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            released: "2023-05-15",
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.releaseYear,
            "2023",
            "Expected releaseYear to be '2023', got '\(viewModel.releaseYear)'"
        )
    }

    func test_releaseYear_returnsDash_whenNil() {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.releaseYear,
            "—",
            "Expected releaseYear to be '—' when released is nil"
        )
    }

    func test_primaryPlatform_returnsFirstPlatform() {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            platforms: ["PC", "PlayStation 5", "Xbox"],
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.primaryPlatform,
            "PC",
            "Expected primaryPlatform to be 'PC', got '\(viewModel.primaryPlatform)'"
        )
    }

    func test_primaryPlatform_returnsDash_whenEmpty() {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            platforms: [],
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.primaryPlatform,
            "—",
            "Expected primaryPlatform to be '—' when empty"
        )
    }

    // MARK: - Preview Mode Tests

    func test_isPreview_skipsNetworkCalls() async {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Preview Test",
            isPreview: true
        )

        // Act
        await viewModel.loadDetails()

        // Assert - in preview mode, should complete without error
        XCTAssertNil(
            viewModel.error,
            "Expected no error in preview mode"
        )
        XCTAssertFalse(
            viewModel.isLoading,
            "Expected isLoading to be false after preview load"
        )
    }

    // MARK: - Description Tests

    func test_descriptionText_setsCorrectly() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            descriptionText: "An epic adventure game",
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.descriptionText,
            "An epic adventure game",
            "Expected descriptionText to match"
        )
    }

    func test_descriptionText_defaultsToNil() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            isPreview: true
        )

        // Assert
        XCTAssertNil(
            viewModel.descriptionText,
            "Expected descriptionText to be nil by default"
        )
    }

    // MARK: - Metacritic Tests

    func test_metacritic_setsCorrectly() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            metacritic: 93,
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.metacritic,
            93,
            "Expected metacritic to be 93"
        )
    }

    func test_metacritic_defaultsToNil() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            isPreview: true
        )

        // Assert
        XCTAssertNil(
            viewModel.metacritic,
            "Expected metacritic to be nil by default"
        )
    }

    // MARK: - Rating Tests

    func test_rating_defaultsToZero() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            viewModel.rating,
            0.0,
            "Expected rating to default to 0.0"
        )
    }

    func test_ratingString_formatsBoundaryValues() {
        // Arrange
        let zeroRating = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            rating: 0,
            isPreview: true
        )
        let maxRating = GameDetailViewModel(
            gameId: 2,
            gameName: "Test",
            rating: 5.0,
            isPreview: true
        )

        // Assert
        XCTAssertEqual(
            zeroRating.ratingString,
            "0.0",
            "Expected zero rating to format as '0.0'"
        )
        XCTAssertEqual(
            maxRating.ratingString,
            "5.0",
            "Expected max rating to format as '5.0'"
        )
    }

    // MARK: - Platforms Tests

    func test_platforms_defaultsToEmptyArray() {
        // Arrange & Act
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Test",
            isPreview: true
        )

        // Assert
        XCTAssertTrue(
            viewModel.platforms.isEmpty,
            "Expected platforms to be empty by default"
        )
    }
}
