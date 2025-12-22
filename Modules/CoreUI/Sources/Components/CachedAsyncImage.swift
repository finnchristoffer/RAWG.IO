import SwiftUI

/// Reusable async image view with loading and error states.
///
/// ## Usage
/// ```swift
/// CachedAsyncImage(url: game.backgroundImage) { phase in
///     switch phase {
///     case .success(let image):
///         image.resizable()
///     case .failure:
///         placeholderView
///     case .empty:
///         LoadingView()
///     @unknown default:
///         EmptyView()
///     }
/// }
/// ```
public struct CachedAsyncImage<Content: View>: View {
    private let url: URL?
    private let content: (AsyncImagePhase) -> Content

    public init(
        url: URL?,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.content = content
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            content(phase)
        }
    }
}

/// Convenience view for simple async image loading.
public struct GameImageView: View {
    private let url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
            case .failure:
                ZStack {
                    ColorTokens.backgroundSecondary
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(ColorTokens.textSecondary)
                }
            case .empty:
                ZStack {
                    ColorTokens.backgroundSecondary
                    ProgressView()
                }
            @unknown default:
                ZStack {
                    ColorTokens.backgroundSecondary
                    ProgressView()
                }
            }
        }
    }
}
