import Foundation

/// Domain entity representing detailed Game information.
public struct GameDetailEntity: Sendable, Identifiable, Equatable {
    public let id: Int
    public let slug: String
    public let name: String
    public let nameOriginal: String?
    public let description: String?
    public let descriptionRaw: String?
    public let released: String?
    public let backgroundImage: URL?
    public let backgroundImageAdditional: URL?
    public let website: URL?
    public let rating: Double
    public let ratingsCount: Int
    public let metacritic: Int?
    public let playtime: Int
    public let platforms: [PlatformEntity]
    public let genres: [GenreEntity]
    public let developers: [DeveloperEntity]
    public let publishers: [PublisherEntity]

    public init(
        id: Int,
        slug: String,
        name: String,
        nameOriginal: String?,
        description: String?,
        descriptionRaw: String?,
        released: String?,
        backgroundImage: URL?,
        backgroundImageAdditional: URL?,
        website: URL?,
        rating: Double,
        ratingsCount: Int,
        metacritic: Int?,
        playtime: Int,
        platforms: [PlatformEntity],
        genres: [GenreEntity],
        developers: [DeveloperEntity],
        publishers: [PublisherEntity]
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.nameOriginal = nameOriginal
        self.description = description
        self.descriptionRaw = descriptionRaw
        self.released = released
        self.backgroundImage = backgroundImage
        self.backgroundImageAdditional = backgroundImageAdditional
        self.website = website
        self.rating = rating
        self.ratingsCount = ratingsCount
        self.metacritic = metacritic
        self.playtime = playtime
        self.platforms = platforms
        self.genres = genres
        self.developers = developers
        self.publishers = publishers
    }
}

// MARK: - Supporting Entities

public struct DeveloperEntity: Sendable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}

public struct PublisherEntity: Sendable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let slug: String

    public init(id: Int, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
    }
}
