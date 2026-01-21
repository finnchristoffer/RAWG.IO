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

    @State private var isPressed = false

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
            VStack(alignment: .leading, spacing: 10) {
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
            .padding(14)
        }
        .background(ColorTokens.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(
            color: .black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 6
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        .onLongPressGesture(
            minimumDuration: .infinity,
            pressing: { pressing in
                isPressed = pressing
            },
            perform: {}
        )
    }

    // MARK: - Subviews

    private var ratingView: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(ColorTokens.rating(rating))

            Text(String(format: "%.1f", rating))
                .font(Typography.subheadline)
                .fontWeight(.medium)
                .foregroundColor(ColorTokens.textPrimary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(ColorTokens.rating(rating).opacity(0.15))
        )
    }

    private var platformsView: some View {
        HStack(spacing: 6) {
            ForEach(platforms.prefix(3), id: \.self) { platform in
                platformIcon(for: platform)
            }
        }
    }

    private func platformIcon(for platform: String) -> some View {
        let iconName: String
        switch platform.lowercased() {
        case let platform where platform.contains("pc") || platform.contains("windows"):
            iconName = "desktopcomputer"
        case let platform where platform.contains("playstation"):
            iconName = "gamecontroller"
        case let platform where platform.contains("xbox"):
            iconName = "xmark.circle"
        case let platform where platform.contains("nintendo") || platform.contains("switch"):
            iconName = "gamecontroller.fill"
        case let platform where platform.contains("ios") || platform.contains("iphone"):
            iconName = "iphone"
        case let platform where platform.contains("mac"):
            iconName = "laptopcomputer"
        default:
            iconName = "gamecontroller"
        }

        return Image(systemName: iconName)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(ColorTokens.textSecondary)
            .frame(width: 28, height: 28)
            .background(
                Circle()
                    .fill(ColorTokens.textSecondary.opacity(0.1))
            )
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 20) {
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
