import SwiftUI
import Common
import CoreUI
import CoreNavigation

/// Main view for game search.
struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @EnvironmentObject private var router: NavigationRouter

    init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .navigationTitle("Search")
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search games..."
            )
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.error != nil {
            errorView
        } else if viewModel.games.isEmpty {
            emptyStateView
        } else {
            resultsList
        }
    }

    // MARK: - Error

    private var errorView: some View {
        ErrorView(
            message: viewModel.error?.localizedDescription ?? "Unknown error"
        )
    }

    // MARK: - Loading

    private var loadingView: some View {
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
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        Group {
            if viewModel.searchQuery.isEmpty {
                EmptyStateView(
                    title: "Search Games",
                    message: "Enter a game name to search the RAWG database.",
                    systemImage: "magnifyingglass"
                )
            } else {
                EmptyStateView(
                    title: "No Results",
                    message: "No games found for \"\(viewModel.searchQuery)\".",
                    systemImage: "gamecontroller",
                    actionTitle: "Clear Search"
                ) {
                    viewModel.clearSearch()
                }
            }
        }
    }

    // MARK: - Results List

    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.games) { game in
                    GameCard(
                        title: game.name,
                        imageURL: game.backgroundImage,
                        rating: game.rating,
                        platforms: game.platforms.map { $0.name }
                    )
                    .onTapGesture {
                        router.navigate(to: AppRoute.gameDetail(gameId: game.id, name: game.name))
                    }
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(currentItem: game)
                        }
                    }
                }

                if viewModel.hasMorePages && !viewModel.games.isEmpty {
                    ProgressView()
                        .padding()
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
    Text("SearchView Preview")
}
#endif
