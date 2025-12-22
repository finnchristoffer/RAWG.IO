import Foundation

/// Detailed game information from RAWG API.
///
/// Contains extended information for game detail views.
public struct GameDetail: Decodable, Sendable, Identifiable, Equatable {
    /// Unique identifier.
    public let id: Int

    /// URL slug for the game.
    public let slug: String

    /// Display name.
    public let name: String

    /// Full description in HTML format.
    public let description: String?

    /// Plain text description.
    public let descriptionRaw: String?

    /// Release date in "YYYY-MM-DD" format.
    public let released: String?

    /// Background image URL.
    public let backgroundImage: String?

    /// Additional background image URL.
    public let backgroundImageAdditional: String?

    /// Official website URL.
    public let website: String?

    /// Average rating (0-5 scale).
    public let rating: Double

    /// Total number of ratings.
    public let ratingsCount: Int

    /// Metacritic score (0-100).
    public let metacritic: Int?

    /// Approximate playtime in hours.
    public let playtime: Int

    /// List of platforms.
    public let platforms: [PlatformWrapper]?

    /// List of genres.
    public let genres: [Genre]?

    /// List of developers.
    public let developers: [Developer]?

    /// List of publishers.
    public let publishers: [Publisher]?

    // MARK: - Coding Keys

    private enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
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

// MARK: - Supporting Types

/// Developer information.
public struct Developer: Decodable, Sendable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let slug: String
}

/// Publisher information.
public struct Publisher: Decodable, Sendable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let slug: String
}
