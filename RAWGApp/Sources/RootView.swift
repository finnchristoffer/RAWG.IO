import SwiftUI
import GamesFeature
import SearchFeature
import FavoritesFeature
import DetailFeature
import Common
import CoreNavigation

struct RootView: View {
    @StateObject private var router = NavigationRouter()

    // Use navigator pattern - module exposes only entry point
    private let gamesNavigator = GamesNavigator()
    private let searchNavigator = SearchNavigator()
    private let favoritesNavigator = FavoritesNavigator()

    @State private var selectedTab: Tab = .games
    @State private var gamesPath = NavigationPath()
    @State private var searchPath = NavigationPath()
    @State private var favoritesPath = NavigationPath()

    enum Tab {
        case games, search, favorites
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $router.path) {
                gamesNavigator.navigateToGameList()
                    .navigationDestination(for: AnyRoute.self) { route in
                        route.buildView()
                    }
            }
            .environmentObject(router)
            .tabItem {
                Label("Games", systemImage: "gamecontroller")
            }
            .tag(Tab.games)

            NavigationStack(path: $router.path) {
                searchNavigator.navigateToSearch()
                    .navigationDestination(for: AnyRoute.self) { route in
                        route.buildView()
                    }
            }
            .environmentObject(router)
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)

            NavigationStack(path: $router.path) {
                favoritesNavigator.navigateToFavorites()
                    .navigationDestination(for: AnyRoute.self) { route in
                        route.buildView()
                    }
            }
            .environmentObject(router)
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            .tag(Tab.favorites)
        }
        .onAppear {
            registerRoutes()
        }
    }

    /// Register route resolvers.
    private func registerRoutes() {
        RouteRegistry.shared.register(AppRoute.self) { route in
            switch route {
            case .gameDetail(let gameId, let name):
                AnyView(DetailNavigator().navigateToDetail(gameId: gameId, name: name))
            case .favorites:
                AnyView(favoritesNavigator.navigateToFavorites())
            case .search:
                AnyView(searchNavigator.navigateToSearch())
            }
        }
    }
}

#Preview {
    RootView()
}
