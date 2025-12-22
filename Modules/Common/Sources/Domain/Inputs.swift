import Foundation

// MARK: - Domain Input Structs
// These are used by Domain/Presentation layer - no network knowledge

/// Input for fetching games list.
public struct GamesInput: Sendable, Equatable {
    public let page: Int
    public let pageSize: Int

    public init(page: Int = 1, pageSize: Int = 20) {
        self.page = page
        self.pageSize = pageSize
    }
}

/// Input for fetching game details.
public struct GameDetailInput: Sendable, Equatable {
    public let id: Int

    public init(id: Int) {
        self.id = id
    }
}

/// Input for searching games.
public struct SearchGamesInput: Sendable, Equatable {
    public let query: String
    public let page: Int

    public init(query: String, page: Int = 1) {
        self.query = query
        self.page = page
    }
}
