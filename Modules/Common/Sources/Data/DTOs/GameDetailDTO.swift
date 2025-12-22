import Foundation

/// Data Transfer Object for GameDetail from RAWG API.
public struct GameDetailDTO: Decodable, Sendable {
    public let id: Int
    public let slug: String
    public let name: String
    public let nameOriginal: String?
    public let description: String?
    public let descriptionRaw: String?
    public let released: String?
    public let backgroundImage: String?
    public let backgroundImageAdditional: String?
    public let website: String?
    public let rating: Double
    public let ratingsCount: Int
    public let metacritic: Int?
    public let playtime: Int
    public let platforms: [PlatformWrapperDTO]?
    public let genres: [GenreDTO]?
    public let developers: [DeveloperDTO]?
    public let publishers: [PublisherDTO]?

    private enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case nameOriginal = "name_original"
        case description
        case descriptionRaw = "description_raw"
        case released
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case website
        case rating
        case ratingsCount = "ratings_count"
        case metacritic
        case playtime
        case platforms
        case genres
        case developers
        case publishers
    }
}

// MARK: - Supporting DTOs

public struct DeveloperDTO: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
}

public struct PublisherDTO: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let slug: String
}
