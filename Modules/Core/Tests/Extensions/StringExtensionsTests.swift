import XCTest
@testable import Core

/// Tests for String extensions.
final class StringExtensionsTests: XCTestCase {
    // MARK: - isBlank Tests

    func test_isBlank_returns_true_for_empty_string() {
        // Arrange
        let sut = ""

        // Act/Assert
        XCTAssertTrue(sut.ext.isBlank, "Empty string should be blank")
    }

    func test_isBlank_returns_true_for_whitespace_only() {
        // Arrange
        let sut = "   \t\n"

        // Act/Assert
        XCTAssertTrue(sut.ext.isBlank, "Whitespace-only string should be blank")
    }

    func test_isBlank_returns_false_for_non_empty_string() {
        // Arrange
        let sut = "hello"

        // Act/Assert
        XCTAssertFalse(sut.ext.isBlank, "Non-empty string should not be blank")
    }

    func test_isBlank_returns_false_for_string_with_content_and_whitespace() {
        // Arrange
        let sut = "  hello  "

        // Act/Assert
        XCTAssertFalse(sut.ext.isBlank, "String with content should not be blank")
    }

    // MARK: - trimmed Tests

    func test_trimmed_removes_leading_and_trailing_whitespace() {
        // Arrange
        let sut = "  hello world  "

        // Act
        let result = sut.ext.trimmed

        // Assert
        XCTAssertEqual(result, "hello world", "Expected trimmed result")
    }

    func test_trimmed_returns_same_string_when_no_whitespace() {
        // Arrange
        let sut = "hello"

        // Act
        let result = sut.ext.trimmed

        // Assert
        XCTAssertEqual(result, "hello", "Expected unchanged string")
    }

    func test_trimmed_returns_empty_for_whitespace_only() {
        // Arrange
        let sut = "   "

        // Act
        let result = sut.ext.trimmed

        // Assert
        XCTAssertEqual(result, "", "Expected empty string")
    }

    // MARK: - nilIfEmpty Tests

    func test_nilIfEmpty_returns_nil_for_empty_string() {
        // Arrange
        let sut = ""

        // Act
        let result = sut.ext.nilIfEmpty

        // Assert
        XCTAssertNil(result, "Empty string should return nil")
    }

    func test_nilIfEmpty_returns_self_for_non_empty_string() {
        // Arrange
        let sut = "hello"

        // Act
        let result = sut.ext.nilIfEmpty

        // Assert
        XCTAssertEqual(result, "hello", "Non-empty string should return self")
    }

    func test_nilIfEmpty_returns_whitespace_string() {
        // Arrange
        let sut = "   "

        // Act
        let result = sut.ext.nilIfEmpty

        // Assert
        XCTAssertEqual(result, "   ", "Whitespace-only string should return self (not empty)")
    }
}
