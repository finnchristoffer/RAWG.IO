import UIKit

/// Actor-based image cache coordinator combining memory and disk caching.
///
/// Implements a two-tier caching strategy:
/// 1. Fast in-memory cache (NSCache)
/// 2. Persistent disk cache (file-based)
///
/// ## Features
/// - Memory cache for fast access
/// - Disk cache for persistence
/// - Automatic memory-to-disk promotion
public actor ImageCacheActor: ImageCacheProtocol {
    private let memoryCache: InMemoryImageCache
    private let diskCache: DiskImageCache

    /// Creates a new image cache coordinator.
    /// - Parameters:
    ///   - memoryCache: In-memory cache layer.
    ///   - diskCache: Disk cache layer.
    public init(
        memoryCache: InMemoryImageCache = InMemoryImageCache(),
        diskCache: DiskImageCache = DiskImageCache()
    ) {
        self.memoryCache = memoryCache
        self.diskCache = diskCache
    }

    public func image(for url: URL) async -> UIImage? {
        // Check memory cache first
        if let memoryImage = await memoryCache.image(for: url) {
            return memoryImage
        }

        // Check disk cache and promote to memory
        if let diskImage = await diskCache.image(for: url) {
            await memoryCache.store(diskImage, for: url)
            return diskImage
        }

        return nil
    }

    public func store(_ image: UIImage, for url: URL) async {
        // Store in both caches
        await memoryCache.store(image, for: url)
        await diskCache.store(image, for: url)
    }

    public func remove(for url: URL) async {
        await memoryCache.remove(for: url)
        await diskCache.remove(for: url)
    }

    public func clear() async {
        await memoryCache.clear()
        await diskCache.clear()
    }
}
