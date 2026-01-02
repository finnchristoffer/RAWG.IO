import Foundation
import SwiftData
import Core
import Common

/// Internal service for favorites persistence.
/// Used by UseCase implementations, not exposed externally.
@MainActor
final class DefaultFavoritesService {
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?

    nonisolated init() {}

    /// Lazily creates the model container and context.
    private func ensureContext() throws -> ModelContext {
        if let context = modelContext {
            return context
        }

        // Create model container for FavoriteGameModel
        let schema = Schema([FavoriteGameModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

        self.modelContainer = container
        self.modelContext = container.mainContext
        return container.mainContext
    }

    public func addFavorite(_ game: GameEntity) async throws {
        let context = try ensureContext()
        
        // Check if already exists
        let targetId = game.id
        let descriptor = FetchDescriptor<FavoriteGameModel>(
            predicate: #Predicate { $0.gameId == targetId }
        )
        let existing = try context.fetch(descriptor)
        if !existing.isEmpty { return }

        let favorite = FavoriteGameModel(
            gameId: game.id,
            name: game.name,
            backgroundImageURL: game.backgroundImage?.absoluteString,
            rating: game.rating,
            released: game.released,
            descriptionText: nil,
            platforms: game.platforms.map { $0.name }.joined(separator: ", "),
            metacritic: game.metacritic
        )
        context.insert(favorite)
        try context.save()
    }

    public func removeFavorite(gameId: Int) async throws {
        let context = try ensureContext()
        let targetId = gameId
        let descriptor = FetchDescriptor<FavoriteGameModel>(
            predicate: #Predicate { $0.gameId == targetId }
        )
        let favorites = try context.fetch(descriptor)
        if let favorite = favorites.first {
            context.delete(favorite)
            try context.save()
        }
    }

    public func isFavorite(gameId: Int) async throws -> Bool {
        let context = try ensureContext()
        let targetId = gameId
        let descriptor = FetchDescriptor<FavoriteGameModel>(
            predicate: #Predicate { $0.gameId == targetId }
        )
        let favorites = try context.fetch(descriptor)
        return !favorites.isEmpty
    }

    public func getAllFavorites() async throws -> [GameEntity] {
        let context = try ensureContext()
        let descriptor = FetchDescriptor<FavoriteGameModel>()
        let favorites = try context.fetch(descriptor)
        return favorites.map { mapToEntity($0) }
    }

    private func mapToEntity(_ favorite: FavoriteGameModel) -> GameEntity {
        let platformEntities = favorite.platformList.map { name in
            PlatformEntity(id: 0, name: name, slug: name.lowercased())
        }

        return GameEntity(
            id: favorite.gameId,
            slug: "",
            name: favorite.name,
            released: favorite.released,
            backgroundImage: favorite.imageURL,
            rating: favorite.rating,
            ratingsCount: 0,
            metacritic: favorite.metacritic,
            playtime: 0,
            platforms: platformEntities,
            genres: []
        )
    }
}
