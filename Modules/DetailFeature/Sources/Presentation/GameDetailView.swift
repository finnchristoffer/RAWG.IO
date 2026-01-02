import SwiftUI
import Common
import Core
import CoreUI

/// Game detail view with premium design.
struct GameDetailView: View {
    @StateObject private var viewModel: GameDetailViewModel
    @State private var isShareSheetPresented = false
    
    private let gameId: Int
    private let gameName: String
    private let backgroundImageURL: URL?
    
    init(
        gameId: Int,
        gameName: String,
        backgroundImageURL: URL? = nil,
        getGameDetailUseCase: GetGameDetailUseCaseProtocol?,
        addFavoriteUseCase: AddFavoriteUseCaseProtocol?,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol?,
        isFavoriteUseCase: IsFavoriteUseCaseProtocol?
    ) {
        self.gameId = gameId
        self.gameName = gameName
        self.backgroundImageURL = backgroundImageURL
        _viewModel = StateObject(wrappedValue: GameDetailViewModel(
            gameId: gameId,
            gameName: gameName,
            backgroundImageURL: backgroundImageURL,
            getGameDetailUseCase: getGameDetailUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase
        ))
    }
    
    /// Internal initializer for previews with mock ViewModel.
    internal init(viewModel: GameDetailViewModel) {
        self.gameId = viewModel.gameId
        self.gameName = viewModel.gameName
        self.backgroundImageURL = viewModel.backgroundImageURL
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                
                VStack(spacing: 24) {
                    titleSection
                    statsSection
                    descriptionSection
                    actionSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(edges: .top)
        .background(ColorTokens.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheetView(
                shareItem: ShareItem(
                    gameName: viewModel.gameName,
                    gameId: viewModel.gameId
                )
            ) {
                isShareSheetPresented = false
            }
        }
        .task {
            await viewModel.loadDetails()
        }
    }
    
    // MARK: - Hero Section
    
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            if let imageURL = viewModel.backgroundImageURL {
                GameImageView(url: imageURL)
                    .aspectRatio(16.0 / 9.0, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [
                                .black.opacity(0.3),
                                .clear,
                                ColorTokens.background.opacity(0.5),
                                ColorTokens.background
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            } else {
                LinearGradient(
                    colors: [
                        ColorTokens.primary.opacity(0.8),
                        ColorTokens.primary.opacity(0.4),
                        ColorTokens.background
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                
                VStack {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Title Section
    
    private var titleSection: some View {
        VStack(spacing: 8) {
            Text(viewModel.gameName)
                .font(Typography.title)
                .foregroundStyle(ColorTokens.textPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            if let metacritic = viewModel.metacritic {
                Text("Metacritic: \(metacritic)")
                    .font(Typography.caption)
                    .foregroundStyle(ColorTokens.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Stats Section
    
    private var statsSection: some View {
        HStack(spacing: 0) {
            statItem(value: viewModel.ratingString, label: "Rating", icon: "star.fill")
            
            Divider()
                .frame(height: 40)
            
            statItem(value: viewModel.releaseYear, label: "Release", icon: "calendar")
            
            Divider()
                .frame(height: 40)
            
            statItem(value: viewModel.primaryPlatform, label: "Platform", icon: "desktopcomputer")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(ColorTokens.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(ColorTokens.primary)
            
            Text(value)
                .font(Typography.headline)
                .foregroundStyle(ColorTokens.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            
            Text(label)
                .font(Typography.caption)
                .foregroundStyle(ColorTokens.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Description Section
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(Typography.headline)
                .foregroundStyle(ColorTokens.textPrimary)
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else if let description = viewModel.descriptionText, !description.isEmpty {
                Text(description)
                    .font(Typography.body)
                    .foregroundStyle(ColorTokens.textSecondary)
                    .lineSpacing(4)
            } else {
                Text("No description available.")
                    .font(Typography.body)
                    .foregroundStyle(ColorTokens.textSecondary)
                    .italic()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(ColorTokens.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Action Section
    
    private var actionSection: some View {
        HStack(spacing: 16) {
            Button {
                Task {
                    await viewModel.toggleFavorite()
                }
            } label: {
                HStack {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    Text(viewModel.isFavorite ? "Favorited" : "Favorite")
                }
                .font(Typography.body)
                .foregroundStyle(viewModel.isFavorite ? .white : ColorTokens.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(viewModel.isFavorite ? ColorTokens.primary : ColorTokens.primary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .animation(.easeInOut(duration: 0.2), value: viewModel.isFavorite)
            }
            
            Button {
                isShareSheetPresented = true
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .font(Typography.body)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(ColorTokens.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Game Detail - With Data") {
    let mockViewModel = GameDetailViewModel(
        gameId: 3498,
        gameName: "Grand Theft Auto V",
        backgroundImageURL: URL(string: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg"),
        rating: 4.47,
        released: "2013-09-17",
        platforms: ["PlayStation 5", "Xbox Series S/X", "PC"],
        descriptionText: "Rockstar Games went bigger since their previous installment of the series.",
        metacritic: 92,
        isPreview: true
    )

    return NavigationStack {
        GameDetailView(viewModel: mockViewModel)
    }
}

#Preview("Game Detail - No Image") {
    let mockViewModel = GameDetailViewModel(
        gameId: 123,
        gameName: "Sample Game",
        rating: 3.5,
        released: "2024-01-01",
        platforms: ["PC"],
        descriptionText: "This is a sample game description for testing the preview layout.",
        isPreview: true
    )

    return NavigationStack {
        GameDetailView(viewModel: mockViewModel)
    }
}
#endif
