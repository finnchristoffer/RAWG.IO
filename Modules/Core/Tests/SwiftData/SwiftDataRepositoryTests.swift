import XCTest
import SwiftData
@testable import Core

/// Tests for SwiftDataRepository
final class SwiftDataRepositoryTests: XCTestCase {
    private var modelContainer: ModelContainer?

    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        // Use in-memory container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: TestModel.self, configurations: config)
    }

    override func tearDown() async throws {
        modelContainer = nil
        try await super.tearDown()
    }

    // MARK: - Insert Tests

    @MainActor
    func test_insert_savesModel() async throws {
        // Arrange
        let sut = try makeSUT()
        let model = TestModel(name: "Test Item")

        // Act
        try await sut.insert(model)

        // Assert
        let fetched = try await sut.fetch()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.name, "Test Item")
    }

    // MARK: - Fetch Tests

    @MainActor
    func test_fetch_returnsAllModels() async throws {
        // Arrange
        let sut = try makeSUT()
        try await sut.insert(TestModel(name: "Item 1"))
        try await sut.insert(TestModel(name: "Item 2"))

        // Act
        let fetched = try await sut.fetch()

        // Assert
        XCTAssertEqual(fetched.count, 2)
    }

    @MainActor
    func test_fetch_withPredicate_filtersModels() async throws {
        // Arrange
        let sut = try makeSUT()
        try await sut.insert(TestModel(name: "Apple"))
        try await sut.insert(TestModel(name: "Banana"))

        // Act
        let predicate = #Predicate<TestModel> { $0.name == "Apple" }
        let fetched = try await sut.fetch(predicate: predicate)

        // Assert
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.name, "Apple")
    }

    // MARK: - Delete Tests

    @MainActor
    func test_delete_removesModel() async throws {
        // Arrange
        let sut = try makeSUT()
        let model = TestModel(name: "To Delete")
        try await sut.insert(model)

        // Act
        try await sut.delete(model)

        // Assert
        let fetched = try await sut.fetch()
        XCTAssertTrue(fetched.isEmpty)
    }

    // MARK: - Helpers

    @MainActor
    private func makeSUT() throws -> SwiftDataRepository<TestModel> {
        let container = try XCTUnwrap(modelContainer)
        return SwiftDataRepository(modelContext: container.mainContext)
    }
}

// MARK: - Test Model

@Model
final class TestModel {
    var name: String

    init(name: String) {
        self.name = name
    }
}
