import Foundation
import CoreNavigation

/// App-specific navigation routes.
/// Features use this enum to navigate without knowing about each other.
public enum AppRoute: RouteProtocol {
    /// Navigate to game detail screen.
    case gameDetail(gameId: Int, name: String)

    /// Navigate to favorites screen.
    case favorites

    /// Navigate to search screen.
    case search
}
