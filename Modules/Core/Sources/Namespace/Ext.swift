import Foundation

/// Namespace wrapper for extensions.
///
/// Enables the `.ext.` pattern similar to Kingfisher's `.kf` or RxSwift's `.rx`.
/// This provides a clean namespace for custom extensions without polluting
/// the base type's API.
///
/// ## Example
/// ```swift
/// extension Ext where Base == String {
///     var localized: String {
///         NSLocalizedString(base, comment: "")
///     }
/// }
///
/// let text = "hello_key"
/// print(text.ext.localized)
/// ```
public struct Ext<Base> {
    /// The wrapped base instance.
    public let base: Base
    
    /// Creates a namespace wrapper.
    ///
    /// - Parameter base: The instance to wrap
    public init(_ base: Base) {
        self.base = base
    }
}
