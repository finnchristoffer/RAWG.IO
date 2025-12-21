// swiftlint:disable:this file_name
import Foundation
@testable import CoreNetwork

/// Mock URLSession for network testing.
///
/// Uses constructor injection with Result types to constrain
/// stub behavior to success/failure only.
public final class URLSessionMock: URLSessionProtocol, @unchecked Sendable {
    // MARK: - Spy (captured calls)

    public private(set) var requestedURLs: [URL] = []
    public private(set) var requestedRequests: [URLRequest] = []

    // MARK: - Stub (injected via constructor)

    private let result: Result<(Data, URLResponse), Error>

    // MARK: - Init

    public init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }

    /// Convenience init for successful response with status code.
    public init(data: Data = Data(), statusCode: Int = 200) {
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "https://api.example.com")!
        guard let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ) else {
            fatalError("Failed to create HTTPURLResponse in URLSessionMock")
        }
        self.result = .success((data, response))
    }

    /// Convenience init for error response.
    public init(error: Error) {
        self.result = .failure(error)
    }

    // MARK: - URLSessionProtocol

    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        requestedRequests.append(request)
        if let url = request.url {
            requestedURLs.append(url)
        }
        return try result.get()
    }

    // MARK: - Convenience Accessors

    public var lastRequestedPath: String? {
        requestedURLs.last?.path
    }

    public var lastRequestedMethod: String? {
        requestedRequests.last?.httpMethod
    }
}
