import SwiftUI

/// Skeleton loading placeholder for GameCard.
public struct GameCardSkeleton: View {
    @State private var shimmerOffset: CGFloat = -300

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 0)
                .fill(ColorTokens.textSecondary.opacity(0.15))
                .frame(height: 180)
                .overlay(shimmerOverlay)
                .clipped()

            VStack(alignment: .leading, spacing: 12) {
                // Title placeholder
                RoundedRectangle(cornerRadius: 6)
                    .fill(ColorTokens.textSecondary.opacity(0.15))
                    .frame(height: 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 40)
                    .overlay(shimmerOverlay)

                // Rating and platforms row
                HStack(spacing: 12) {
                    // Rating placeholder
                    Capsule()
                        .fill(ColorTokens.textSecondary.opacity(0.15))
                        .frame(width: 70, height: 28)
                        .overlay(shimmerOverlay)

                    Spacer()

                    // Platforms placeholder
                    HStack(spacing: 6) {
                        ForEach(0..<3, id: \.self) { _ in
                            Circle()
                                .fill(ColorTokens.textSecondary.opacity(0.15))
                                .frame(width: 28, height: 28)
                                .overlay(shimmerOverlay)
                        }
                    }
                }
            }
            .padding(14)
        }
        .background(ColorTokens.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 4
        )
        .onAppear {
            withAnimation(
                .linear(duration: 1.2)
                .repeatForever(autoreverses: false)
            ) {
                shimmerOffset = 300
            }
        }
    }

    private var shimmerOverlay: some View {
        LinearGradient(
            colors: [
                .clear,
                .white.opacity(0.4),
                .clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: 100)
        .offset(x: shimmerOffset)
        .clipped()
    }
}

#Preview {
    VStack(spacing: 20) {
        GameCardSkeleton()
        GameCardSkeleton()
    }
    .padding()
    .background(ColorTokens.background)
}
