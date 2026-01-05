import XCTest
import Factory
@testable import SearchFeature

/// Tests for SearchFeatureAssembly DI.
final class SearchFeatureAssemblyTests: XCTestCase {
    // MARK: - UseCase Tests

    func test_searchGamesUseCase_isResolved() {
        // Arrange
        let container = Container.shared

        // Act
        let useCase = container.searchGamesUseCase()

        // Assert
        XCTAssertNotNil(
            useCase,
            "Expected searchGamesUseCase to be resolved"
        )
    }

    func test_searchGamesUseCase_returnsNewInstance() {
        // Arrange
        let container = Container.shared

        // Act
        let useCase1 = container.searchGamesUseCase()
        let useCase2 = container.searchGamesUseCase()

        // Assert
        XCTAssertFalse(
            useCase1 === useCase2,
            "Expected each call to return a new instance"
        )
    }

    // MARK: - ViewModel Tests

    @MainActor
    func test_searchViewModel_isResolved() {
        // Arrange
        let container = Container.shared

        // Act
        let viewModel = container.searchViewModel()

        // Assert
        XCTAssertNotNil(
            viewModel,
            "Expected searchViewModel to be resolved"
        )
    }

    @MainActor
    func test_searchViewModel_startsWithEmptyState() {
        // Arrange
        let container = Container.shared

        // Act
        let viewModel = container.searchViewModel()

        // Assert
        XCTAssertTrue(
            viewModel.games.isEmpty,
            "Expected new viewModel to have empty games"
        )
        XCTAssertTrue(
            viewModel.searchQuery.isEmpty,
            "Expected new viewModel to have empty searchQuery"
        )
    }
}
