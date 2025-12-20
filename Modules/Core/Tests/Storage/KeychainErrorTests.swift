import XCTest
@testable import Core

/// Tests for KeychainError
final class KeychainErrorTests: XCTestCase {
    // MARK: - Error Description Tests

    func test_saveFailed_has_description() {
        // Arrange
        let error = KeychainError.saveFailed(-25300)

        // Assert
        XCTAssertNotNil(error.errorDescription, "Expected saveFailed to have description")
        XCTAssertTrue(
            error.errorDescription?.contains("-25300") ?? false,
            "Expected description to contain status code"
        )
    }

    func test_loadFailed_has_description() {
        // Arrange
        let error = KeychainError.loadFailed(-25291)

        // Assert
        XCTAssertNotNil(error.errorDescription, "Expected loadFailed to have description")
        XCTAssertTrue(
            error.errorDescription?.contains("-25291") ?? false,
            "Expected description to contain status code"
        )
    }

    func test_deleteFailed_has_description() {
        // Arrange
        let error = KeychainError.deleteFailed(-25292)

        // Assert
        XCTAssertNotNil(error.errorDescription, "Expected deleteFailed to have description")
        XCTAssertTrue(
            error.errorDescription?.contains("-25292") ?? false,
            "Expected description to contain status code"
        )
    }
}
