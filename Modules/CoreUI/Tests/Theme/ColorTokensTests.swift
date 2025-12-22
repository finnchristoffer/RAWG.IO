import XCTest
import SwiftUI
@testable import CoreUI

/// Tests for ColorTokens.
final class ColorTokensTests: XCTestCase {
    // MARK: - Rating Color Tests

    func test_rating_returns_high_color_for_five() {
        // Act
        let result = ColorTokens.rating(5.0)

        // Assert
        XCTAssertEqual(result, ColorTokens.ratingHigh)
    }

    func test_rating_returns_high_color_for_four() {
        // Act
        let result = ColorTokens.rating(4.0)

        // Assert
        XCTAssertEqual(result, ColorTokens.ratingHigh)
    }

    func test_rating_returns_medium_color_for_three_point_five() {
        // Act
        let result = ColorTokens.rating(3.5)

        // Assert
        XCTAssertEqual(result, ColorTokens.ratingMedium)
    }

    func test_rating_returns_low_color_for_two() {
        // Act
        let result = ColorTokens.rating(2.0)

        // Assert
        XCTAssertEqual(result, ColorTokens.ratingLow)
    }

    func test_rating_returns_low_color_for_zero() {
        // Act
        let result = ColorTokens.rating(0.0)

        // Assert
        XCTAssertEqual(result, ColorTokens.ratingLow)
    }
}
