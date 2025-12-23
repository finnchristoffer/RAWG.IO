import SwiftUI
import Common
import CoreUI

/// View displaying favorite games.
struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Favorites")
                .task {
                    await viewModel.loadFavorites()
                }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.error != nil {
            errorView
        } else if viewModel.favorites.isEmpty {
            emptyStateView
        } else {
            favoritesList
        }
    }

    // MARK: - Loading

    private var loadingView: some View {
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
    }

    // MARK: - Error

    private var errorView: some View {
        ErrorView(
            message: viewModel.error?.localizedDescription ?? "Unknown error"
        )
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        EmptyStateView(
            title: "No Favorites",
            message: "Games you add to favorites will appear here.",
            systemImage: "heart"
        )
    }

    // MARK: - Favorites List

    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favorites) { game in
                    GameCard(
                        title: game.name,
                        imageURL: game.backgroundImage,
                        rating: game.rating,
                        platforms: game.platforms.map { $0.name }
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.removeFavorite(gameId: game.id)
                            }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(ColorTokens.background)
    }
}

#if DEBUG
#Preview {
    Text("FavoritesView Preview")
}
#endif
