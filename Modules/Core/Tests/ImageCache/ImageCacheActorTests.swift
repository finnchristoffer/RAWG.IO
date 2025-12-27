import XCTest
@testable import Core

/// Tests for ImageCacheActor
final class ImageCacheActorTests: XCTestCase {
    // MARK: - Tiered Cache Tests

    func test_image_returnsNil_whenBothCachesEmpty() async {
        // Arrange
        let sut = makeSUT()
        let url = anyURL()

        // Act
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNil(result, "Expected nil when both caches are empty")
    }

    func test_store_savesToBothCaches() async {
        // Arrange
        let memoryCache = InMemoryImageCache()
        let diskCache = DiskImageCache(directory: testDirectory())
        let sut = ImageCacheActor(memoryCache: memoryCache, diskCache: diskCache)
        let url = anyURL()
        let image = anyImage()

        // Act
        await sut.store(image, for: url)

        // Assert
        let memoryResult = await memoryCache.image(for: url)
        let diskResult = await diskCache.image(for: url)
        XCTAssertNotNil(memoryResult, "Expected image in memory cache")
        XCTAssertNotNil(diskResult, "Expected image in disk cache")
    }

    func test_image_returnsFromMemoryFirst() async {
        // Arrange
        let memoryCache = InMemoryImageCache()
        let diskCache = DiskImageCache(directory: testDirectory())
        let sut = ImageCacheActor(memoryCache: memoryCache, diskCache: diskCache)
        let url = anyURL()
        let image = anyImage()

        // Store only in memory
        await memoryCache.store(image, for: url)

        // Act
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNotNil(result, "Expected image from memory cache")
    }

    func test_image_fallsToDiskCache_whenMemoryEmpty() async {
        // Arrange
        let memoryCache = InMemoryImageCache()
        let diskCache = DiskImageCache(directory: testDirectory())
        let sut = ImageCacheActor(memoryCache: memoryCache, diskCache: diskCache)
        let url = anyURL()
        let image = anyImage()

        // Store only in disk
        await diskCache.store(image, for: url)

        // Act
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNotNil(result, "Expected image from disk cache")
    }

    func test_image_promotesToMemory_afterDiskHit() async {
        // Arrange
        let memoryCache = InMemoryImageCache()
        let diskCache = DiskImageCache(directory: testDirectory())
        let sut = ImageCacheActor(memoryCache: memoryCache, diskCache: diskCache)
        let url = anyURL()
        let image = anyImage()

        // Store only in disk
        await diskCache.store(image, for: url)

        // Act - fetch triggers promotion
        _ = await sut.image(for: url)

        // Assert - now in memory
        let memoryResult = await memoryCache.image(for: url)
        XCTAssertNotNil(memoryResult, "Expected image to be promoted to memory")
    }

    func test_clear_removesBothCaches() async {
        // Arrange
        let memoryCache = InMemoryImageCache()
        let diskCache = DiskImageCache(directory: testDirectory())
        let sut = ImageCacheActor(memoryCache: memoryCache, diskCache: diskCache)
        let url = anyURL()

        await sut.store(anyImage(), for: url)

        // Act
        await sut.clear()

        // Assert
        let result = await sut.image(for: url)
        XCTAssertNil(result, "Expected all caches to be cleared")
    }

    // MARK: - Helpers

    private func makeSUT() -> ImageCacheActor {
        ImageCacheActor(
            memoryCache: InMemoryImageCache(),
            diskCache: DiskImageCache(directory: testDirectory())
        )
    }

    private func testDirectory() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
    }

    private func anyURL() -> URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "https://example.com/image.jpg")!
    }

    private func anyImage(color: UIColor = .red) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}
