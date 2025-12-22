import SwiftUI
import GamesFeature

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    // Use navigator pattern - module exposes only entry point
    private let gamesNavigator = GamesNavigator()

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            gamesNavigator.rootView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller")
                }
                .tag(AppCoordinator.Tab.games)

            NavigationStack(path: $coordinator.searchPath) {
                Text("Search")
                    .navigationTitle("Search")
            }
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
