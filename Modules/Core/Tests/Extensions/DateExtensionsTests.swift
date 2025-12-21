import XCTest
@testable import Core

/// Tests for Date extensions.
final class DateExtensionsTests: XCTestCase {
    // MARK: - iso8601String Tests

    func test_iso8601String_formats_date_correctly() {
        // Arrange
        var calendar = Calendar(identifier: .gregorian)
        // swiftlint:disable:next force_unwrapping
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = DateComponents(year: 2024, month: 1, day: 15, hour: 10, minute: 30, second: 0)
        // swiftlint:disable:next force_unwrapping
        let sut = calendar.date(from: components)!

        // Act
        let result = sut.ext.iso8601String

        // Assert
        XCTAssertTrue(result.contains("2024-01-15"), "Expected ISO8601 format with date")
    }

    // MARK: - timeAgo Tests

    func test_timeAgo_returns_just_now_for_recent_date() {
        // Arrange
        let sut = Date()

        // Act
        let result = sut.ext.timeAgo

        // Assert
        XCTAssertFalse(result.isEmpty, "Expected non-empty result")
    }

    func test_timeAgo_returns_minutes_ago() {
        // Arrange
        let sut = Date().addingTimeInterval(-120) // 2 minutes ago

        // Act
        let result = sut.ext.timeAgo

        // Assert
        XCTAssertTrue(result.contains("min") || result.contains("minute"), "Expected minutes in result")
    }

    func test_timeAgo_returns_hours_ago() {
        // Arrange
        let sut = Date().addingTimeInterval(-7200) // 2 hours ago

        // Act
        let result = sut.ext.timeAgo

        // Assert
        XCTAssertTrue(result.contains("hour"), "Expected hours in result")
    }

    func test_timeAgo_returns_days_ago() {
        // Arrange
        let sut = Date().addingTimeInterval(-172800) // 2 days ago

        // Act
        let result = sut.ext.timeAgo

        // Assert
        XCTAssertTrue(result.contains("day"), "Expected days in result")
    }
}
