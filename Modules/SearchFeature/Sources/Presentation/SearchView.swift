import SwiftUI
import Common
import CoreUI
import CoreNavigation

/// Main view for game search.
struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @EnvironmentObject private var router: NavigationRouter
    @State private var appeared = false

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
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    appeared = true
                }
            }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        Group {
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
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.isLoading)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.games.isEmpty)
    }

    // MARK: - Error

    private var errorView: some View {
        ErrorView(
            message: viewModel.error?.localizedDescription ?? "Unknown error"
        )
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    // MARK: - Loading

    private var loadingView: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(0..<5, id: \.self) { index in
                    GameCardSkeleton()
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.8)
                                .delay(Double(index) * 0.05),
                            value: appeared
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(ColorTokens.background)
        .transition(.opacity)
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
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    // MARK: - Results List

    private var resultsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                // Results header
                resultsHeader
                    .padding(.horizontal, 16)

                // Game cards
                ForEach(Array(viewModel.games.enumerated()), id: \.element.id) { index, game in
                    GameCard(
                        title: game.name,
                        imageURL: game.backgroundImage,
                        rating: game.rating,
                        platforms: game.platforms.map { $0.name }
                    )
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.8)
                            .delay(Double(min(index, 10)) * 0.05),
                        value: appeared
                    )
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        router.navigate(to: AppRoute.gameDetail(
                            gameId: game.id,
                            name: game.name,
                            backgroundImageURL: game.backgroundImage
                        ))
                    }
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(currentItem: game)
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Loading more indicator
                if viewModel.hasMorePages && !viewModel.games.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding()
                        Spacer()
                    }
                    .transition(.opacity)
                }
            }
            .padding(.vertical, 12)
        }
        .background(ColorTokens.background)
        .transition(.opacity)
    }

    // MARK: - Results Header

    private var resultsHeader: some View {
        HStack {
            Text("Results for \"\(viewModel.searchQuery)\"")
                .font(Typography.subheadline)
                .foregroundStyle(ColorTokens.textSecondary)

            Spacer()

            Text("\(viewModel.games.count) games")
                .font(Typography.caption)
                .foregroundStyle(ColorTokens.textSecondary)
        }
        .opacity(appeared ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: appeared)
    }
}

#if DEBUG
#Preview {
    Text("SearchView Preview")
}
#endif
