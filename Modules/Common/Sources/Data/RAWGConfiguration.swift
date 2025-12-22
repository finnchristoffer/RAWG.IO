import Foundation

/// RAWG API configuration.
public enum RAWGConfiguration: Sendable {
    /// The base URL for RAWG API.
    public static let baseURL = URL(string: "https://api.rawg.io/api")! // swiftlint:disable:this force_unwrapping

    /// Default page size for paginated requests.
    public static let defaultPageSize = 20

    /// API key storage using thread-safe approach.
    private static let apiKeyStorage = APIKeyStorage()

    /// Get the current API key.
    public static var apiKey: String {
        apiKeyStorage.value
    }

    /// Set the API key (call once at app startup).
    public static func setAPIKey(_ key: String) {
        apiKeyStorage.setValue(key)
    }
}

/// Thread-safe storage for API key.
private final class APIKeyStorage: @unchecked Sendable {
    private var _value: String = ""
    private let lock = NSLock()

    var value: String {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }

    func setValue(_ newValue: String) {
        lock.lock()
        defer { lock.unlock() }
        _value = newValue
    }
}
