import Foundation

/// Privacy levels for log messages.
public enum LogPrivacy: Sendable {
    /// Always visible in logs (DEBUG + RELEASE).
    case `public`
    /// Redacted in RELEASE builds.
    case `private`
    /// Smart: public in DEBUG, private in RELEASE.
    case auto
    /// Always redacted (sensitive data).
    case sensitive
}
