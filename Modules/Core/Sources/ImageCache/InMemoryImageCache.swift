import UIKit

/// In-memory image cache using NSCache for automatic memory management.
///
/// Thread-safe implementation using internal synchronization.
/// Automatically evicts images under memory pressure.
///
/// ## Features
/// - Thread-safe via internal serial queue
/// - Automatic memory management via NSCache
/// - Configurable cost/count limits
public final class InMemoryImageCache: ImageCacheProtocol, @unchecked Sendable {
    private let cache = NSCache<NSURL, UIImage>()
    private let queue = DispatchQueue(label: "com.rawg.inmemory-cache", attributes: .concurrent)

    /// Creates a new in-memory image cache.
    /// - Parameters:
    ///   - countLimit: Maximum number of images to cache (0 = no limit).
    ///   - totalCostLimit: Maximum total cost in bytes (0 = no limit).
    public init(countLimit: Int = 100, totalCostLimit: Int = 50 * 1024 * 1024) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }

    public func image(for url: URL) async -> UIImage? {
        await withCheckedContinuation { continuation in
            queue.sync {
                continuation.resume(returning: cache.object(forKey: url as NSURL))
            }
        }
    }

    public func store(_ image: UIImage, for url: URL) async {
        await withCheckedContinuation { continuation in
            queue.async(flags: .barrier) { [weak self] in
                let cost = Int(image.size.width * image.size.height * 4)
                self?.cache.setObject(image, forKey: url as NSURL, cost: cost)
                continuation.resume()
            }
        }
    }

    public func remove(for url: URL) async {
        await withCheckedContinuation { continuation in
            queue.async(flags: .barrier) { [weak self] in
                self?.cache.removeObject(forKey: url as NSURL)
                continuation.resume()
            }
        }
    }

    public func clear() async {
        await withCheckedContinuation { continuation in
            queue.async(flags: .barrier) { [weak self] in
                self?.cache.removeAllObjects()
                continuation.resume()
            }
        }
    }
}
