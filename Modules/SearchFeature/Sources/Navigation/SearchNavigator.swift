import SwiftUI
import Factory

/// Public entry point for SearchFeature module.
///
/// This is the only public API exposed by the module.
/// Internal views and view models are not accessible outside.
public struct SearchNavigator {
    public init() {}

    /// Creates the search view for the Search tab.
    @MainActor
    public func navigateToSearch() -> some View {
        let viewModel = Container.shared.searchViewModel()
        return SearchView(viewModel: viewModel)
    }
}
