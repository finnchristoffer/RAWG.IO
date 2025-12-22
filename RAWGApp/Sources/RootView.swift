import SwiftUI
import Common
import CoreNetwork
import GamesFeature

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.gamesPath) {
                GamesListView(viewModel: makeGamesViewModel())
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

    // MARK: - Factory

    private func makeGamesViewModel() -> GamesViewModel {
        let client = APIClient(
            baseURL: URL(string: "https://api.rawg.io/api")!
        )
        let repository = GamesRepository(client: client)
        return GamesViewModel(repository: repository)
    }
}

#Preview {
    RootView()
        .environmentObject(AppCoordinator())
}
