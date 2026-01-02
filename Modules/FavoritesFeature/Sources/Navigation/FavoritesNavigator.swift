import SwiftUI
import Factory
import Common

/// Public entry point for FavoritesFeature module.
/// This is the only public API exposed by the module.
public struct FavoritesNavigator {
    public init() {}

    /// Creates the favorites view for the Favorites tab.
    @MainActor
    public func navigateToFavorites() -> some View {
        let viewModel = Container.shared.favoritesViewModel()
        return FavoritesView(viewModel: viewModel)
    }

    // MARK: - UseCase Providers (for cross-feature use)

    /// Returns AddFavoriteUseCase for cross-feature use.
    public func addFavoriteUseCase() -> AddFavoriteUseCaseProtocol {
        Container.shared.addFavoriteUseCase()
    }

    /// Returns RemoveFavoriteUseCase for cross-feature use.
    public func removeFavoriteUseCase() -> RemoveFavoriteUseCaseProtocol {
        Container.shared.removeFavoriteUseCase()
    }

    /// Returns IsFavoriteUseCase for cross-feature use.
    public func isFavoriteUseCase() -> IsFavoriteUseCaseProtocol {
        Container.shared.isFavoriteUseCase()
    }

    /// Returns GetFavoritesUseCase for cross-feature use.
    public func getFavoritesUseCase() -> GetFavoritesUseCaseProtocol {
        Container.shared.getFavoritesUseCase()
    }
}
