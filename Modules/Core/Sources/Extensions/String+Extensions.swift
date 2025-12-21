import Foundation

/// String extensions using the `.ext` namespace.
///
/// ## Usage
/// ```swift
/// let text = "  hello  "
/// print(text.ext.trimmed)     // "hello"
/// print(text.ext.isBlank)     // false
/// print("".ext.nilIfEmpty)    // nil
/// ```
public extension Ext where Base == String {
    /// Returns `true` if the string is empty or contains only whitespace.
    var isBlank: Bool {
        base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Returns a new string with leading and trailing whitespace removed.
    var trimmed: String {
        base.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Returns `nil` if the string is empty, otherwise returns the string.
    var nilIfEmpty: String? {
        base.isEmpty ? nil : base
    }
}
