import SwiftUI
import Combine
import Common
import Factory
import Core

/// ViewModel for the Games list screen.
@MainActor
final class GamesViewModel: ObservableObject {
    // MARK: - Published State

    @Published private(set) var games: [GameEntity] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var hasMorePages = true

    // MARK: - Private

    private let getGamesUseCase: GetGamesUseCase
    private var currentPage = 1
    private var isLoadingMore = false

    // MARK: - UseCase

    nonisolated init(getGamesUseCase: GetGamesUseCase) {
        self.getGamesUseCase = getGamesUseCase
    }

    // MARK: - Methods

    /// Load the initial page of games.
    func loadGames() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        currentPage = 1

        do {
            let input = GamesInput(page: 1)
            let response = try await getGamesUseCase.execute(input)
            games = response.results
            hasMorePages = response.hasNextPage
            currentPage = 1
        } catch {
            self.error = error
        }

        isLoading = false
    }

    /// Load the next page of games (pagination).
     func loadMoreIfNeeded(currentItem: GameEntity?) async {
        guard let currentItem else { return }
        guard !isLoadingMore, hasMorePages else { return }

        // Check if we're near the end of the list
        let thresholdIndex = games.index(games.endIndex, offsetBy: -3, limitedBy: games.startIndex) ?? games.startIndex
        guard let itemIndex = games.firstIndex(where: { $0.id == currentItem.id }),
              itemIndex >= thresholdIndex else {
            return
        }

        isLoadingMore = true

        do {
            let nextPage = currentPage + 1
            let input = GamesInput(page: nextPage)
            let response = try await getGamesUseCase.execute(input)
            games.append(contentsOf: response.results)
            hasMorePages = response.hasNextPage
            currentPage = nextPage
        } catch {
            // Silent fail for pagination errors
            Logger.error("Pagination error: \(error)")
        }

        isLoadingMore = false
    }

    /// Refresh the games list (pull-to-refresh).
     func refresh() async {
        await loadGames()
    }
}
