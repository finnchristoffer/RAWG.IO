import XCTest
import SwiftUI
import SnapshotTesting
@testable import DetailFeature
@testable import CoreUI

/// Snapshot tests for GameDetailView.
final class GameDetailViewSnapshotTests: XCTestCase {
    // MARK: - Snapshot Tests

    func test_gameDetailView_displaysGameInfo() {
        // Arrange
        let view = GameDetailView(gameId: 123, gameName: "The Witcher 3: Wild Hunt")
            .frame(width: 390, height: 844)

        // Assert
        assertSnapshot(of: view, as: .image)
    }

    func test_gameDetailView_shortGameName() {
        // Arrange
        let view = GameDetailView(gameId: 1, gameName: "Halo")
            .frame(width: 390, height: 844)

        // Assert
        assertSnapshot(of: view, as: .image)
    }

    func test_gameDetailView_longGameName() {
        // Arrange
        let view = GameDetailView(
            gameId: 999,
            gameName: "The Legend of Zelda: Tears of the Kingdom - Collector's Edition"
        )
        .frame(width: 390, height: 844)

        // Assert
        assertSnapshot(of: view, as: .image)
    }
}
