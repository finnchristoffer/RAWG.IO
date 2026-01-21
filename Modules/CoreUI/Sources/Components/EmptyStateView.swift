import SwiftUI

/// View displayed when a list is empty.
public struct EmptyStateView: View {
    private let title: String
    private let message: String
    private let systemImage: String
    private let action: (() -> Void)?
    private let actionTitle: String?

    @State private var appeared = false

    public init(
        title: String = "No Results",
        message: String = "Nothing to show here.",
        systemImage: String = "tray",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Icon with bounce animation
            Image(systemName: systemImage)
                .font(.system(size: 72, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [ColorTokens.textSecondary, ColorTokens.textSecondary.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(appeared ? 1 : 0.5)
                .opacity(appeared ? 1 : 0)

            VStack(spacing: 10) {
                Text(title)
                    .font(Typography.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(ColorTokens.textPrimary)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)

                Text(message)
                    .font(Typography.body)
                    .foregroundStyle(ColorTokens.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
            }

            if let action, let actionTitle {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    action()
                }, label: {
                    Text(actionTitle)
                        .font(Typography.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(ColorTokens.accent)
                        )
                        .shadow(color: ColorTokens.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                })
                .scaleEffect(appeared ? 1 : 0.8)
                .opacity(appeared ? 1 : 0)
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTokens.background)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                appeared = true
            }
        }
        .onDisappear {
            appeared = false
        }
    }
}

#Preview {
    EmptyStateView(
        title: "No Games Found",
        message: "Try adjusting your search or filters.",
        systemImage: "gamecontroller",
        actionTitle: "Refresh"
    ) {
        // Refresh action
    }
}
