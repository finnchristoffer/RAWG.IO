import Foundation

/// Generic paginated response DTO from RAWG API.
public struct PaginatedResponseDTO<T: Decodable & Sendable>: Decodable, Sendable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [T]
}
