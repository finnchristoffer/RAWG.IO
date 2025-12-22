import XCTest
import SwiftUI
import SnapshotTesting
@testable import CoreUI

/// Snapshot tests for EmptyStateView.
@MainActor
final class EmptyStateViewSnapshotTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Uncomment to record new snapshots
        // isRecording = true
    }

    func test_emptyStateView_default() {
        // Arrange
        let sut = EmptyStateView()
            .frame(width: 390, height: 400)

        // Assert
        assertSnapshot(of: sut, as: .image)
    }

    func test_emptyStateView_with_custom_content() {
        // Arrange
        let sut = EmptyStateView(
            title: "No Games Found",
            message: "We couldn't find any games. Try adjusting your search.",
            systemImage: "gamecontroller"
        )
        .frame(width: 390, height: 400)

        // Assert
        assertSnapshot(of: sut, as: .image)
    }

    func test_emptyStateView_with_action_button() {
        // Arrange
        let sut = EmptyStateView(
            title: "No Results",
            message: "Nothing to show here.",
            systemImage: "magnifyingglass",
            actionTitle: "Try Again"
        ) {
            // Action
        }
        .frame(width: 390, height: 400)

        // Assert
        assertSnapshot(of: sut, as: .image)
    }
}
