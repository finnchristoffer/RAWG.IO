import SwiftUI
import Factory

/// Public entry point for DetailFeature module.
public struct DetailNavigator {
    public init() {}

    /// Creates the game detail view.
    @MainActor
    public func navigateToDetail(gameId: Int, name: String) -> some View {
        GameDetailView(gameId: gameId, gameName: name)
    }
}
