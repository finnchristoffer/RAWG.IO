import SwiftUI
import Combine
import Common

/// ViewModel for the Games list screen.
@MainActor
public final class GamesViewModel: ObservableObject {
    // MARK: - Published State

    @Published public private(set) var games: [Game] = []
    @Published public private(set) var isLoading = false
    @Published public private(set) var error: Error?
    @Published public private(set) var hasMorePages = true

    // MARK: - Private

    private let repository: GamesRepositoryProtocol
    private var currentPage = 1
    private var isLoadingMore = false

    // MARK: - Init

    public init(repository: GamesRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    /// Load the initial page of games.
    public func loadGames() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        currentPage = 1

        do {
            let input = GamesInput(page: 1)
            let response = try await repository.getGames(input)
            games = response.results
            hasMorePages = response.next != nil
            currentPage = 1
        } catch {
            self.error = error
        }

        isLoading = false
    }

    /// Load the next page of games (pagination).
    public func loadMoreIfNeeded(currentItem: Game?) async {
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
            let response = try await repository.getGames(input)
            games.append(contentsOf: response.results)
            hasMorePages = response.next != nil
            currentPage = nextPage
        } catch {
            // Silent fail for pagination errors
            print("Pagination error: \(error)")
        }

        isLoadingMore = false
    }

    /// Refresh the games list (pull-to-refresh).
    public func refresh() async {
        await loadGames()
    }
}
