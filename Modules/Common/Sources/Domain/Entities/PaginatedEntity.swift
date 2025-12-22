import Foundation

/// Generic paginated response entity.
public struct PaginatedEntity<T: Sendable>: Sendable {
    public let count: Int
    public let hasNextPage: Bool
    public let hasPreviousPage: Bool
    public let results: [T]

    public init(
        count: Int,
        hasNextPage: Bool,
        hasPreviousPage: Bool,
        results: [T]
    ) {
        self.count = count
        self.hasNextPage = hasNextPage
        self.hasPreviousPage = hasPreviousPage
        self.results = results
    }
}
