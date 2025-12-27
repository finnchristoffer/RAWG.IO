import SwiftUI

/// Registry for sheet resolvers.
/// Features register their sheet resolvers here.
@MainActor
public final class SheetRegistry {
    public static let shared = SheetRegistry()

    private var resolvers: [ObjectIdentifier: Any] = [:]

    private init() {}

    /// Register a resolver for a specific sheet type.
    public func register<S: SheetProtocol>(
        _ sheetType: S.Type,
        resolver: @escaping (S) -> AnyView
    ) {
        let key = ObjectIdentifier(sheetType)
        resolvers[key] = resolver
    }

    /// Resolve a sheet to an AnySheet.
    public func resolve<S: SheetProtocol>(_ sheet: S) -> AnySheet {
        let key = ObjectIdentifier(S.self)
        guard let resolver = resolvers[key] as? (S) -> AnyView else {
            return AnySheet(sheet) {
                Text("Sheet not registered: \(String(describing: sheet))")
            }
        }
        let view = resolver(sheet)
        return AnySheet(sheet) { view }
    }
}
