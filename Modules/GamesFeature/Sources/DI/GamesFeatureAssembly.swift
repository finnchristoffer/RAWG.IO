import Foundation
import Factory
import Common

// MARK: - GamesFeature Module DI Assembly

extension Container {
    // MARK: - UseCases (internal)

    /// GetGamesUseCase for fetching games list.
    var getGamesUseCase: Factory<GetGamesUseCase> {
        self { GetGamesUseCase(repository: self.gamesRepository()) }
    }

    /// GetGameDetailUseCase for fetching game details.
    var getGameDetailUseCase: Factory<GetGameDetailUseCase> {
        self { GetGameDetailUseCase(repository: self.gamesRepository()) }
    }

    // MARK: - ViewModels (internal)

    /// GamesViewModel for games list screen.
    @MainActor
    var gamesViewModel: Factory<GamesViewModel> {
        self { GamesViewModel(getGamesUseCase: self.getGamesUseCase()) }
    }
}
