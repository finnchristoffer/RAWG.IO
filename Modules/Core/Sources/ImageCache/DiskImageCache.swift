import UIKit
import CryptoKit

/// Disk-based image cache for persistent storage.
///
/// Stores images as files in the specified directory,
/// using URL hashes as filenames.
///
/// ## Features
/// - Persistent storage across app launches
/// - Thread-safe via dispatch queue
/// - Automatic directory creation
public final class DiskImageCache: ImageCacheProtocol, @unchecked Sendable {
    private let directory: URL
    private let fileManager: FileManager
    private let queue = DispatchQueue(label: "com.rawg.disk-cache", attributes: .concurrent)

    /// Creates a new disk image cache.
    /// - Parameter directory: Directory for storing cached images.
    ///   Defaults to Caches/ImageCache.
    public init(
        directory: URL? = nil,
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        let cacheDir = fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
        self.directory = directory ?? cacheDir

        try? fileManager.createDirectory(
            at: self.directory,
            withIntermediateDirectories: true
        )
    }

    public func image(for url: URL) async -> UIImage? {
        await withCheckedContinuation { continuation in
            queue.sync { [self] in
                let path = filePath(for: url)
                guard let data = try? Data(contentsOf: path) else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: UIImage(data: data))
            }
        }
    }

    public func store(_ image: UIImage, for url: URL) async {
        await withCheckedContinuation { continuation in
            queue.async(flags: .barrier) { [self] in
                let path = filePath(for: url)
                guard let data = image.jpegData(compressionQuality: 0.8) else {
                    continuation.resume()
                    return
                }
                try? data.write(to: path)
                continuation.resume()
            }
        }
    }

    public func remove(for url: URL) async {
        await withCheckedContinuation { continuation in
            queue.async(flags: .barrier) { [self] in
                let path = filePath(for: url)
                try? fileManager.removeItem(at: path)
                continuation.resume()
            }
        }
    }

    public func clear() async {
        await withCheckedContinuation { continuation in
            queue.async(flags: .barrier) { [self] in
                guard let files = try? fileManager.contentsOfDirectory(
                    at: directory,
                    includingPropertiesForKeys: nil
                ) else {
                    continuation.resume()
                    return
                }
                for file in files {
                    try? fileManager.removeItem(at: file)
                }
                continuation.resume()
            }
        }
    }

    // MARK: - Private

    private func filePath(for url: URL) -> URL {
        let hash = SHA256.hash(data: Data(url.absoluteString.utf8))
        let filename = hash.compactMap { String(format: "%02x", $0) }.joined()
        return directory.appendingPathComponent(filename)
    }
}
