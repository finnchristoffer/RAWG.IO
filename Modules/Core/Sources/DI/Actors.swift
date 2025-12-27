import Foundation

/// Thread-safe storage coordinator using Swift actors.
///
/// Provides unified access to UserDefaults and Keychain storage.
/// Generic and reusable across projects.
public actor StorageActor {
    // MARK: - Dependencies

    private let userDefaults: StorageProtocol
    private let keychain: StorageProtocol

    // MARK: - Init

    public init(
        userDefaults: StorageProtocol = UserDefaultsStorage(),
        keychain: StorageProtocol = KeychainStorage()
    ) {
        self.userDefaults = userDefaults
        self.keychain = keychain
    }

    // MARK: - Public API

    /// Saves a Codable value to storage.
    /// - Parameters:
    ///   - value: The value to save
    ///   - key: Storage key string
    ///   - secure: If true, uses Keychain. Otherwise uses UserDefaults.
    public func save<T: Codable>(_ value: T, forKey key: String, secure: Bool = false) throws {
        let data = try JSONEncoder().encode(value)
        if secure {
            try keychain.save(data, forKey: key)
        } else {
            try userDefaults.save(data, forKey: key)
        }
        Logger.debug("Saved value for key: \(key)", privacy: .private)
    }

    /// Loads a Codable value from storage.
    /// - Parameters:
    ///   - key: Storage key string
    ///   - secure: If true, uses Keychain. Otherwise uses UserDefaults.
    /// - Returns: The decoded value or nil if not found
    public func load<T: Codable>(forKey key: String, secure: Bool = false) throws -> T? {
        let data: Data?
        if secure {
            data = try keychain.load(forKey: key)
        } else {
            data = try userDefaults.load(forKey: key)
        }
        guard let data else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Deletes a value from storage.
    /// - Parameters:
    ///   - key: Storage key string
    ///   - secure: If true, uses Keychain. Otherwise uses UserDefaults.
    public func delete(forKey key: String, secure: Bool = false) throws {
        if secure {
            try keychain.delete(forKey: key)
        } else {
            try userDefaults.delete(forKey: key)
        }
        Logger.debug("Deleted key: \(key)", privacy: .private)
    }
}
