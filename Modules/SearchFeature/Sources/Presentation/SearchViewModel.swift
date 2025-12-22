import SwiftUI
import Combine
import Common
import Factory

/// ViewModel for the Search screen.
@MainActor
final class SearchViewModel: ObservableObject {
    // MARK: - Published State

    @Published var searchQuery: String = ""
    @Published private(set) var games: [GameEntity] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var hasMorePages = true

    // MARK: - Private

    private let searchGamesUseCase: SearchGamesUseCase
    private var currentPage = 1
    private var isLoadingMore = false
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    nonisolated init(searchGamesUseCase: SearchGamesUseCase) {
        self.searchGamesUseCase = searchGamesUseCase
        Task { @MainActor in
            setupDebounce()
        }
    }

    // MARK: - Setup

    private func setupDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                Task {
                    await self.performSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Methods

    /// Performs search with the given query.
    private func performSearch(query: String) async {
        // Clear results if query is empty
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            games = []
            error = nil
            hasMorePages = true
            currentPage = 1
            return
        }

        isLoading = true
        error = nil
        currentPage = 1

        do {
            let input = SearchGamesInput(query: query, page: 1)
            let response = try await searchGamesUseCase.execute(input)
            games = response.results
            hasMorePages = response.hasNextPage
        } catch {
            self.error = error
            games = []
        }

        isLoading = false
    }

    /// Load more results for pagination.
    func loadMoreIfNeeded(currentItem: GameEntity) async {
        // Check if we're near the end
        guard let lastItem = games.last,
              lastItem.id == currentItem.id,
              hasMorePages,
              !isLoadingMore,
              !searchQuery.isEmpty else {
            return
        }

        isLoadingMore = true

        do {
            let nextPage = currentPage + 1
            let input = SearchGamesInput(query: searchQuery, page: nextPage)
            let response = try await searchGamesUseCase.execute(input)
            games.append(contentsOf: response.results)
            hasMorePages = response.hasNextPage
            currentPage = nextPage
        } catch {
            // Silent fail for pagination
        }

        isLoadingMore = false
    }

    /// Clear search results.
    func clearSearch() {
        searchQuery = ""
        games = []
        error = nil
        hasMorePages = true
        currentPage = 1
    }
}
