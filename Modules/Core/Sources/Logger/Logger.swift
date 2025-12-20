import Foundation
import OSLog

/// Centralized logging service using OSLog with privacy support.
///
/// Generic and reusable across projects.
///
/// ## Usage
/// ```swift
/// Logger.debug("User tapped button")
/// Logger.info("Fetched \(count) items", privacy: .public)
/// Logger.error("API failed", error: error)
/// ```
public enum Logger {
    // MARK: - Configuration

    private static let subsystem = Bundle.main.bundleIdentifier ?? "app.core.logger"
    private static let osLogger = OSLog(subsystem: subsystem, category: "app")

    #if DEBUG
    private static let minimumLevel: LogLevel = .verbose
    #else
    private static let minimumLevel: LogLevel = .info
    #endif

    // MARK: - Public API

    public static func verbose(
        _ message: @autoclosure () -> String,
        privacy: LogPrivacy = .auto,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.verbose, message(), privacy: privacy, file: file, function: function, line: line)
    }

    public static func debug(
        _ message: @autoclosure () -> String,
        privacy: LogPrivacy = .auto,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.debug, message(), privacy: privacy, file: file, function: function, line: line)
    }

    public static func info(
        _ message: @autoclosure () -> String,
        privacy: LogPrivacy = .auto,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.info, message(), privacy: privacy, file: file, function: function, line: line)
    }

    public static func warning(
        _ message: @autoclosure () -> String,
        privacy: LogPrivacy = .auto,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(.warning, message(), privacy: privacy, file: file, function: function, line: line)
    }

    public static func error(
        _ message: @autoclosure () -> String,
        error: Error? = nil,
        privacy: LogPrivacy = .auto,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var fullMessage = message()
        if let error {
            fullMessage += " | Error: \(error.localizedDescription)"
        }
        log(.error, fullMessage, privacy: privacy, file: file, function: function, line: line)
    }

    // MARK: - Private

    private static func log(
        _ level: LogLevel,
        _ message: String,
        privacy: LogPrivacy,
        file: String,
        function: String,
        line: Int
    ) {
        guard level >= minimumLevel else { return }

        let formattedMessage: String

        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = ISO8601DateFormatter().string(from: Date())
        formattedMessage = "\(timestamp) \(level.emoji) \(level.name) [\(fileName):\(line)] \(function) > \(message)"
        #else
        formattedMessage = "\(level.name): \(message)"
        #endif

        os_log("%{public}@", log: osLogger, type: level.osLogType, formattedMessage as NSString)
    }
}
