import XCTest
@testable import Core

/// Tests for InMemoryImageCache
final class InMemoryImageCacheTests: XCTestCase {
    // MARK: - Store and Retrieve Tests

    func test_image_returnsNil_whenCacheIsEmpty() async {
        // Arrange
        let sut = makeSUT()
        let url = anyURL()

        // Act
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNil(result, "Expected nil for empty cache")
    }

    func test_image_returnsStoredImage_afterStore() async {
        // Arrange
        let sut = makeSUT()
        let url = anyURL()
        let image = anyImage()

        // Act
        await sut.store(image, for: url)
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNotNil(result, "Expected image to be retrieved after storing")
    }

    func test_store_overwritesExistingImage_forSameURL() async {
        // Arrange
        let sut = makeSUT()
        let url = anyURL()
        let firstImage = anyImage(color: .red)
        let secondImage = anyImage(color: .blue)

        // Act
        await sut.store(firstImage, for: url)
        await sut.store(secondImage, for: url)
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNotNil(result, "Expected second image to be retrievable")
    }

    func test_image_returnsCorrectImage_forMultipleURLs() async throws {
        // Arrange
        let sut = makeSUT()
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

    func test_remove_deletesStoredImage() async {
        // Arrange
        let sut = makeSUT()
        let url = anyURL()
        await sut.store(anyImage(), for: url)

        // Act
        await sut.remove(for: url)
        let result = await sut.image(for: url)

        // Assert
        XCTAssertNil(result, "Expected image to be removed")
    }

    func test_remove_doesNotAffectOtherImages() async throws {
        // Arrange
        let sut = makeSUT()
        let url1 = try XCTUnwrap(URL(string: "https://example.com/image1.jpg"))
        let url2 = try XCTUnwrap(URL(string: "https://example.com/image2.jpg"))
        await sut.store(anyImage(), for: url1)
        await sut.store(anyImage(), for: url2)

        // Act
        await sut.remove(for: url1)

        // Assert
        let result1 = await sut.image(for: url1)
        let result2 = await sut.image(for: url2)
        XCTAssertNil(result1, "Expected image1 to be removed")
        XCTAssertNotNil(result2, "Expected image2 to still exist")
    }

    // MARK: - Clear Tests

    func test_clear_removesAllImages() async throws {
        // Arrange
        let sut = makeSUT()
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

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> InMemoryImageCache {
        let sut = InMemoryImageCache()
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
