import SwiftUI
import Common
import CoreUI

/// Game detail view with premium design.
public struct GameDetailView: View {
    @StateObject private var viewModel: GameDetailViewModel

    public init(gameId: Int, gameName: String, backgroundImageURL: URL? = nil) {
        _viewModel = StateObject(wrappedValue: GameDetailViewModel(
            gameId: gameId,
            gameName: gameName,
            backgroundImageURL: backgroundImageURL
        ))
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image Section
                heroSection

                // Content Section
                VStack(spacing: 24) {
                    // Game Title
                    titleSection

                    // Quick Stats
                    statsSection

                    // Description Placeholder
                    descriptionSection

                    // Action Buttons
                    actionSection
                }
                .padding(20)
            }
        }
        .background(ColorTokens.background)
        .navigationTitle("Game Detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            if let imageURL = viewModel.backgroundImageURL {
                // RAWG Background Image
                GameImageView(url: imageURL)
                    .aspectRatio(16/9, contentMode: .fill)
                    .frame(height: 280)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [
                                .clear,
                                ColorTokens.background.opacity(0.5),
                                ColorTokens.background
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            } else {
                // Fallback Gradient
                LinearGradient(
                    colors: [
                        ColorTokens.primary.opacity(0.8),
                        ColorTokens.primary.opacity(0.4),
                        ColorTokens.background
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 280)

                // Game Icon
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
    }

    // MARK: - Title Section

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text(viewModel.gameName)
                .font(Typography.title)
                .foregroundStyle(ColorTokens.textPrimary)
                .multilineTextAlignment(.center)

            Text("ID: \(viewModel.gameId)")
                .font(Typography.caption)
                .foregroundStyle(ColorTokens.textSecondary)
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        HStack(spacing: 0) {
            statItem(value: "4.5", label: "Rating", icon: "star.fill")
            Divider()
                .frame(height: 40)
            statItem(value: "2023", label: "Release", icon: "calendar")
            Divider()
                .frame(height: 40)
            statItem(value: "PC", label: "Platform", icon: "desktopcomputer")
        }
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

            Text(label)
                .font(Typography.caption)
                .foregroundStyle(ColorTokens.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Description Section

    private var descriptionPlaceholder: String {
        """
        Game details will be loaded here. This is a placeholder for the \
        game description that will include information about gameplay, \
        story, and features.
        """
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(Typography.headline)
                .foregroundStyle(ColorTokens.textPrimary)

            Text(descriptionPlaceholder)
                .font(Typography.body)
                .foregroundStyle(ColorTokens.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(ColorTokens.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Action Section

    private var actionSection: some View {
        HStack(spacing: 16) {
            // Add to Favorites Button
            Button {
                // Future: Add to favorites
            } label: {
                HStack {
                    Image(systemName: "heart")
                    Text("Favorite")
                }
                .font(Typography.body)
                .foregroundStyle(ColorTokens.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(ColorTokens.primary.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Share Button
            Button {
                // Future: Share game
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

#if DEBUG
#Preview {
    NavigationStack {
        GameDetailView(
            gameId: 123,
            gameName: "The Witcher 3: Wild Hunt",
            backgroundImageURL: URL(string: "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6f6571.jpg")
        )
    }
}
#endif
