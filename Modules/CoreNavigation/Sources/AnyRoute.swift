import SwiftUI

/// Type-erased route that can be stored in NavigationPath.
public struct AnyRoute: Hashable, @unchecked Sendable {
    private let id: AnyHashable
    let viewBuilder: () -> AnyView

    /// Creates a type-erased route.
    public init<R: RouteProtocol>(route: R, view: @escaping () -> AnyView) {
        self.id = AnyHashable(route)
        self.viewBuilder = view
    }

    /// Builds the destination view for this route.
    @MainActor
    public func buildView() -> AnyView {
        viewBuilder()
    }

    public static func == (lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
