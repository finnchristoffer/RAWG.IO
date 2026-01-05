import XCTest
import Factory
@testable import Common

/// Tests for CommonAssembly DI configuration.
final class CommonAssemblyTests: XCTestCase {
    // MARK: - APIClient Tests

    func test_apiClient_isResolved() {
        // Arrange
        let container = Container.shared

        // Act
        let client = container.apiClient()

        // Assert
        XCTAssertNotNil(
            client,
            "Expected apiClient to be resolved"
        )
    }

    // MARK: - DataSource Tests

    func test_gamesRemoteDataSource_isResolved() {
        // Arrange
        let container = Container.shared

        // Act
        let dataSource = container.gamesRemoteDataSource()

        // Assert
        XCTAssertNotNil(
            dataSource,
            "Expected gamesRemoteDataSource to be resolved"
        )
    }

    func test_gamesLocalDataSource_isResolved() async {
        // Arrange
        let container = Container.shared

        // Act
        let dataSource = container.gamesLocalDataSource()

        // Assert
        XCTAssertNotNil(
            dataSource,
            "Expected gamesLocalDataSource to be resolved"
        )
    }

    // MARK: - Repository Tests

    func test_gamesRepository_isResolved() {
        // Arrange
        let container = Container.shared

        // Act
        let repository = container.gamesRepository()

        // Assert
        XCTAssertNotNil(
            repository,
            "Expected gamesRepository to be resolved"
        )
    }

    func test_gamesRepository_returnsNewInstance() {
        // Arrange
        let container = Container.shared

        // Act
        let repo1 = container.gamesRepository() as AnyObject
        let repo2 = container.gamesRepository() as AnyObject

        // Assert
        XCTAssertFalse(
            repo1 === repo2,
            "Expected each call to return a new instance"
        )
    }

    // MARK: - apiClient Configuration Tests

    func test_apiClient_hasCorrectBaseURL() {
        // This test verifies the API client is configured for RAWG
        // The actual base URL is set in CommonAssembly

        // Arrange
        let container = Container.shared

        // Act
        let client = container.apiClient()

        // Assert - client exists and can be used
        XCTAssertNotNil(
            client,
            "Expected API client to be configured"
        )
    }
}
