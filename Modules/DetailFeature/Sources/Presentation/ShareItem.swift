import Foundation

/// Share item model for sharing game details.
struct ShareItem: Sendable {
    /// The share text containing game name.
    let text: String
    /// The RAWG.io URL for the game.
    let url: URL?

    /// Creates a share item for a game.
    /// - Parameters:
    ///   - gameName: The name of the game.
    ///   - gameId: The RAWG game ID.
    init(gameName: String, gameId: Int) {
        self.text = "Check out \(gameName) on RAWG.io!"
        self.url = URL(string: "https://rawg.io/games/\(gameId)")
    }

    /// Activity items for UIActivityViewController.
    var activityItems: [Any] {
        var items: [Any] = [text]
        if let url {
            items.append(url)
        }
        return items
    }
}
