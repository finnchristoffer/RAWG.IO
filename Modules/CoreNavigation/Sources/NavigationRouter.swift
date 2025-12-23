import SwiftUI

/// Navigation router that manages navigation state.
/// Use this router to navigate between screens.
@MainActor
public final class NavigationRouter: ObservableObject {
    @Published public var path = NavigationPath()

    public init() {}

    /// Navigate to a route.
    public func navigate<R: RouteProtocol>(to route: R) {
        let anyRoute = RouteRegistry.shared.resolve(route)
        path.append(anyRoute)
    }

    /// Go back to previous screen.
    public func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    /// Pop to root.
    public func popToRoot() {
        path.removeLast(path.count)
    }
}
