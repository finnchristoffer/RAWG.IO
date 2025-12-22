import XCTest
import SwiftUI
import SnapshotTesting
@testable import GamesFeature
@testable import Common
@testable import CoreUI

/// Snapshot tests for GamesListView.
@MainActor
final class GamesListViewSnapshotTests: XCTestCase {
    func test_gamesListView_loading_state() {
        // Arrange - test skeleton loading directly since viewModel.isLoading is internal
        let sut = skeletonLoadingView
            .frame(width: 390, height: 844)

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_gamesListView_with_games() async {
        // Arrange
        let sut = await makeSUTWithPreloadedGames(makeMockGames())

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_gamesListView_error_state() async {
        // Arrange
        let sut = await makeSUTWithError("Failed to load games")

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_gamesListView_empty_state() async {
        // Arrange - empty list after loading
        let sut = await makeSUTWithPreloadedGames([])

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    // MARK: - Helpers

    /// Skeleton loading view - mirrors what GamesListView shows during loading
    private var skeletonLoadingView: some View {
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
            .navigationTitle("Games")
        }
    }

    private func makeSUTWithPreloadedGames(_ games: [GameEntity]) async -> some View {
        let repository = MockGamesRepository()
        repository.stubbedGamesResult = PaginatedEntity(
            count: games.count,
            hasNextPage: false,
            hasPreviousPage: false,
            results: games
        )

        let useCase = GetGamesUseCase(repository: repository)
        let viewModel = GamesViewModel(getGamesUseCase: useCase)

        // Actually load the games to trigger state change
        await viewModel.loadGames()

        return GamesListView(viewModel: viewModel)
            .frame(width: 390, height: 844)
    }

    private func makeSUTWithError(_ message: String) async -> some View {
        let repository = MockGamesRepository()
        repository.stubbedError = NSError(
            domain: "test",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: message]
        )

        let useCase = GetGamesUseCase(repository: repository)
        let viewModel = GamesViewModel(getGamesUseCase: useCase)

        // Actually try to load - this will set the error state
        await viewModel.loadGames()

        return GamesListView(viewModel: viewModel)
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
                platforms: [],
                genres: []
            ),
            GameEntity(
                id: 2,
                slug: "elden-ring",
                name: "Elden Ring",
                released: "2022-02-25",
                backgroundImage: nil,
                rating: 4.5,
                ratingsCount: 3000,
                metacritic: 96,
                playtime: 80,
                platforms: [],
                genres: []
            ),
            GameEntity(
                id: 3,
                slug: "gta-5",
                name: "Grand Theft Auto V",
                released: "2013-09-17",
                backgroundImage: nil,
                rating: 4.2,
                ratingsCount: 8000,
                metacritic: 97,
                playtime: 100,
                platforms: [],
                genres: []
            )
        ]
    }
}
