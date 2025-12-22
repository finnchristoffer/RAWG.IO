import Foundation

/// Data Transfer Object for Game from RAWG API.
///
/// This represents the raw API response structure.
/// Use `GameMapper` to convert to domain `GameEntity`.
public struct GameDTO: Decodable, Sendable {
    public let id: Int
    public let slug: String
    public let name: String
    public let released: String?
    public let backgroundImage: String?
    public let rating: Double
    public let ratingsCount: Int
    public let metacritic: Int?
    public let playtime: Int
    public let platforms: [PlatformWrapperDTO]?
    public let genres: [GenreDTO]?

    private enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingsCount = "ratings_count"
        case metacritic
        case playtime
        case platforms
        case genres
    }
}

// MARK: - Supporting DTOs

public struct PlatformWrapperDTO: Decodable, Sendable {
    public let platform: PlatformDTO
}

public struct PlatformDTO: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
}

public struct GenreDTO: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
}
