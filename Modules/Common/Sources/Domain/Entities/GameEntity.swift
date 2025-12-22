import Foundation

/// Domain entity representing a Game.
///
/// This is the clean domain model used by UseCases and ViewModels.
/// Converted from `GameDTO` via `GameMapper`.
public struct GameEntity: Sendable, Identifiable, Equatable {
    public let id: Int
    public let slug: String
    public let name: String
    public let released: String?
    public let backgroundImage: URL?
    public let rating: Double
    public let ratingsCount: Int
    public let metacritic: Int?
    public let playtime: Int
    public let platforms: [PlatformEntity]
    public let genres: [GenreEntity]

    public init(
        id: Int,
        slug: String,
        name: String,
        released: String?,
        backgroundImage: URL?,
        rating: Double,
        ratingsCount: Int,
        metacritic: Int?,
        playtime: Int,
        platforms: [PlatformEntity],
        genres: [GenreEntity]
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
}

// MARK: - Supporting Entities

public struct PlatformEntity: Sendable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}

public struct GenreEntity: Sendable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
