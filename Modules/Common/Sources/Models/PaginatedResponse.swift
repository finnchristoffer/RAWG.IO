import Foundation

/// A paginated response from RAWG API.
///
/// ## Usage
/// ```swift
/// let response: PaginatedResponse<Game> = try await client.send(request)
/// print(response.results)
/// ```
public struct PaginatedResponse<T: Decodable & Sendable>: Decodable, Sendable {
    /// Total count of items.
    public let count: Int

    /// URL for the next page, if available.
    public let next: String?

    /// URL for the previous page, if available.
    public let previous: String?

    /// Array of results for the current page.
    public let results: [T]

    // MARK: - Init

    public init(count: Int, next: String?, previous: String?, results: [T]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
