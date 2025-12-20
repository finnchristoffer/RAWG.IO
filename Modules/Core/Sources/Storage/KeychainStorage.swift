import Foundation
import Security

/// Protocol for Keychain operations (enables testing).
public protocol KeychainOperations: Sendable {
    func add(_ query: CFDictionary) -> OSStatus
    func copyMatching(_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus
    func delete(_ query: CFDictionary) -> OSStatus
}

/// Real Keychain implementation using Security framework.
public struct RealKeychainOperations: KeychainOperations {
    public init() {}

    public func add(_ query: CFDictionary) -> OSStatus {
        SecItemAdd(query, nil)
    }

    public func copyMatching(_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        SecItemCopyMatching(query, result)
    }

    public func delete(_ query: CFDictionary) -> OSStatus {
        SecItemDelete(query)
    }
}

/// Keychain-based secure storage implementation.
///
/// Generic and reusable across projects.
public final class KeychainStorage: StorageProtocol, @unchecked Sendable {
    private let service: String
    private let keychain: KeychainOperations

    /// Creates a KeychainStorage with the specified service identifier.
    /// - Parameters:
    ///   - service: Service identifier for keychain items. Defaults to bundle identifier.
    ///   - keychain: Keychain operations implementation. Defaults to real Security framework.
    public init(service: String? = nil, keychain: KeychainOperations = RealKeychainOperations()) {
        self.service = service ?? Bundle.main.bundleIdentifier ?? "app.core.keychain"
        self.keychain = keychain
    }

    public func save(_ data: Data, forKey key: String) throws {
        // Delete existing item first
        try? delete(forKey: key)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        let status = keychain.add(query as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    public func load(forKey key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: CFTypeRef?
        let status = keychain.copyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.loadFailed(status)
        }

        return result as? Data
    }

    public func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let status = keychain.delete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

/// Keychain operation errors.
public enum KeychainError: Error, LocalizedError {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)

    public var errorDescription: String? {
        switch self {
        case .saveFailed(let status): return "Keychain save failed: \(status)"
        case .loadFailed(let status): return "Keychain load failed: \(status)"
        case .deleteFailed(let status): return "Keychain delete failed: \(status)"
        }
    }
}
