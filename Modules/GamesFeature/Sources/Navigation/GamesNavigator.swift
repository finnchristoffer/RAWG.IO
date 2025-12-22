import SwiftUI
import Factory

/// Public entry point for GamesFeature module.
///
/// This is the only public API exposed by the module.
/// Internal views and view models are not accessible outside.
public struct GamesNavigator {
    public init() {}

    /// Creates the root view for the Games tab.
    @MainActor
    public func navigateToGameList() -> some View {
        let viewModel = Container.shared.gamesViewModel()
        return GamesListView(viewModel: viewModel)
    }
}
