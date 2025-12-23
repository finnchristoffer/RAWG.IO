import SwiftUI
import GamesFeature
import SearchFeature

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    // Use navigator pattern - module exposes only entry point
    private let gamesNavigator = GamesNavigator()
    private let searchNavigator = SearchNavigator()
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            gamesNavigator.navigateToGameList()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller")
                }
                .tag(AppCoordinator.Tab.games)
            
            searchNavigator.navigateToSearch()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(AppCoordinator.Tab.search)
            
            NavigationStack(path: $coordinator.favoritesPath) {
                Text("Favorites")
                    .navigationTitle("Favorites")
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            .tag(AppCoordinator.Tab.favorites)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppCoordinator())
}
