import Foundation
import SwiftData

/// SwiftData model for storing favorite games.
@Model
public final class FavoriteGame {
    /// The game ID from RAWG API.
    @Attribute(.unique) public var gameId: Int

    /// Game name.
    public var name: String

    /// Game slug.
    public var slug: String

    /// Background image URL string.
    public var backgroundImage: String?

    /// Game rating.
    public var rating: Double

    /// Number of ratings.
    public var ratingsCount: Int

    /// Metacritic score.
    public var metacritic: Int?

    /// Date when the game was added to favorites.
    public var addedAt: Date

    public init(
        gameId: Int,
        name: String,
        slug: String,
        backgroundImage: String? = nil,
        rating: Double,
        ratingsCount: Int,
        metacritic: Int? = nil,
        addedAt: Date = Date()
    ) {
        self.gameId = gameId
        self.name = name
        self.slug = slug
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingsCount = ratingsCount
        self.metacritic = metacritic
        self.addedAt = addedAt
    }
}
