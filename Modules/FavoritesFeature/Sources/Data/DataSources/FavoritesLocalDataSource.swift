import Foundation
import SwiftData

/// Local data source for favorites using SwiftData.
public final class FavoritesLocalDataSource: @unchecked Sendable {
    private let modelContainer: ModelContainer

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    /// Inserts a favorite game.
    @MainActor
    public func insert(_ favorite: FavoriteGame) throws {
        let context = modelContainer.mainContext
        context.insert(favorite)
        try context.save()
    }

    /// Deletes a favorite by game ID.
    @MainActor
    public func delete(gameId: Int) throws {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<FavoriteGame>(
            predicate: #Predicate { $0.gameId == gameId }
        )
        if let favorite = try context.fetch(descriptor).first {
            context.delete(favorite)
            try context.save()
        }
    }

    /// Fetches all favorites sorted by added date.
    @MainActor
    public func fetchAll() throws -> [FavoriteGame] {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<FavoriteGame>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    /// Checks if a game is favorited.
    @MainActor
    public func exists(gameId: Int) throws -> Bool {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<FavoriteGame>(
            predicate: #Predicate { $0.gameId == gameId }
        )
        return try !context.fetch(descriptor).isEmpty
    }
}
