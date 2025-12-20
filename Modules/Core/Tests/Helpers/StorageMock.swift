import Foundation
@testable import Core

/// Mock for storage protocol testing.
///
/// Uses constructor injection with Result types to constrain
/// stub behavior to success/failure only - no custom logic allowed.
///
/// ## Usage
/// ```swift
/// // Success case
/// let mock = StorageMock(loadResult: .success(someData))
///
/// // Failure case
/// let mock = StorageMock(loadResult: .failure(TestError.timeout))
///
/// // Verify calls
/// XCTAssertEqual(mock.loadedKeys, ["my_key"])
/// ```
public final class StorageMock: StorageProtocol, @unchecked Sendable {
    // MARK: - Spy (captured calls)

    public private(set) var loadedKeys: [String] = []
    public private(set) var savedData: [(key: String, data: Data)] = []
    public private(set) var deletedKeys: [String] = []

    // MARK: - Stub (injected via constructor)

    private let loadResult: Result<Data?, Error>
    private let saveResult: Result<Void, Error>
    private let deleteResult: Result<Void, Error>

    // MARK: - Init

    public init(
        loadResult: Result<Data?, Error> = .success(nil),
        saveResult: Result<Void, Error> = .success(()),
        deleteResult: Result<Void, Error> = .success(())
    ) {
        self.loadResult = loadResult
        self.saveResult = saveResult
        self.deleteResult = deleteResult
    }

    // MARK: - StorageProtocol

    public func load(forKey key: String) throws -> Data? {
        loadedKeys.append(key)
        return try loadResult.get()
    }

    public func save(_ data: Data, forKey key: String) throws {
        savedData.append((key: key, data: data))
        try saveResult.get()
    }

    public func delete(forKey key: String) throws {
        deletedKeys.append(key)
        try deleteResult.get()
    }
}
