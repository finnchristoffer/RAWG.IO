// swiftlint:disable:this file_name
import XCTest
@testable import CoreNetwork

/// Tests for Endpoint protocol.
final class EndpointTests: XCTestCase {
    // MARK: - URL Building Tests

    func test_url_builds_correctly_from_baseURL_and_path() {
        // Arrange
        let sut = MockEndpoint(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "https://api.example.com")!,
            path: "/users"
        )

        // Act
        let result = sut.url

        // Assert
        XCTAssertEqual(result?.absoluteString, "https://api.example.com/users")
    }

    func test_url_includes_query_items() {
        // Arrange
        let sut = MockEndpoint(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "https://api.example.com")!,
            path: "/users",
            queryItems: [
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "limit", value: "10")
            ]
        )

        // Act
        let result = sut.url

        // Assert
        XCTAssertTrue(result?.absoluteString.contains("page=1") ?? false)
        XCTAssertTrue(result?.absoluteString.contains("limit=10") ?? false)
    }

    // MARK: - Default Values Tests

    func test_default_method_is_get() {
        // Arrange
        let sut = MockEndpoint(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "https://api.example.com")!,
            path: "/users"
        )

        // Act/Assert
        XCTAssertEqual(sut.method, .get)
    }

    func test_default_headers_is_empty() {
        // Arrange
        let sut = MockEndpoint(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "https://api.example.com")!,
            path: "/users"
        )

        // Act/Assert
        XCTAssertTrue(sut.headers.isEmpty)
    }

    func test_default_queryItems_is_empty() {
        // Arrange
        let sut = MockEndpoint(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "https://api.example.com")!,
            path: "/users"
        )

        // Act/Assert
        XCTAssertTrue(sut.queryItems.isEmpty)
    }
}

// MARK: - Test Doubles

private struct MockEndpoint: Endpoint {
    let baseURL: URL
    let path: String
    var method: HTTPMethod = .get
    var headers: [String: String] = [:]
    var queryItems: [URLQueryItem] = []
}
