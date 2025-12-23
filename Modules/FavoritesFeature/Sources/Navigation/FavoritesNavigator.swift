import SwiftUI
import Factory

/// Public entry point for FavoritesFeature module.
public struct FavoritesNavigator {
    public init() {}

    /// Creates the favorites view for the Favorites tab.
    @MainActor
    public func navigateToFavorites() -> some View {
        let viewModel = Container.shared.favoritesViewModel()
        return FavoritesView(viewModel: viewModel)
    }
}
