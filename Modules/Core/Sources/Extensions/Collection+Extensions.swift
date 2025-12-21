import Foundation

/// Array extensions using the `.ext` namespace.
///
/// ## Usage
/// ```swift
/// let array = [1, 2, 3]
/// print(array.ext[safe: 1])   // Optional(2)
/// print(array.ext[safe: 10])  // nil
/// ```
public extension Ext where Base: Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the index, or nil if out of bounds.
    subscript(safe index: Base.Index) -> Base.Element? {
        base.indices.contains(index) ? base[index] : nil
    }
}
