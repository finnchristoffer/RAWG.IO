import Foundation
import SwiftData
import Core
import Common

/// ViewModel for Game Detail screen.
@MainActor
public final class GameDetailViewModel: ObservableObject {
    @Published public private(set) var gameId: Int
    @Published public private(set) var gameName: String
    @Published public private(set) var backgroundImageURL: URL?
    @Published public private(set) var isLoading = false
    @Published public private(set) var isFavorite = false
    @Published public private(set) var error: Error?

    private var favoriteRepository: SwiftDataRepository<FavoriteGameModel>?

    public init(
        gameId: Int,
        gameName: String,
        backgroundImageURL: URL? = nil,
        modelContext: ModelContext? = nil
    ) {
        self.gameId = gameId
        self.gameName = gameName
        self.backgroundImageURL = backgroundImageURL
        if let context = modelContext {
            self.favoriteRepository = SwiftDataRepository(modelContext: context)
        }
    }

    /// Updates the model context for favorites (called from onAppear).
    public func updateModelContext(_ context: ModelContext) {
        if favoriteRepository == nil {
            favoriteRepository = SwiftDataRepository(modelContext: context)
        }
    }

    /// Loads game details and checks favorite status.
    public func loadDetails() async {
        isLoading = true
        await checkFavoriteStatus()
        isLoading = false
    }

    /// Toggles the favorite status of the game.
    public func toggleFavorite() async {
        guard let repository = favoriteRepository else {
            Logger.debug("⚠️ No favoriteRepository available - ModelContext not set")
            return
        }

        do {
            if isFavorite {
                // Remove from favorites
                let targetGameId = gameId
                let predicate = #Predicate<FavoriteGameModel> { $0.gameId == targetGameId }
                let favorites = try await repository.fetch(predicate: predicate)
                if let favorite = favorites.first {
                    try await repository.delete(favorite)
                }
                isFavorite = false
            } else {
                // Add to favorites
                let favorite = FavoriteGameModel(
                    gameId: gameId,
                    name: gameName,
                    backgroundImageURL: backgroundImageURL?.absoluteString,
                    rating: 0.0
                )
                try await repository.insert(favorite)
                isFavorite = true
            }
        } catch {
            self.error = error
            Logger.error("❌ Favorite toggle error: \(error)")
        }
    }

    // MARK: - Private

    private func checkFavoriteStatus() async {
        guard let repository = favoriteRepository else { return }

        do {
            let targetGameId = gameId
            let predicate = #Predicate<FavoriteGameModel> { $0.gameId == targetGameId }
            let favorites = try await repository.fetch(predicate: predicate)
            isFavorite = !favorites.isEmpty
        } catch {
            self.error = error
        }
    }
}
