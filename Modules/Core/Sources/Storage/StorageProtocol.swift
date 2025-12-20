import Foundation

/// Protocol for storage implementations.
public protocol StorageProtocol: Sendable {
    func save(_ data: Data, forKey key: String) throws
    func load(forKey key: String) throws -> Data?
    func delete(forKey key: String) throws
}
