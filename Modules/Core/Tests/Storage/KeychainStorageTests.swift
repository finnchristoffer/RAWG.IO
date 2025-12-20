import XCTest
@testable import Core

/// Tests for KeychainStorage
final class KeychainStorageTests: XCTestCase {
    // MARK: - Save Tests

    func test_save_stores_data() throws {
        // Arrange
        let (sut, _) = makeSUT()
        let data = Data("secret".utf8)
        let key = "test_key"

        // Act
        try sut.save(data, forKey: key)

        // Assert
        let loaded = try sut.load(forKey: key)
        XCTAssertEqual(loaded, data, "Expected saved data to be retrievable")
    }

    func test_save_overwrites_existing_data() throws {
        // Arrange
        let (sut, _) = makeSUT()
        let key = "test_key"
        try sut.save(Data("original".utf8), forKey: key)

        // Act
        try sut.save(Data("updated".utf8), forKey: key)

        // Assert
        let loaded = try sut.load(forKey: key)
        XCTAssertEqual(loaded, Data("updated".utf8), "Expected save to overwrite")
    }

    func test_save_throws_on_failure() {
        // Arrange
        let (sut, mock) = makeSUT()
        mock.shouldFailOnAdd = true

        // Act/Assert
        XCTAssertThrowsError(try sut.save(Data("test".utf8), forKey: "key")) { error in
            guard case KeychainError.saveFailed = error else {
                XCTFail("Expected KeychainError.saveFailed")
                return
            }
        }
    }

    // MARK: - Load Tests

    func test_load_returns_nil_for_missing_key() throws {
        // Arrange
        let (sut, _) = makeSUT()

        // Act
        let result = try sut.load(forKey: "nonexistent")

        // Assert
        XCTAssertNil(result, "Expected nil for missing key")
    }

    func test_load_throws_on_failure() {
        // Arrange
        let (sut, mock) = makeSUT()
        mock.shouldFailOnLoad = true

        // Act/Assert
        XCTAssertThrowsError(try sut.load(forKey: "key")) { error in
            guard case KeychainError.loadFailed = error else {
                XCTFail("Expected KeychainError.loadFailed")
                return
            }
        }
    }

    // MARK: - Delete Tests

    func test_delete_removes_data() throws {
        // Arrange
        let (sut, _) = makeSUT()
        let key = "test_key"
        try sut.save(Data("test".utf8), forKey: key)

        // Act
        try sut.delete(forKey: key)

        // Assert
        let result = try sut.load(forKey: key)
        XCTAssertNil(result, "Expected deleted key to be gone")
    }

    func test_delete_throws_on_failure() {
        // Arrange
        let (sut, mock) = makeSUT()
        mock.shouldFailOnDelete = true

        // Act/Assert
        XCTAssertThrowsError(try sut.delete(forKey: "key")) { error in
            guard case KeychainError.deleteFailed = error else {
                XCTFail("Expected KeychainError.deleteFailed")
                return
            }
        }
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (KeychainStorage, MockKeychainOperations) {
        let mock = MockKeychainOperations()
        let sut = KeychainStorage(service: "test.service", keychain: mock)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, mock)
    }
}
