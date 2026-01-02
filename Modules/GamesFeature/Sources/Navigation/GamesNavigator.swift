import SwiftUI
import Factory
import Common

/// Public entry point for GamesFeature module.
///
/// This is the only public API exposed by the module.
/// Internal views, view models, and use cases are not accessible outside.
public struct GamesNavigator {
    public init() {}

    /// Creates the root view for the Games tab.
    @MainActor
    public func navigateToGameList() -> some View {
        let viewModel = Container.shared.gamesViewModel()
        return GamesListView(viewModel: viewModel)
    }

    /// Returns the GetGameDetailUseCase for cross-feature use.
    /// This allows other features to access game details without depending on GamesFeature directly.
    public func getGameDetailUseCase() -> GetGameDetailUseCaseProtocol {
        Container.shared.getGameDetailUseCase()
    }
}
