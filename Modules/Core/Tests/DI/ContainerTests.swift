import XCTest
import Factory
@testable import Core

/// Tests for DI Container (Core module)
final class ContainerTests: XCTestCase {
    // MARK: - Storage Actor Registration

    func test_container_has_storageActor_registration() {
        // Arrange
        let sut = makeSUT()

        // Act/Assert
        XCTAssertNotNil(sut.storageActor, "Expected Container to have storageActor registration")
    }

    func test_storageActor_is_singleton() {
        // Arrange
        let sut = makeSUT()

        // Act
        let first = sut.storageActor()
        let second = sut.storageActor()

        // Assert
        XCTAssertTrue(first === second, "Expected StorageActor to be singleton - both instances should be identical")
    }

    // MARK: - Image Cache Actor Registration

    func test_container_has_imageCacheActor_registration() {
        // Arrange
        let sut = makeSUT()

        // Act/Assert
        XCTAssertNotNil(sut.imageCacheActor, "Expected Container to have imageCacheActor registration")
    }

    func test_imageCacheActor_is_singleton() {
        // Arrange
        let sut = makeSUT()

        // Act
        let first = sut.imageCacheActor()
        let second = sut.imageCacheActor()

        // Assert
        XCTAssertTrue(first === second, "Expected ImageCacheActor to be singleton - both instances should be identical")
    }

    // MARK: - Helpers

    private func makeSUT() -> Container {
        let container = Container.shared

        addTeardownBlock {
            container.reset()
        }

        return container
    }
}
