import SwiftUI

/// Skeleton loading placeholder for GameCard.
public struct GameCardSkeleton: View {
    @State private var isAnimating = false

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(shimmerGradient)
                .frame(height: 180)

            VStack(alignment: .leading, spacing: 8) {
                // Title placeholder
                RoundedRectangle(cornerRadius: 4)
                    .fill(shimmerGradient)
                    .frame(height: 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 40)

                // Rating placeholder
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(shimmerGradient)
                        .frame(width: 60, height: 16)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(shimmerGradient)
                        .frame(width: 80, height: 16)
                }

                // Platforms placeholder
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(shimmerGradient)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(ColorTokens.surface)
        .cornerRadius(16)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }

    private var shimmerGradient: some ShapeStyle {
        LinearGradient(
            colors: [
                ColorTokens.textSecondary.opacity(0.3),
                ColorTokens.textSecondary.opacity(0.1),
                ColorTokens.textSecondary.opacity(0.3)
            ],
            startPoint: isAnimating ? .leading : .trailing,
            endPoint: isAnimating ? .trailing : .leading
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        GameCardSkeleton()
        GameCardSkeleton()
    }
    .padding()
    .background(ColorTokens.background)
}
