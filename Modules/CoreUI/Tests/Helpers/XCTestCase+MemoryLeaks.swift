import XCTest

/// XCTestCase extension for memory leak tracking.
///
/// ## Usage
/// ```swift
/// func test_example() {
///     let (sut, _) = makeSUT()
///     trackForMemoryLeaks(sut)
/// }
/// ```
public extension XCTestCase {
    /// Tracks an instance for memory leaks.
    ///
    /// Fails the test if the instance is not deallocated after the test ends.
    /// - Parameters:
    ///   - instance: The instance to track.
    ///   - file: The file where the assertion occurs.
    ///   - line: The line where the assertion occurs.
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // Use nonisolated(unsafe) to silence the Swift 6 warning
        // This is safe for test code where we're just checking deallocation
        nonisolated(unsafe) let weakInstance = WeakBox(instance)

        addTeardownBlock {
            XCTAssertNil(
                weakInstance.value,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}

/// Helper class to hold weak reference in Sendable context.
private final class WeakBox: @unchecked Sendable {
    weak var value: AnyObject?

    init(_ value: AnyObject) {
        self.value = value
    }
}
