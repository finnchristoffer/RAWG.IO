import SwiftUI

/// Error view with message and retry button.
///
/// ## Usage
/// ```swift
/// ErrorView(
///     message: "Failed to load games",
///     retryAction: { viewModel.loadGames() }
/// )
/// ```
public struct ErrorView: View {
    private let title: String
    private let message: String
    private let retryAction: (() -> Void)?

    public init(
        title: String = "Something went wrong",
        message: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(ColorTokens.error)

            VStack(spacing: 8) {
                Text(title)
                    .font(Typography.headline)
                    .foregroundColor(ColorTokens.textPrimary)

                Text(message)
                    .font(Typography.callout)
                    .foregroundColor(ColorTokens.textSecondary)
                    .multilineTextAlignment(.center)
            }

            if let retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .font(Typography.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(ColorTokens.primary)
                        .cornerRadius(8)
                }
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTokens.background)
    }
}

#if DEBUG
#Preview {
    ErrorView(
        message: "Failed to load games. Please check your connection.",
        retryAction: {}
    )
}
#endif
