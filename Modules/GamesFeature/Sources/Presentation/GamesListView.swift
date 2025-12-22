import SwiftUI
import Common
import CoreUI

/// Main view for displaying the list of games.
public struct GamesListView: View {
    @StateObject private var viewModel: GamesViewModel

    public init(viewModel: GamesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Games")
                .refreshable {
                    await viewModel.refresh()
                }
        }
        .task {
            if viewModel.games.isEmpty {
                await viewModel.loadGames()
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.games.isEmpty {
            LoadingView(message: "Loading games...")
        } else if let error = viewModel.error, viewModel.games.isEmpty {
            ErrorView(
                message: error.localizedDescription,
                retryAction: {
                    Task {
                        await viewModel.loadGames()
                    }
                }
            )
        } else {
            gamesList
        }
    }

    // MARK: - Games List

    private var gamesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.games) { game in
                    GameCard(
                        title: game.name,
                        imageURL: game.backgroundImage,
                        rating: game.rating,
                        platforms: game.platforms.map { $0.name }
                    )
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
    Text("GamesListView Preview")
}
#endif
