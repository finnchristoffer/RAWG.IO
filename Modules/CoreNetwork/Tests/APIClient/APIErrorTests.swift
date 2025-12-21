import XCTest
@testable import CoreNetwork

/// Tests for APIError enum.
final class APIErrorTests: XCTestCase {
    // MARK: - Error Descriptions

    func test_invalidURL_has_correct_description() {
        // Arrange
        let sut = APIError.invalidURL

        // Act/Assert
        XCTAssertEqual(sut.errorDescription, "Invalid URL")
    }

    func test_networkError_has_correct_description() {
        // Arrange
        let sut = APIError.networkError("Connection failed")

        // Act/Assert
        XCTAssertEqual(sut.errorDescription, "Network error: Connection failed")
    }

    func test_decodingError_has_correct_description() {
        // Arrange
        let sut = APIError.decodingError("Missing key")

        // Act/Assert
        XCTAssertEqual(sut.errorDescription, "Decoding error: Missing key")
    }

    func test_httpError_has_correct_description() {
        // Arrange
        let sut = APIError.httpError(statusCode: 404)

        // Act/Assert
        XCTAssertEqual(sut.errorDescription, "HTTP error: 404")
    }

    func test_cancelled_has_correct_description() {
        // Arrange
        let sut = APIError.cancelled

        // Act/Assert
        XCTAssertEqual(sut.errorDescription, "Request cancelled")
    }

    func test_noData_has_correct_description() {
        // Arrange
        let sut = APIError.noData

        // Act/Assert
        XCTAssertEqual(sut.errorDescription, "No data received")
    }

    // MARK: - Equatable

    func test_errors_are_equatable() {
        XCTAssertEqual(APIError.invalidURL, APIError.invalidURL)
        XCTAssertEqual(APIError.httpError(statusCode: 500), APIError.httpError(statusCode: 500))
        XCTAssertNotEqual(APIError.httpError(statusCode: 500), APIError.httpError(statusCode: 404))
    }
}
