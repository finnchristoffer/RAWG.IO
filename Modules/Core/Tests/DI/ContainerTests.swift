import XCTest
import Factory
@testable import Core

/// TDD Tests for DI Container
///
/// RED Phase: These tests should FAIL initially because
/// the Container extensions don't exist yet.
final class ContainerTests: XCTestCase {

    // MARK: - Storage Actor Registration

    func test_container_has_storageActor_registration() {
        // Arrange/Act
        let container = Container.shared

        // Assert - This should fail because storageActor doesn't exist
        XCTAssertNotNil(container.storageActor)
    }

    func test_storageActor_is_singleton() {
        // Arrange
        let container = Container.shared

        // Act
        let first = container.storageActor()
        let second = container.storageActor()

        // Assert - Singletons should return same instance
        XCTAssertTrue(first === second)
    }

    // MARK: - Image Cache Actor Registration

    func test_container_has_imageCacheActor_registration() {
        // Arrange/Act
        let container = Container.shared

        // Assert
        XCTAssertNotNil(container.imageCacheActor)
    }

    func test_imageCacheActor_is_singleton() {
        // Arrange
        let container = Container.shared

        // Act
        let first = container.imageCacheActor()
        let second = container.imageCacheActor()

        // Assert
        XCTAssertTrue(first === second)
    }

    // MARK: - Favorites Actor Registration

    func test_container_has_favoritesActor_registration() {
        // Arrange/Act
        let container = Container.shared

        // Assert
        XCTAssertNotNil(container.favoritesActor)
    }

    func test_favoritesActor_is_singleton() {
        // Arrange
        let container = Container.shared

        // Act
        let first = container.favoritesActor()
        let second = container.favoritesActor()

        // Assert
        XCTAssertTrue(first === second)
    }
}
