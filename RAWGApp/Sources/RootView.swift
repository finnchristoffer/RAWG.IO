import SwiftUI

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.gamesPath) {
                Text("Games")
                    .navigationTitle("Games")
            }
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
