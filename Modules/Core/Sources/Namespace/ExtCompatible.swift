import Foundation

/// Protocol enabling the `.ext` namespace pattern.
///
/// Conforming types gain access to the `.ext` property for both
/// static and instance contexts.
///
/// ## Usage
/// ```swift
/// // Conform your type
/// extension MyType: ExtCompatible { }
///
/// // Add extensions in the Ext namespace
/// extension Ext where Base == MyType {
///     var customProperty: String { ... }
/// }
///
/// // Use the extension
/// let instance = MyType()
/// print(instance.ext.customProperty)
/// ```
public protocol ExtCompatible {
    associatedtype ExtBase
    
    /// Static namespace accessor.
    static var ext: Ext<ExtBase>.Type { get set }
    
    /// Instance namespace accessor.
    var ext: Ext<ExtBase> { get set }
}

// MARK: - Default Implementation

public extension ExtCompatible {
    /// Default static namespace accessor.
    static var ext: Ext<Self>.Type {
        get { Ext<Self>.self }
        // swiftlint:disable:next unused_setter_value
        set { }
    }

    /// Default instance namespace accessor.
    var ext: Ext<Self> {
        get { Ext(self) }
        // swiftlint:disable:next unused_setter_value
        set { }
    }
}

// MARK: - Foundation Conformances

extension NSObject: ExtCompatible { }
extension String: ExtCompatible { }
extension Date: ExtCompatible { }
extension Int: ExtCompatible { }
extension Double: ExtCompatible { }
extension Float: ExtCompatible { }
extension Bool: ExtCompatible { }
extension Array: ExtCompatible { }
extension Dictionary: ExtCompatible { }
extension Set: ExtCompatible { }
extension Data: ExtCompatible { }
extension URL: ExtCompatible { }
