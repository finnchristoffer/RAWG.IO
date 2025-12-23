import SwiftUI

/// Registry for route resolvers.
/// Features register their route resolvers here.
@MainActor
public final class RouteRegistry {
    public static let shared = RouteRegistry()

    private var resolvers: [ObjectIdentifier: Any] = [:]

    private init() {}

    /// Register a resolver for a specific route type.
    public func register<R: RouteProtocol>(
        _ routeType: R.Type,
        resolver: @escaping (R) -> AnyView
    ) {
        let key = ObjectIdentifier(routeType)
        resolvers[key] = resolver
    }

    /// Resolve a route to an AnyRoute.
    public func resolve<R: RouteProtocol>(_ route: R) -> AnyRoute {
        let key = ObjectIdentifier(R.self)
        guard let resolver = resolvers[key] as? (R) -> AnyView else {
            return AnyRoute(route: route) {
                AnyView(Text("Route not registered: \(String(describing: route))"))
            }
        }
        let view = resolver(route)
        return AnyRoute(route: route) { view }
    }
}
