import Foundation
@testable import Core

/// Mock Keychain operations for testing.
final class MockKeychainOperations: KeychainOperations, @unchecked Sendable {
    private var storage: [String: Data] = [:]
    var shouldFailOnAdd = false
    var shouldFailOnLoad = false
    var shouldFailOnDelete = false

    func add(_ query: CFDictionary) -> OSStatus {
        if shouldFailOnAdd {
            return errSecDuplicateItem
        }

        guard let dict = query as? [String: Any],
              let account = dict[kSecAttrAccount as String] as? String,
              let data = dict[kSecValueData as String] as? Data else {
            return errSecParam
        }
        storage[account] = data
        return errSecSuccess
    }

    func copyMatching(_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        if shouldFailOnLoad {
            return errSecAuthFailed
        }

        guard let dict = query as? [String: Any],
              let account = dict[kSecAttrAccount as String] as? String else {
            return errSecParam
        }

        guard let data = storage[account] else {
            return errSecItemNotFound
        }

        result?.pointee = data as CFTypeRef
        return errSecSuccess
    }

    func delete(_ query: CFDictionary) -> OSStatus {
        if shouldFailOnDelete {
            return errSecAuthFailed
        }

        guard let dict = query as? [String: Any],
              let account = dict[kSecAttrAccount as String] as? String else {
            return errSecParam
        }

        storage.removeValue(forKey: account)
        return errSecSuccess
    }
}
