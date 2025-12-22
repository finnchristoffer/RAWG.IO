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

    // MARK: - Init

    public init(
        id: Int,
        slug: String,
        name: String,
        released: String?,
        backgroundImage: String?,
        rating: Double,
        ratingsCount: Int,
        metacritic: Int?,
        playtime: Int,
        platforms: [PlatformWrapper]?,
        genres: [Genre]?
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingsCount = ratingsCount
        self.metacritic = metacritic
        self.playtime = playtime
        self.platforms = platforms
        self.genres = genres
    }

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

    public init(platform: Platform) {
        self.platform = platform
    }
}

/// Platform information.
public struct Platform: Decodable, Sendable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}

/// Genre information.
public struct Genre: Decodable, Sendable, Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
