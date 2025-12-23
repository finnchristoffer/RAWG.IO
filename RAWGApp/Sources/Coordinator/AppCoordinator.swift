import SwiftUI
import Common

/// Main application coordinator that manages tab state.
/// Navigation is now handled by CoreNavigation's NavigationRouter.
@MainActor
final class AppCoordinator: ObservableObject {
    // MARK: - Tab Selection
    @Published var selectedTab: Tab = .games

    // MARK: - Tab Enumeration
    enum Tab: Hashable {
        case games
        case search
        case favorites
    }

    nonisolated init() {}

    /// Switch to a specific tab.
    func switchTab(to tab: Tab) {
        selectedTab = tab
    }
}
