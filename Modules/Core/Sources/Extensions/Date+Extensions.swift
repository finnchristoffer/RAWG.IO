import Foundation

/// Date extensions using the `.ext` namespace.
///
/// ## Usage
/// ```swift
/// let date = Date()
/// print(date.ext.iso8601String)  // "2024-01-15T10:30:00Z"
/// print(date.ext.timeAgo)        // "just now"
/// ```
public extension Ext where Base == Date {
    /// Returns the date formatted as an ISO8601 string.
    var iso8601String: String {
        ISO8601DateFormatter().string(from: base)
    }

    /// Returns a human-readable relative time string.
    ///
    /// Examples: "just now", "2 minutes ago", "1 hour ago", "3 days ago"
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: base, relativeTo: Date())
    }
}
