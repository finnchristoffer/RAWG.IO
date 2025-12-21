import XCTest
@testable import CoreNetwork

/// Tests for APIClient actor.
final class APIClientTests: XCTestCase {
    // MARK: - Success Tests

    func test_send_returns_decoded_response_on_success() async throws {
        // Arrange
        let expectedResponse = MockResponse(id: 1, name: "Test")
        let data = try JSONEncoder().encode(expectedResponse)
        let (sut, _) = makeSUT(data: data, statusCode: 200)
        let request = MockRequest()

        // Act
        let result = try await sut.send(request)

        // Assert
        XCTAssertEqual(result.id, expectedResponse.id)
        XCTAssertEqual(result.name, expectedResponse.name)
    }

    func test_send_uses_correct_http_method() async throws {
        // Arrange
        let data = try JSONEncoder().encode(MockResponse(id: 1, name: "Test"))
        let (sut, mock) = makeSUT(data: data, statusCode: 200)
        let request = MockRequest(method: .post)

        // Act
        _ = try await sut.send(request)

        // Assert
        XCTAssertEqual(mock.lastRequestedMethod, "POST")
    }

    func test_send_uses_correct_path() async throws {
        // Arrange
        let data = try JSONEncoder().encode(MockResponse(id: 1, name: "Test"))
        let (sut, mock) = makeSUT(data: data, statusCode: 200)
        let request = MockRequest(path: "/games")

        // Act
        _ = try await sut.send(request)

        // Assert
        XCTAssertTrue(mock.lastRequestedPath?.contains("/games") ?? false)
    }

    // MARK: - Error Tests

    func test_send_throws_httpError_for_non_2xx_status() async {
        // Arrange
        let (sut, _) = makeSUT(data: Data(), statusCode: 404)
        let request = MockRequest()

        // Act/Assert
        do {
            _ = try await sut.send(request)
            XCTFail("Expected error")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.httpError(statusCode: 404))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_send_throws_decodingError_for_invalid_json() async {
        // Arrange
        let invalidData = Data("not json".utf8)
        let (sut, _) = makeSUT(data: invalidData, statusCode: 200)
        let request = MockRequest()

        // Act/Assert
        do {
            _ = try await sut.send(request)
            XCTFail("Expected error")
        } catch let error as APIError {
            guard case .decodingError = error else {
                XCTFail("Expected decodingError")
                return
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_send_throws_networkError_for_session_failure() async {
        // Arrange
        let (sut, _) = makeSUT(error: URLError(.notConnectedToInternet))
        let request = MockRequest()

        // Act/Assert
        do {
            _ = try await sut.send(request)
            XCTFail("Expected error")
        } catch let error as APIError {
            guard case .networkError = error else {
                XCTFail("Expected networkError")
                return
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Helpers

    private func makeSUT(
        data: Data = Data(),
        statusCode: Int = 200,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (APIClient, URLSessionMock) {
        let mock = URLSessionMock(data: data, statusCode: statusCode)
        // swiftlint:disable:next force_unwrapping
        let baseURL = URL(string: "https://api.example.com")!
        let sut = APIClient(baseURL: baseURL, session: mock)
        return (sut, mock)
    }

    private func makeSUT(
        error: Error,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (APIClient, URLSessionMock) {
        let mock = URLSessionMock(error: error)
        // swiftlint:disable:next force_unwrapping
        let baseURL = URL(string: "https://api.example.com")!
        let sut = APIClient(baseURL: baseURL, session: mock)
        return (sut, mock)
    }
}

// MARK: - Test Doubles

private struct MockRequest: APIRequest {
    typealias Response = MockResponse

    let path: String
    let method: HTTPMethod

    init(path: String = "/test", method: HTTPMethod = .get) {
        self.path = path
        self.method = method
    }
}

private struct MockResponse: Codable, Equatable, Sendable {
    let id: Int
    let name: String
}
