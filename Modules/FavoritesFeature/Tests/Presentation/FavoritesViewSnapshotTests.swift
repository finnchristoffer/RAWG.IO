import XCTest
import SwiftUI
import SnapshotTesting
@testable import FavoritesFeature
@testable import Common
@testable import CoreUI

/// Snapshot tests for FavoritesView.
@MainActor
final class FavoritesViewSnapshotTests: XCTestCase {
    func test_favoritesView_empty_state() {
        // Arrange
        let sut = makeEmptyStateView()

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_favoritesView_loading_state() {
        // Arrange
        let sut = makeLoadingView()

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_favoritesView_with_favorites() {
        // Arrange
        let sut = makeFavoritesListView(games: makeMockGames())

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    // MARK: - Helpers

    private func makeEmptyStateView() -> some View {
        NavigationStack {
            EmptyStateView(
                title: "No Favorites",
                message: "Games you add to favorites will appear here.",
                systemImage: "heart"
            )
            .navigationTitle("Favorites")
        }
        .frame(width: 390, height: 844)
    }

    private func makeLoadingView() -> some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { _ in
                        GameCardSkeleton()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(ColorTokens.background)
            .navigationTitle("Favorites")
        }
        .frame(width: 390, height: 844)
    }

    private func makeFavoritesListView(games: [GameEntity]) -> some View {
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
            .navigationTitle("Favorites")
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
            )
        ]
    }
}
