import XCTest
import SwiftUI
import SnapshotTesting
@testable import CoreUI

/// Snapshot tests for GameCard.
@MainActor
final class GameCardSnapshotTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Uncomment to record new snapshots
        // isRecording = true
    }

    func test_gameCard_with_high_rating() {
        // Arrange
        let sut = makeSUT(
            title: "The Witcher 3: Wild Hunt",
            rating: 4.8,
            platforms: ["PC", "PlayStation", "Xbox"]
        )

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .fixed(width: 350, height: 280)))
    }

    func test_gameCard_with_low_rating() {
        // Arrange
        let sut = makeSUT(
            title: "Some Game",
            rating: 2.1,
            platforms: ["PC"]
        )

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .fixed(width: 350, height: 280)))
    }

    func test_gameCard_with_long_title() {
        // Arrange
        let sut = makeSUT(
            title: "Grand Theft Auto V: The Complete Edition with All DLCs",
            rating: 4.5,
            platforms: ["PC", "PlayStation", "Xbox", "Nintendo"]
        )

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .fixed(width: 350, height: 280)))
    }

    func test_gameCard_without_platforms() {
        // Arrange
        let sut = makeSUT(
            title: "Indie Game",
            rating: 3.5,
            platforms: []
        )

        // Assert
        assertSnapshot(of: sut, as: .image(layout: .fixed(width: 350, height: 280)))
    }

    // MARK: - Helpers

    private func makeSUT(
        title: String,
        imageURL: URL? = nil,
        rating: Double,
        platforms: [String],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> some View {
        GameCard(
            title: title,
            imageURL: imageURL,
            rating: rating,
            platforms: platforms
        )
        .padding()
        .background(ColorTokens.background)
    }
}
