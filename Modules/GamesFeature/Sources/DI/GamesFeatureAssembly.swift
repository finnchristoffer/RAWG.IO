import Foundation
import Factory
import Common

// MARK: - GamesFeature Module DI Assembly

public extension Container {
    // MARK: - UseCases

    /// GetGamesUseCase for fetching games list.
    var getGamesUseCase: Factory<GetGamesUseCase> {
        self { GetGamesUseCase(repository: self.gamesRepository()) }
    }

    /// GetGameDetailUseCase for fetching game details.
    var getGameDetailUseCase: Factory<GetGameDetailUseCase> {
        self { GetGameDetailUseCase(repository: self.gamesRepository()) }
    }

    // MARK: - ViewModels

    /// GamesViewModel for games list screen.
    var gamesViewModel: Factory<GamesViewModel> {
        self { GamesViewModel(getGamesUseCase: self.getGamesUseCase()) }
    }
}
