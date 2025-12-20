import XCTest
@testable import Core

/// Tests for Logger (coverage tests - output verified via OSLog)
final class LoggerTests: XCTestCase {
    // MARK: - Logger Method Tests

    func test_verbose_does_not_crash() {
        // Act/Assert - verify no crash
        Logger.verbose("Test verbose message")
        Logger.verbose("Test with privacy", privacy: .public)
    }

    func test_debug_does_not_crash() {
        // Act/Assert - verify no crash
        Logger.debug("Test debug message")
        Logger.debug("Test with privacy", privacy: .private)
    }

    func test_info_does_not_crash() {
        // Act/Assert - verify no crash
        Logger.info("Test info message")
        Logger.info("Test with privacy", privacy: .auto)
    }

    func test_warning_does_not_crash() {
        // Act/Assert - verify no crash
        Logger.warning("Test warning message")
    }

    func test_error_does_not_crash() {
        // Act/Assert - verify no crash
        Logger.error("Test error message")
    }

    func test_error_with_error_object_does_not_crash() {
        // Arrange
        let testError = NSError(domain: "test", code: 1, userInfo: nil)

        // Act/Assert - verify no crash
        Logger.error("Test error with error object", error: testError)
    }

    func test_error_with_nil_error_does_not_crash() {
        // Act/Assert - verify no crash
        Logger.error("Test error without error object", error: nil)
    }
}
