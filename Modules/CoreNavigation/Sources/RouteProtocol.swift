import Foundation

/// Protocol that any navigation route must conform to.
/// Routes are hashable to work with NavigationPath.
public protocol RouteProtocol: Hashable, Sendable {}
