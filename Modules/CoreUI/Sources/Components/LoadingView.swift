import SwiftUI

/// Loading view with spinner and optional message.
///
/// ## Usage
/// ```swift
/// LoadingView()
/// LoadingView(message: "Loading games...")
/// ```
public struct LoadingView: View {
    private let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)

            if let message {
                Text(message)
                    .font(Typography.callout)
                    .foregroundColor(ColorTokens.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTokens.background)
    }
}

#if DEBUG
#Preview {
    LoadingView(message: "Loading games...")
}
#endif
