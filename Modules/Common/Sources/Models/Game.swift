import Foundation

/// Game model from RAWG API.
///
/// Represents basic game information for list views.
public struct Game: Decodable, Sendable, Identifiable, Equatable {
    /// Unique identifier.
    public let id: Int

    /// URL slug for the game.
    public let slug: String

    /// Display name.
    public let name: String

    /// Release date in "YYYY-MM-DD" format.
    public let released: String?

    /// Background image URL.
    public let backgroundImage: String?

    /// Average rating (0-5 scale).
    public let rating: Double

    /// Total number of ratings.
    public let ratingsCount: Int

    /// Metacritic score (0-100).
    public let metacritic: Int?

    /// Approximate playtime in hours.
    public let playtime: Int

    /// List of platforms the game is available on.
    public let platforms: [PlatformWrapper]?

    /// List of genres.
    public let genres: [Genre]?

    // MARK: - Coding Keys

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

// MARK: - Supporting Types

/// Wrapper for platform information.
public struct PlatformWrapper: Decodable, Sendable, Equatable {
    public let platform: Platform
}

/// Platform information.
public struct Platform: Decodable, Sendable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let slug: String
}

/// Genre information.
public struct Genre: Decodable, Sendable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let slug: String
}
