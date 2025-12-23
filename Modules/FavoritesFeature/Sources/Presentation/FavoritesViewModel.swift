import SwiftUI
import Common
import Factory

/// ViewModel for the Favorites screen.
@MainActor
final class FavoritesViewModel: ObservableObject {
    // MARK: - Published State

    @Published private(set) var favorites: [GameEntity] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    // MARK: - Dependencies

    private let getFavoritesUseCase: GetFavoritesUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase

    // MARK: - Init

    nonisolated init(
        getFavoritesUseCase: GetFavoritesUseCase,
        removeFavoriteUseCase: RemoveFavoriteUseCase
    ) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
    }

    // MARK: - Methods

    /// Loads all favorites.
    func loadFavorites() async {
        isLoading = true
        error = nil

        do {
            favorites = try await getFavoritesUseCase.execute()
        } catch {
            self.error = error
        }

        isLoading = false
    }

    /// Removes a game from favorites.
    func removeFavorite(gameId: Int) async {
        do {
            try await removeFavoriteUseCase.execute(gameId: gameId)
            favorites.removeAll { $0.id == gameId }
        } catch {
            self.error = error
        }
    }
}
