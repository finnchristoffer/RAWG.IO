import XCTest
@testable import Core

/// Tests for StorageActor
final class StorageActorTests: XCTestCase {
    // MARK: - Save/Load Tests

    func test_save_and_load_codable_value() async throws {
        // Arrange
        let (sut, testDefaults) = makeSUT()
        let value = TestCodable(id: 1, name: "Test")
        let key = "test_key"

        // Act
        try await sut.save(value, forKey: key, secure: false)
        let result: TestCodable? = try await sut.load(forKey: key, secure: false)

        // Assert
        XCTAssertEqual(result?.id, value.id, "Expected loaded value to match saved value")

        // Cleanup
        testDefaults?.removePersistentDomain(forName: "StorageActorTests")
    }

    func test_save_secure_uses_keychain() async throws {
        // Arrange
        let keychainMock = StorageMock(loadResult: .success(nil))
        let sut = makeStorageActor(keychain: keychainMock)
        let value = TestCodable(id: 1, name: "Secret")
        let key = "access_token"

        // Act
        try await sut.save(value, forKey: key, secure: true)

        // Assert
        XCTAssertFalse(keychainMock.savedData.isEmpty, "Expected secure save to use keychain")
    }

    func test_delete_removes_value() async throws {
        // Arrange
        let userDefaultsMock = StorageMock(loadResult: .success(nil))
        let sut = makeStorageActor(userDefaults: userDefaultsMock)
        let key = "test_key"

        // Act
        try await sut.delete(forKey: key, secure: false)

        // Assert
        XCTAssertTrue(userDefaultsMock.deletedKeys.contains(key), "Expected delete to remove key from storage")
    }

    func test_load_returns_nil_for_missing_key() async throws {
        // Arrange
        let sut = makeStorageActor()
        let key = "nonexistent_key"

        // Act
        let result: TestCodable? = try await sut.load(forKey: key, secure: false)

        // Assert
        XCTAssertNil(result, "Expected load to return nil for nonexistent key")
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: StorageActor, testDefaults: UserDefaults?) {
        let suiteName = "StorageActorTests"
        let testDefaults = UserDefaults(suiteName: suiteName)
        testDefaults?.removePersistentDomain(forName: suiteName)

        let sut = StorageActor(
            userDefaults: UserDefaultsStorage(defaults: testDefaults ?? .standard),
            keychain: StorageMock(loadResult: .success(nil))
        )

        return (sut, testDefaults)
    }

    private func makeStorageActor(
        userDefaults: StorageProtocol? = nil,
        keychain: StorageProtocol? = nil
    ) -> StorageActor {
        StorageActor(
            userDefaults: userDefaults ?? StorageMock(loadResult: .success(nil)),
            keychain: keychain ?? StorageMock(loadResult: .success(nil))
        )
    }
}

// MARK: - Test Helpers

private struct TestCodable: Codable, Equatable {
    let id: Int
    let name: String
}
