import SwiftUI
import CoreUI

/// Share sheet view for sharing game details.
struct ShareSheetView: View {
    private let shareItem: ShareItem
    private let onDismiss: () -> Void

    init(shareItem: ShareItem, onDismiss: @escaping () -> Void) {
        self.shareItem = shareItem
        self.onDismiss = onDismiss
    }

    var body: some View {
        VStack(spacing: 0) {
            // Handle bar
            handleBar

            // Header
            headerSection

            // Share Options
            shareOptionsSection

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(ColorTokens.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Handle Bar

    private var handleBar: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(ColorTokens.textSecondary.opacity(0.3))
            .frame(width: 36, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 16)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Share")
                .font(Typography.title3)
                .foregroundStyle(ColorTokens.textPrimary)

            Text(shareItem.text)
                .font(Typography.caption)
                .foregroundStyle(ColorTokens.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.bottom, 24)
    }

    // MARK: - Share Options

    private var shareOptionsSection: some View {
        VStack(spacing: 12) {
            // Copy Link
            ShareOptionButton(
                icon: "doc.on.doc",
                title: "Copy Link",
                action: copyLink
            )

            // Share via System
            ShareOptionButton(
                icon: "square.and.arrow.up",
                title: "Share via...",
                action: showSystemShare
            )
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Actions

    private func copyLink() {
        if let url = shareItem.url {
            UIPasteboard.general.string = url.absoluteString
        }
        onDismiss()
    }

    private func showSystemShare() {
        // This will be handled by the parent view using UIActivityViewController
        onDismiss()
    }
}

/// Share option button component.
private struct ShareOptionButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(ColorTokens.primary)
                    .frame(width: 44, height: 44)
                    .background(ColorTokens.primary.opacity(0.1))
                    .clipShape(Circle())

                Text(title)
                    .font(Typography.body)
                    .foregroundStyle(ColorTokens.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(ColorTokens.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(ColorTokens.background)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#if DEBUG
#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            ShareSheetView(
                shareItem: ShareItem(gameName: "The Witcher 3", gameId: 123)
            ) {}
        }
}
#endif
