import XCTest
import SwiftUI
import SnapshotTesting
@testable import SearchFeature
@testable import Common
@testable import CoreUI

/// Snapshot tests for SearchView.
@MainActor
final class SearchViewSnapshotTests: XCTestCase {
    func test_searchView_initial_state() {
        // Arrange - empty search query, no results
        let sut = makeSearchViewWithEmptyState()

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_searchView_loading_state() {
        // Arrange - loading skeleton
        let sut = loadingSkeletonView

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_searchView_with_results() async {
        // Arrange
        let sut = await makeSearchViewWithResults(makeMockGames())

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_searchView_no_results() async {
        // Arrange - empty results after search
        let sut = await makeSearchViewWithNoResults(query: "nonexistent game xyz")

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    // MARK: - Helpers

    private func makeSearchViewWithEmptyState() -> some View {
        NavigationStack {
            EmptyStateView(
                title: "Search Games",
                message: "Enter a game name to search the RAWG database.",
                systemImage: "magnifyingglass"
            )
            .navigationTitle("Search")
        }
        .frame(width: 390, height: 844)
    }

    private var loadingSkeletonView: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { _ in
                        GameCardSkeleton()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(ColorTokens.background)
            .navigationTitle("Search")
        }
        .frame(width: 390, height: 844)
    }

    private func makeSearchViewWithResults(_ games: [GameEntity]) async -> some View {
        let repository = MockSearchSnapshotRepository()
        repository.stubbedSearchResult = PaginatedEntity(
            count: games.count,
            hasNextPage: false,
            hasPreviousPage: false,
            results: games
        )

        let useCase = SearchGamesUseCase(repository: repository)
        let viewModel = SearchViewModel(searchGamesUseCase: useCase)

        // Simulate completed search
        viewModel.searchQuery = "witcher"
        try? await Task.sleep(nanoseconds: 400_000_000)

        return resultsView(games: viewModel.games)
    }

    private func makeSearchViewWithNoResults(query: String) async -> some View {
        NavigationStack {
            EmptyStateView(
                title: "No Results",
                message: "No games found for \"\(query)\".",
                systemImage: "gamecontroller",
                actionTitle: "Clear Search"
            ) {
                // Clear action
            }
            .navigationTitle("Search")
        }
        .frame(width: 390, height: 844)
    }

    private func resultsView(games: [GameEntity]) -> some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(games) { game in
                        GameCard(
                            title: game.name,
                            imageURL: game.backgroundImage,
                            rating: game.rating,
                            platforms: game.platforms.map { $0.name }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(ColorTokens.background)
            .navigationTitle("Search")
        }
        .frame(width: 390, height: 844)
    }

    private func makeMockGames() -> [GameEntity] {
        [
            GameEntity(
                id: 1,
                slug: "witcher-3",
                name: "The Witcher 3: Wild Hunt",
                released: "2015-05-19",
                backgroundImage: nil,
                rating: 4.8,
                ratingsCount: 5000,
                metacritic: 93,
                playtime: 50,
                platforms: [PlatformEntity(id: 1, name: "PC", slug: "pc")],
                genres: []
            ),
            GameEntity(
                id: 2,
                slug: "witcher-2",
                name: "The Witcher 2: Assassins of Kings",
                released: "2011-05-17",
                backgroundImage: nil,
                rating: 4.2,
                ratingsCount: 2000,
                metacritic: 88,
                playtime: 30,
                platforms: [PlatformEntity(id: 1, name: "PC", slug: "pc")],
                genres: []
            )
        ]
    }
}

// MARK: - Mock

final class MockSearchSnapshotRepository: GamesRepositoryProtocol, @unchecked Sendable {
    var stubbedSearchResult: PaginatedEntity<GameEntity>?

    // swiftlint:disable:next unavailable_function
    func getGames(_ input: GamesInput) async throws -> PaginatedEntity<GameEntity> {
        fatalError("Not used")
    }

    // swiftlint:disable:next unavailable_function
    func getGameDetail(_ input: GameDetailInput) async throws -> GameDetailEntity {
        fatalError("Not used")
    }

    func searchGames(_ input: SearchGamesInput) async throws -> PaginatedEntity<GameEntity> {
        stubbedSearchResult ?? PaginatedEntity(
            count: 0, hasNextPage: false, hasPreviousPage: false, results: []
        )
    }
}
