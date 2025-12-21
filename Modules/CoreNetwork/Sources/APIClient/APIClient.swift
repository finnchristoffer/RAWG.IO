import Foundation
import Core

/// Protocol for URLSession operations (enables testing).
public protocol URLSessionProtocol: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - URLSession Conformance

extension URLSession: URLSessionProtocol { }

/// Actor-based API client for making network requests.
///
/// Thread-safe and uses Swift concurrency for async operations.
///
/// ## Usage
/// ```swift
/// let client = APIClient(baseURL: URL(string: "https://api.rawg.io/api")!)
/// let games: GamesResponse = try await client.send(GamesRequest())
/// ```
public actor APIClient {
    // MARK: - Dependencies

    private let baseURL: URL
    private let session: URLSessionProtocol
    private let decoder: JSONDecoder

    // MARK: - Init

    public init(
        baseURL: URL,
        session: URLSessionProtocol = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    // MARK: - Public API

    /// Sends an API request and decodes the response.
    ///
    /// - Parameter request: The API request to send.
    /// - Returns: The decoded response.
    /// - Throws: `APIError` if the request fails.
    public func send<R: APIRequest>(_ request: R) async throws -> R.Response {
        let urlRequest = try buildURLRequest(for: request)

        Logger.debug("API Request: \(request.method.rawValue) \(urlRequest.url?.absoluteString ?? "")")

        let (data, response) = try await performRequest(urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError("Invalid response type")
        }

        Logger.debug("API Response: \(httpResponse.statusCode)")

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(R.Response.self, from: data)
        } catch {
            throw APIError.decodingError(error.localizedDescription)
        }
    }

    // MARK: - Private

    private func buildURLRequest<R: APIRequest>(for request: R) throws -> URLRequest {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        components?.path += request.path

        if !request.queryItems.isEmpty {
            components?.queryItems = request.queryItems
        }

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        if let body = request.body {
            urlRequest.httpBody = body
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return urlRequest
    }

    private func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch is CancellationError {
            throw APIError.cancelled
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
}
