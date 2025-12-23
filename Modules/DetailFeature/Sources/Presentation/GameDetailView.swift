import SwiftUI
import Common
import CoreUI

/// Placeholder view for game detail.
struct GameDetailView: View {
    let gameId: Int
    let gameName: String

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 80))
                .foregroundStyle(ColorTokens.primary)

            Text(gameName)
                .font(Typography.title)
                .foregroundStyle(ColorTokens.textPrimary)
                .multilineTextAlignment(.center)

            Text("Game ID: \(gameId)")
                .font(Typography.body)
                .foregroundStyle(ColorTokens.textSecondary)

            Text("Detail view coming soon...")
                .font(Typography.caption)
                .foregroundStyle(ColorTokens.textSecondary)
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorTokens.background)
        .navigationTitle("Game Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        GameDetailView(gameId: 123, gameName: "The Witcher 3: Wild Hunt")
    }
}
#endif
