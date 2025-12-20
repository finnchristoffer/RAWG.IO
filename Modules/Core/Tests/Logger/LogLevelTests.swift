import XCTest
@testable import Core

/// Tests for LogLevel
final class LogLevelTests: XCTestCase {
    // MARK: - osLogType Tests

    func test_verbose_osLogType_is_debug() {
        // Arrange/Act
        let level = LogLevel.verbose

        // Assert
        XCTAssertEqual(level.osLogType, .debug, "Expected verbose osLogType to be debug")
    }

    func test_debug_osLogType_is_debug() {
        // Arrange/Act
        let level = LogLevel.debug

        // Assert
        XCTAssertEqual(level.osLogType, .debug, "Expected debug osLogType to be debug")
    }

    func test_info_osLogType_is_info() {
        // Arrange/Act
        let level = LogLevel.info

        // Assert
        XCTAssertEqual(level.osLogType, .info, "Expected info osLogType to be info")
    }

    func test_warning_osLogType_is_default() {
        // Arrange/Act
        let level = LogLevel.warning

        // Assert
        XCTAssertEqual(level.osLogType, .default, "Expected warning osLogType to be default")
    }

    func test_error_osLogType_is_error() {
        // Arrange/Act
        let level = LogLevel.error

        // Assert
        XCTAssertEqual(level.osLogType, .error, "Expected error osLogType to be error")
    }

    // MARK: - name Tests

    func test_all_levels_have_names() {
        // Arrange/Act/Assert
        XCTAssertEqual(LogLevel.verbose.name, "VERBOSE", "Expected verbose name")
        XCTAssertEqual(LogLevel.debug.name, "DEBUG", "Expected debug name")
        XCTAssertEqual(LogLevel.info.name, "INFO", "Expected info name")
        XCTAssertEqual(LogLevel.warning.name, "WARNING", "Expected warning name")
        XCTAssertEqual(LogLevel.error.name, "ERROR", "Expected error name")
    }

    // MARK: - emoji Tests

    func test_all_levels_have_emojis() {
        // Arrange/Act/Assert
        XCTAssertEqual(LogLevel.verbose.emoji, "🔍", "Expected verbose emoji")
        XCTAssertEqual(LogLevel.debug.emoji, "🐛", "Expected debug emoji")
        XCTAssertEqual(LogLevel.info.emoji, "ℹ️", "Expected info emoji")
        XCTAssertEqual(LogLevel.warning.emoji, "⚠️", "Expected warning emoji")
        XCTAssertEqual(LogLevel.error.emoji, "❌", "Expected error emoji")
    }

    // MARK: - Comparable Tests

    func test_levels_are_ordered_by_severity() {
        // Arrange/Act/Assert
        XCTAssertTrue(LogLevel.verbose < LogLevel.debug, "Expected verbose < debug")
        XCTAssertTrue(LogLevel.debug < LogLevel.info, "Expected debug < info")
        XCTAssertTrue(LogLevel.info < LogLevel.warning, "Expected info < warning")
        XCTAssertTrue(LogLevel.warning < LogLevel.error, "Expected warning < error")
    }
}
