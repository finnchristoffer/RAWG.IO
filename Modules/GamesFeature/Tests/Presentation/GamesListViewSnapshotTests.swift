import XCTest
import SwiftUI
import SnapshotTesting
@testable import GamesFeature
@testable import Common

/// Snapshot tests for GamesListView.
@MainActor
final class GamesListViewSnapshotTests: XCTestCase {
    func test_gamesListView_loading_state() {
        // Arrange
        let sut = makeSUT(state: .loading)

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_gamesListView_with_games() {
        // Arrange
        let sut = makeSUT(state: .loaded(games: makeMockGames()))

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_gamesListView_error_state() {
        // Arrange
        let sut = makeSUT(state: .error("Failed to load games"))

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_gamesListView_empty_state() {
        // Arrange
        let sut = makeSUT(state: .loaded(games: []))

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    // MARK: - Helpers

    private enum ViewState {
        case loading
        case loaded(games: [GameEntity])
        case error(String)
    }

    private func makeSUT(state: ViewState) -> some View {
        let repository = MockGamesRepository()
        let useCase = GetGamesUseCase(repository: repository)
        let viewModel = GamesViewModel(getGamesUseCase: useCase)

        // Configure state
        switch state {
        case .loading:
            // Default state is not loading until loadGames is called
            break
        case .loaded(let games):
            repository.stubbedGamesResult = PaginatedEntity(
                count: games.count,
                hasNextPage: false,
                hasPreviousPage: false,
                results: games
            )
        case .error(let message):
            repository.stubbedError = NSError(
                domain: "test",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: message]
            )
        }

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
