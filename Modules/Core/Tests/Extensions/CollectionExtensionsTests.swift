import XCTest
@testable import Core

/// Tests for Collection extensions.
final class CollectionExtensionsTests: XCTestCase {
    // MARK: - safe Subscript Tests

    func test_safe_subscript_returns_element_for_valid_index() {
        // Arrange
        let sut = [1, 2, 3, 4, 5]

        // Act
        let result = sut.ext[safe: 2]

        // Assert
        XCTAssertEqual(result, 3, "Expected element at index 2")
    }

    func test_safe_subscript_returns_nil_for_negative_index() {
        // Arrange
        let sut = [1, 2, 3]

        // Act
        let result = sut.ext[safe: -1]

        // Assert
        XCTAssertNil(result, "Expected nil for negative index")
    }

    func test_safe_subscript_returns_nil_for_out_of_bounds_index() {
        // Arrange
        let sut = [1, 2, 3]

        // Act
        let result = sut.ext[safe: 10]

        // Assert
        XCTAssertNil(result, "Expected nil for out of bounds index")
    }

    func test_safe_subscript_returns_nil_for_empty_collection() {
        // Arrange
        let sut: [Int] = []

        // Act
        let result = sut.ext[safe: 0]

        // Assert
        XCTAssertNil(result, "Expected nil for empty collection")
    }

    func test_safe_subscript_works_with_first_element() {
        // Arrange
        let sut = ["a", "b", "c"]

        // Act
        let result = sut.ext[safe: 0]

        // Assert
        XCTAssertEqual(result, "a", "Expected first element")
    }

    func test_safe_subscript_works_with_last_element() {
        // Arrange
        let sut = ["a", "b", "c"]

        // Act
        let result = sut.ext[safe: 2]

        // Assert
        XCTAssertEqual(result, "c", "Expected last element")
    }
}
