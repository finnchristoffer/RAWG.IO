import SwiftUI
import SwiftData
import Core
import CoreUI
import CoreNetwork
import GamesFeature
import SearchFeature
import FavoritesFeature

@main
struct RAWGApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
        .modelContainer(for: FavoriteGameModel.self)
    }
}
