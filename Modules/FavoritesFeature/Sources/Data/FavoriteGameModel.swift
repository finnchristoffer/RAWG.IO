import Foundation
import SwiftData

/// Swift Data model for favorite games.
///
/// Shared across DetailFeature and FavoritesFeature modules.
/// Note: Using originalName to ensure consistent model identity across modules.
@Model
public final class FavoriteGameModel: @unchecked Sendable {
    /// The RAWG game ID.
    @Attribute(.unique)
    public var gameId: Int

    /// The game name.
    public var name: String

    /// URL string for the background image.
    public var backgroundImageURL: String?

    /// The game rating.
    public var rating: Double

    /// Release date string.
    public var released: String?

    /// Game description (raw text).
    public var descriptionText: String?

    /// Platforms as comma-separated string.
    public var platforms: String?

    /// Metacritic score.
    public var metacritic: Int?

    /// When the game was added to favorites.
    public var addedAt: Date

    /// Creates a new favorite game model.
    public init(
        gameId: Int,
        name: String,
        backgroundImageURL: String? = nil,
        rating: Double = 0.0,
        released: String? = nil,
        descriptionText: String? = nil,
        platforms: String? = nil,
        metacritic: Int? = nil,
        addedAt: Date = Date()
    ) {
        self.gameId = gameId
        self.name = name
        self.backgroundImageURL = backgroundImageURL
        self.rating = rating
        self.released = released
        self.descriptionText = descriptionText
        self.platforms = platforms
        self.metacritic = metacritic
        self.addedAt = addedAt
    }

    /// The background image as URL.
    public var imageURL: URL? {
        guard let urlString = backgroundImageURL else { return nil }
        return URL(string: urlString)
    }

    /// Platforms array.
    public var platformList: [String] {
        platforms?.components(separatedBy: ", ") ?? []
    }

    /// Formatted release year.
    public var releaseYear: String? {
        guard let released else { return nil }
        return String(released.prefix(4))
    }
}
