import SwiftUI

/// Navigation router that manages navigation state.
/// Use this router to navigate between screens and present sheets.
@MainActor
public final class NavigationRouter: ObservableObject {
    @Published public var path = NavigationPath()
    @Published public var currentSheet: AnySheet?

    public init() {}

    // MARK: - Navigation

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

    // MARK: - Sheet Presentation

    /// Present a sheet using the registry resolver.
    public func presentSheet<S: SheetProtocol>(_ sheet: S) {
        let anySheet = SheetRegistry.shared.resolve(sheet)
        currentSheet = anySheet
    }

    /// Dismiss the currently presented sheet.
    public func dismissSheet() {
        currentSheet = nil
    }
}
