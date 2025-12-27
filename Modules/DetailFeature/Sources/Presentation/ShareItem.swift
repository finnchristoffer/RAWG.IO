import Foundation

/// Share item model for sharing game details.
public struct ShareItem: Sendable {
    /// The share text containing game name.
    public let text: String
    /// The RAWG.io URL for the game.
    public let url: URL?

    /// Creates a share item for a game.
    /// - Parameters:
    ///   - gameName: The name of the game.
    ///   - gameId: The RAWG game ID.
    public init(gameName: String, gameId: Int) {
        self.text = "Check out \(gameName) on RAWG.io!"
        self.url = URL(string: "https://rawg.io/games/\(gameId)")
    }

    /// Activity items for UIActivityViewController.
    public var activityItems: [Any] {
        var items: [Any] = [text]
        if let url {
            items.append(url)
        }
        return items
    }
}
