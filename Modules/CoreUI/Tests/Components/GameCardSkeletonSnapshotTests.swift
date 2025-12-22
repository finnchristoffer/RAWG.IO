import XCTest
import SwiftUI
import SnapshotTesting
@testable import CoreUI

/// Snapshot tests for GameCardSkeleton.
@MainActor
final class GameCardSkeletonSnapshotTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Uncomment to record new snapshots
        // isRecording = true
    }

    func test_gameCardSkeleton_default() {
        // Arrange
        let sut = GameCardSkeleton()
            .frame(width: 350)
            .padding()
            .background(ColorTokens.background)

        // Assert
        assertSnapshot(of: sut, as: .image)
    }

    func test_gameCardSkeleton_list() {
        // Arrange - multiple skeletons like loading list
        let sut = VStack(spacing: 16) {
            GameCardSkeleton()
            GameCardSkeleton()
            GameCardSkeleton()
        }
        .frame(width: 350)
        .padding()
        .background(ColorTokens.background)

        // Assert
        assertSnapshot(of: sut, as: .image)
    }
}
