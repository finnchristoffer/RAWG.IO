import XCTest
@testable import Core

/// Tests for UserDefaultsStorage
final class UserDefaultsStorageTests: XCTestCase {
    private static let suiteName = "UserDefaultsStorageTests"

    override func tearDown() {
        UserDefaults(suiteName: Self.suiteName)?.removePersistentDomain(forName: Self.suiteName)
        super.tearDown()
    }

    // MARK: - Save Tests

    func test_save_stores_data_for_key() throws {
        // Arrange
        let (sut, testDefaults) = makeSUT()
        let data = Data("test".utf8)
        let key = "test_key"

        // Act
        try sut.save(data, forKey: key)

        // Assert
        let stored = testDefaults.data(forKey: key)
        XCTAssertEqual(stored, data, "Expected saved data to be retrievable from UserDefaults")
    }

    // MARK: - Load Tests

    func test_load_returns_stored_data() throws {
        // Arrange
        let (sut, testDefaults) = makeSUT()
        let data = Data("test".utf8)
        let key = "test_key"
        testDefaults.set(data, forKey: key)

        // Act
        let result = try sut.load(forKey: key)

        // Assert
        XCTAssertEqual(result, data, "Expected load to return previously saved data")
    }

    func test_load_returns_nil_for_missing_key() throws {
        // Arrange
        let (sut, _) = makeSUT()
        let key = "nonexistent_key"

        // Act
        let result = try sut.load(forKey: key)

        // Assert
        XCTAssertNil(result, "Expected load to return nil for nonexistent key")
    }

    // MARK: - Delete Tests

    func test_delete_removes_data_for_key() throws {
        // Arrange
        let (sut, testDefaults) = makeSUT()
        let data = Data("test".utf8)
        let key = "test_key"
        testDefaults.set(data, forKey: key)

        // Act
        try sut.delete(forKey: key)

        // Assert
        XCTAssertNil(testDefaults.data(forKey: key), "Expected deleted key to be removed from UserDefaults")
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: UserDefaultsStorage, testDefaults: UserDefaults) {
        let testDefaults = UserDefaults(suiteName: Self.suiteName) ?? .standard
        testDefaults.removePersistentDomain(forName: Self.suiteName)

        let sut = UserDefaultsStorage(defaults: testDefaults)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, testDefaults)
    }
}
