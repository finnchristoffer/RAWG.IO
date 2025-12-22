import Foundation
import Factory
import Common

// MARK: - SearchFeature Module DI Assembly

extension Container {
    // MARK: - UseCases

    /// SearchGamesUseCase for searching games.
    var searchGamesUseCase: Factory<SearchGamesUseCase> {
        self { SearchGamesUseCase(repository: self.gamesRepository()) }
    }

    // MARK: - ViewModels

    /// SearchViewModel for search screen.
    @MainActor var searchViewModel: Factory<SearchViewModel> {
        self { SearchViewModel(searchGamesUseCase: self.searchGamesUseCase()) }
    }
}
