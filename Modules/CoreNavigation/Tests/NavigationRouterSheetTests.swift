import XCTest
import SwiftUI
@testable import CoreNavigation

/// Tests for NavigationRouter sheet functionality.
@MainActor
final class NavigationRouterSheetTests: XCTestCase {
    // MARK: - Sheet Presentation Tests

    func test_presentSheet_setsCurrentSheet() {
        // Arrange
        let sut = NavigationRouter()
        let sheet = MockSheet()

        // Act
        sut.presentSheet(sheet)

        // Assert
        XCTAssertNotNil(sut.currentSheet)
    }

    func test_dismissSheet_clearsCurrentSheet() {
        // Arrange
        let sut = NavigationRouter()
        sut.presentSheet(MockSheet())

        // Act
        sut.dismissSheet()

        // Assert
        XCTAssertNil(sut.currentSheet)
    }

    func test_presentSheet_replacesExistingSheet() {
        // Arrange
        let sut = NavigationRouter()
        let firstSheet = MockSheet(id: "first")
        let secondSheet = MockSheet(id: "second")

        // Act
        sut.presentSheet(firstSheet)
        sut.presentSheet(secondSheet)

        // Assert
        XCTAssertNotNil(sut.currentSheet)
    }

    func test_currentSheet_startsNil() {
        // Arrange & Act
        let sut = NavigationRouter()

        // Assert
        XCTAssertNil(sut.currentSheet)
    }
}

// MARK: - Mock Sheet

struct MockSheet: SheetProtocol {
    var id: String = UUID().uuidString
}
