import SwiftUI

/// Card view for displaying game information.
///
/// ## Usage
/// ```swift
/// GameCard(
///     title: "The Witcher 3",
///     imageURL: URL(string: "..."),
///     rating: 4.5,
///     platforms: ["PC", "PlayStation", "Xbox"]
/// )
/// ```
public struct GameCard: View {
    private let title: String
    private let imageURL: URL?
    private let rating: Double
    private let platforms: [String]

    public init(
        title: String,
        imageURL: URL?,
        rating: Double,
        platforms: [String] = []
    ) {
        self.title = title
        self.imageURL = imageURL
        self.rating = rating
        self.platforms = platforms
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            GameImageView(url: imageURL)
                .aspectRatio(16 / 9, contentMode: .fill)
                .frame(height: 180)
                .clipped()

            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(title)
                    .font(Typography.headline)
                    .foregroundColor(ColorTokens.textPrimary)
                    .lineLimit(2)

                HStack {
                    // Rating
                    ratingView

                    Spacer()

                    // Platforms
                    if !platforms.isEmpty {
                        platformsView
                    }
                }
            }
            .padding(12)
        }
        .background(ColorTokens.surface)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    // MARK: - Subviews

    private var ratingView: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundColor(ColorTokens.rating(rating))

            Text(String(format: "%.1f", rating))
                .font(Typography.caption)
                .foregroundColor(ColorTokens.textSecondary)
        }
    }

    private var platformsView: some View {
        HStack(spacing: 4) {
            ForEach(platforms.prefix(3), id: \.self) { platform in
                platformIcon(for: platform)
            }
        }
    }

    private func platformIcon(for platform: String) -> some View {
        let iconName: String
        switch platform.lowercased() {
        case let p where p.contains("pc") || p.contains("windows"):
            iconName = "desktopcomputer"
        case let p where p.contains("playstation"):
            iconName = "gamecontroller"
        case let p where p.contains("xbox"):
            iconName = "xmark.circle"
        case let p where p.contains("nintendo") || p.contains("switch"):
            iconName = "gamecontroller.fill"
        case let p where p.contains("ios") || p.contains("iphone"):
            iconName = "iphone"
        case let p where p.contains("mac"):
            iconName = "laptopcomputer"
        default:
            iconName = "gamecontroller"
        }

        return Image(systemName: iconName)
            .font(.caption2)
            .foregroundColor(ColorTokens.textSecondary)
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            GameCard(
                title: "The Witcher 3: Wild Hunt",
                imageURL: nil,
                rating: 4.5,
                platforms: ["PC", "PlayStation", "Xbox"]
            )

            GameCard(
                title: "Elden Ring",
                imageURL: nil,
                rating: 4.8,
                platforms: ["PC", "PlayStation"]
            )
        }
        .padding()
    }
    .background(ColorTokens.background)
}
#endif
