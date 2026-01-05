import XCTest
import SwiftUI
import SnapshotTesting
@testable import DetailFeature
@testable import CoreUI

/// Snapshot tests for GameDetailView.
@MainActor
final class GameDetailViewSnapshotTests: XCTestCase {
    // MARK: - Snapshot Tests

    func test_gameDetailView_displaysGameInfo() {
        // Arrange - use mock ViewModel for testing
        let viewModel = GameDetailViewModel(
            gameId: 123,
            gameName: "The Witcher 3: Wild Hunt",
            rating: 4.5,
            platforms: ["PC", "PlayStation 4"],
            isPreview: true
        )
        let view = GameDetailView(viewModel: viewModel)
            .frame(width: 390, height: 844)

        // Assert
        assertSnapshot(of: view, as: .image)
    }

    func test_gameDetailView_shortGameName() {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 1,
            gameName: "Halo",
            isPreview: true
        )
        let view = GameDetailView(viewModel: viewModel)
            .frame(width: 390, height: 844)

        // Assert
        assertSnapshot(of: view, as: .image)
    }

    func test_gameDetailView_longGameName() {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 999,
            gameName: "The Legend of Zelda: Tears of the Kingdom - Collector's Edition",
            isPreview: true
        )
        let view = GameDetailView(viewModel: viewModel)
            .frame(width: 390, height: 844)

        // Assert
        assertSnapshot(of: view, as: .image)
    }
}
