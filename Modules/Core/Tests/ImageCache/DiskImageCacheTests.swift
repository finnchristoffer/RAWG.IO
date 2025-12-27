import XCTest
@testable import Core

/// Tests for DiskImageCache
final class DiskImageCacheTests: XCTestCase {
    private var testDirectory: URL?

    override func setUp() async throws {
        try await super.setUp()
        testDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        guard let testDirectory else { return }
        try FileManager.default.createDirectory(
            at: testDirectory,
            withIntermediateDirectories: true
        )
    }

    override func tearDown() async throws {
        if let testDirectory {
            try? FileManager.default.removeItem(at: testDirectory)
        }
        try await super.tearDown()
    }

    // MARK: - Store and Retrieve Tests

    func test_image_returnsNil_whenCacheIsEmpty() async throws {
        // Arrange
        let sut = try makeSUT()
        let url = anyURL()

        // Act
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNil(result, "Expected nil for empty cache")
    }

    func test_image_returnsStoredImage_afterStore() async throws {
        // Arrange
        let sut = try makeSUT()
        let url = anyURL()
        let image = anyImage()

        // Act
        await sut.store(image, for: url)
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNotNil(result, "Expected image to be retrieved after storing")
    }

    func test_store_persistsImageToDisk() async throws {
        // Arrange
        let sut = try makeSUT()
        let url = anyURL()
        let image = anyImage()

        // Act
        await sut.store(image, for: url)

        // Assert
        let directory = try XCTUnwrap(testDirectory)
        let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        XCTAssertFalse(files.isEmpty, "Expected file to be persisted to disk")
    }

    func test_image_returnsCorrectImage_forMultipleURLs() async throws {
        // Arrange
        let sut = try makeSUT()
        let url1 = try XCTUnwrap(URL(string: "https://example.com/image1.jpg"))
        let url2 = try XCTUnwrap(URL(string: "https://example.com/image2.jpg"))
        let image1 = anyImage(color: .red)
        let image2 = anyImage(color: .blue)

        // Act
        await sut.store(image1, for: url1)
        await sut.store(image2, for: url2)

        // Assert
        let result1 = await sut.image(for: url1)
        let result2 = await sut.image(for: url2)
        XCTAssertNotNil(result1, "Expected image1 to be retrievable")
        XCTAssertNotNil(result2, "Expected image2 to be retrievable")
    }

    // MARK: - Remove Tests

    func test_remove_deletesStoredImage() async throws {
        // Arrange
        let sut = try makeSUT()
        let url = anyURL()
        await sut.store(anyImage(), for: url)

        // Act
        await sut.remove(for: url)
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNil(result, "Expected image to be removed")
    }

    func test_remove_deletesFileFromDisk() async throws {
        // Arrange
        let sut = try makeSUT()
        let url = anyURL()
        await sut.store(anyImage(), for: url)

        // Act
        await sut.remove(for: url)

        // Assert
        let directory = try XCTUnwrap(testDirectory)
        let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        XCTAssertTrue(files.isEmpty, "Expected file to be deleted from disk")
    }

    // MARK: - Clear Tests

    func test_clear_removesAllImages() async throws {
        // Arrange
        let sut = try makeSUT()
        let url1 = try XCTUnwrap(URL(string: "https://example.com/image1.jpg"))
        let url2 = try XCTUnwrap(URL(string: "https://example.com/image2.jpg"))
        await sut.store(anyImage(), for: url1)
        await sut.store(anyImage(), for: url2)

        // Act
        await sut.clear()

        // Assert
        let result1 = await sut.image(for: url1)
        let result2 = await sut.image(for: url2)
        XCTAssertNil(result1, "Expected all images to be cleared")
        XCTAssertNil(result2, "Expected all images to be cleared")
    }

    func test_clear_removesAllFilesFromDisk() async throws {
        // Arrange
        let sut = try makeSUT()
        let url1 = try XCTUnwrap(URL(string: "https://example.com/1.jpg"))
        let url2 = try XCTUnwrap(URL(string: "https://example.com/2.jpg"))
        await sut.store(anyImage(), for: url1)
        await sut.store(anyImage(), for: url2)

        // Act
        await sut.clear()

        // Assert
        let directory = try XCTUnwrap(testDirectory)
        let files = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        XCTAssertTrue(files.isEmpty, "Expected all files to be cleared from disk")
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> DiskImageCache {
        let directory = try XCTUnwrap(testDirectory)
        let sut = DiskImageCache(directory: directory)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
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
