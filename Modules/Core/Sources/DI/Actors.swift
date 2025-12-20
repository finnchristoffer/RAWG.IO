import Foundation

/// Thread-safe storage coordinator using Swift actors.
///
/// Provides unified access to UserDefaults, Keychain, and cache storage.
/// Full implementation in feature/core-storage branch.
public actor StorageActor {
    public init() {}
}

/// Thread-safe image cache using Swift actors.
///
/// Full implementation in feature/core-image-cache branch.
public actor ImageCacheActor {
    public init() {}
}

/// SwiftData-backed favorites persistence using Swift actors.
///
/// Full implementation in feature/core-swiftdata branch.
public actor FavoritesActor {
    public init() {}
}
