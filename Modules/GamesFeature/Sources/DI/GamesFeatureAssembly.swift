import Foundation
import Factory
import Common

// MARK: - GamesFeature Module DI Assembly
// All factories are internal - only GamesNavigator is public.

extension Container {
    // MARK: - UseCases (Internal)

    /// GetGameDetailUseCase for fetching game details - returns protocol type.
    var getGameDetailUseCase: Factory<GetGameDetailUseCaseProtocol> {
        self { GetGameDetailUseCase(repository: self.gamesRepository()) as GetGameDetailUseCaseProtocol }
    }

    /// GetGamesUseCase for fetching games list.
    var getGamesUseCase: Factory<GetGamesUseCase> {
        self { GetGamesUseCase(repository: self.gamesRepository()) }
    }

    // MARK: - ViewModels (Internal)

    /// GamesViewModel for games list screen.
    @MainActor var gamesViewModel: Factory<GamesViewModel> {
        self { GamesViewModel(getGamesUseCase: self.getGamesUseCase()) }
    }
}
