import XCTest
import SwiftUI
import SnapshotTesting
@testable import CoreUI

/// Snapshot tests for LoadingView.
@MainActor
final class LoadingViewSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Uncomment to record new snapshots
        // isRecording = true
    }

    func test_loadingView_without_message() {
        // Arrange
        let sut = makeSUT(message: nil)

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    func test_loadingView_with_message() {
        // Arrange
        let sut = makeSUT(message: "Loading games...")

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .device(config: .iPhone13)))
    }

    // MARK: - Helpers

    private func makeSUT(
        message: String?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> some View {
        LoadingView(message: message)
            .frame(width: 390, height: 844)
    }
}
