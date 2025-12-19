import Foundation

/// Common test errors used across test suites.
public enum TestError: Error, LocalizedError, Equatable {
    case missingFile(String)
    case timeout
    case unexpectedNil
    case stub(String)
    case mockNotConfigured(String)
    
    public var errorDescription: String? {
        switch self {
        case .missingFile(let name): return "Missing file: \(name)"
        case .timeout: return "Operation timed out"
        case .unexpectedNil: return "Unexpected nil value"
        case .stub(let message): return "Stub error: \(message)"
        case .mockNotConfigured(let mock): return "Mock not configured: \(mock)"
        }
    }
}
