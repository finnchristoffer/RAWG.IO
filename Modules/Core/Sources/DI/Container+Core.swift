import Factory

/// DI Container extensions for Core module actors.
///
/// ## Usage
/// ```swift
/// @Injected(\.storageActor) var storage
/// @Injected(\.imageCacheActor) var imageCache
/// @Injected(\.favoritesActor) var favorites
/// ```
public extension Container {
    // MARK: - Storage

    /// Thread-safe storage coordinator (singleton).
    var storageActor: Factory<StorageActor> {
        self { StorageActor() }
            .singleton
    }

    // MARK: - Cache

    /// Thread-safe image cache (singleton).
    var imageCacheActor: Factory<ImageCacheActor> {
        self { ImageCacheActor() }
            .singleton
    }

    // MARK: - Favorites

    /// SwiftData favorites persistence (singleton).
    var favoritesActor: Factory<FavoritesActor> {
        self { FavoritesActor() }
            .singleton
    }
}
