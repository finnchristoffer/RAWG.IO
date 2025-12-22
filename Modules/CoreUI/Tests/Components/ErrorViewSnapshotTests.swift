import XCTest
import SwiftUI
import SnapshotTesting
@testable import CoreUI

/// Snapshot tests for ErrorView.
@MainActor
final class ErrorViewSnapshotTests: XCTestCase {
    func test_errorView_without_retry() {
        // Arrange
        let sut = makeSUT(message: "An error occurred", hasRetry: false)

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_errorView_with_retry() {
        // Arrange
        let sut = makeSUT(message: "Failed to load. Please try again.", hasRetry: true)

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    // MARK: - Helpers

    private func makeSUT(
        title: String = "Something went wrong",
        message: String,
        hasRetry: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> some View {
        ErrorView(
            title: title,
            message: message,
            retryAction: hasRetry ? {} : nil
        )
        .frame(width: 390, height: 844)
    }
}
