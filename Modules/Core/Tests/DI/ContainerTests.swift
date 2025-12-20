import XCTest
import Factory
@testable import Core

/// TDD Tests for DI Container (Core module)
final class ContainerTests: XCTestCase {
    // MARK: - Storage Actor Registration

    func test_container_has_storageActor_registration() {
        // Arrange/Act
        let container = Container.shared

        // Assert
        XCTAssertNotNil(
            container.storageActor,
            "Expected Container to have storageActor registration"
        )
    }

    func test_storageActor_is_singleton() {
        // Arrange
        let container = Container.shared

        // Act
        let first = container.storageActor()
        let second = container.storageActor()

        // Assert
        XCTAssertTrue(
            first === second,
            "Expected StorageActor to be singleton - both instances should be identical"
        )
    }

    // MARK: - Image Cache Actor Registration

    func test_container_has_imageCacheActor_registration() {
        // Arrange/Act
        let container = Container.shared

        // Assert
        XCTAssertNotNil(
            container.imageCacheActor,
            "Expected Container to have imageCacheActor registration"
        )
    }

    func test_imageCacheActor_is_singleton() {
        // Arrange
        let container = Container.shared

        // Act
        let first = container.imageCacheActor()
        let second = container.imageCacheActor()

        // Assert
        XCTAssertTrue(
            first === second,
            "Expected ImageCacheActor to be singleton - both instances should be identical"
        )
    }
}
