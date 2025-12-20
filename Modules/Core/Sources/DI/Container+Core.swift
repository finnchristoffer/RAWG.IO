import Factory

/// DI Container extensions for Core module.
///
/// Generic and reusable across projects.
///
/// ## Usage
/// ```swift
/// @Injected(\.storageActor) var storage
/// @Injected(\.imageCacheActor) var imageCache
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
}
