import UIKit

/// Protocol defining image caching operations.
///
/// Implementations provide async methods for storing, retrieving,
/// and managing cached images.
///
/// ## Usage
/// ```swift
/// let cache: ImageCacheProtocol = InMemoryImageCache()
/// await cache.store(image, for: url)
/// let cached = await cache.image(for: url)
/// ```
public protocol ImageCacheProtocol: Sendable {
    /// Retrieves a cached image for the specified URL.
    /// - Parameter url: The URL key for the cached image.
    /// - Returns: The cached UIImage, or nil if not found.
    func image(for url: URL) async -> UIImage?

    /// Stores an image in the cache.
    /// - Parameters:
    ///   - image: The UIImage to cache.
    ///   - url: The URL key for storage.
    func store(_ image: UIImage, for url: URL) async

    /// Removes the cached image for the specified URL.
    /// - Parameter url: The URL key to remove.
    func remove(for url: URL) async

    /// Clears all cached images.
    func clear() async
}
