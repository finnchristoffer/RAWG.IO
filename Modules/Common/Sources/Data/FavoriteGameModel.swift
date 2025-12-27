import Foundation
import SwiftData

/// Swift Data model for favorite games.
///
/// Shared across DetailFeature and FavoritesFeature modules.
@Model
public final class FavoriteGameModel {
    /// The RAWG game ID.
    @Attribute(.unique)
    public var gameId: Int

    /// The game name.
    public var name: String

    /// URL string for the background image.
    public var backgroundImageURL: String?

    /// The game rating.
    public var rating: Double

    /// When the game was added to favorites.
    public var addedAt: Date

    /// Creates a new favorite game model.
    public init(
        gameId: Int,
        name: String,
        backgroundImageURL: String? = nil,
        rating: Double = 0.0,
        addedAt: Date = Date()
    ) {
        self.gameId = gameId
        self.name = name
        self.backgroundImageURL = backgroundImageURL
        self.rating = rating
        self.addedAt = addedAt
    }

    /// The background image as URL.
    public var imageURL: URL? {
        guard let urlString = backgroundImageURL else { return nil }
        return URL(string: urlString)
    }
}
