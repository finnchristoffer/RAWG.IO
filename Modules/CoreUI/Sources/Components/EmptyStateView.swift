import SwiftUI

/// View displayed when a list is empty.
public struct EmptyStateView: View {
    private let title: String
    private let message: String
    private let systemImage: String
    private let action: (() -> Void)?
    private let actionTitle: String?

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
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundStyle(ColorTokens.textSecondary)

            VStack(spacing: 8) {
                Text(title)
                    .font(Typography.title2)
                    .foregroundStyle(ColorTokens.textPrimary)

                Text(message)
                    .font(Typography.body)
                    .foregroundStyle(ColorTokens.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            if let action, let actionTitle {
                Button(action: action) {
                    Text(actionTitle)
                        .font(Typography.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(ColorTokens.accent)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTokens.background)
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
