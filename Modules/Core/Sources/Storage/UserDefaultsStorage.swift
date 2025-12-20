import Foundation

/// UserDefaults-based storage implementation.
public final class UserDefaultsStorage: StorageProtocol, @unchecked Sendable {
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func save(_ data: Data, forKey key: String) throws {
        defaults.set(data, forKey: key)
    }

    public func load(forKey key: String) throws -> Data? {
        defaults.data(forKey: key)
    }

    public func delete(forKey key: String) throws {
        defaults.removeObject(forKey: key)
    }
}
