import SwiftUI

/// Main application coordinator that manages navigation across all features.
/// Uses NavigationStack and NavigationPath for type-safe, decoupled navigation.
@MainActor
final class AppCoordinator: ObservableObject {
    // MARK: - Tab Selection
    @Published var selectedTab: Tab = .games
    
    // MARK: - Navigation Paths (one per tab to maintain state)
    @Published var gamesPath = NavigationPath()
    @Published var searchPath = NavigationPath()
    @Published var favoritesPath = NavigationPath()
    
    // MARK: - Tab Enumeration
    enum Tab: Hashable {
        case games
        case search
        case favorites
    }
    
    // MARK: - Navigation Methods
    
    /// Navigate to a destination within the current tab
    func navigate<T: Hashable>(to destination: T) {
        switch selectedTab {
        case .games:
            gamesPath.append(destination)
        case .search:
            searchPath.append(destination)
        case .favorites:
            favoritesPath.append(destination)
        }
    }
    
    /// Pop to root of current tab
    func popToRoot() {
        switch selectedTab {
        case .games:
            gamesPath.removeLast(gamesPath.count)
        case .search:
            searchPath.removeLast(searchPath.count)
        case .favorites:
            favoritesPath.removeLast(favoritesPath.count)
        }
    }
    
    /// Switch to a specific tab
    func switchTab(to tab: Tab) {
        selectedTab = tab
    }
}
