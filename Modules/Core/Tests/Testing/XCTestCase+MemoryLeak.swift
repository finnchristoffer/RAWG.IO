import XCTest

/// Extension providing memory leak tracking for tests.
///
/// ## Usage
/// ```swift
/// func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> MyClass {
///     let sut = MyClass()
///     trackForMemoryLeaks(sut, file: file, line: line)
///     return sut
/// }
/// ```
public extension XCTestCase {
    /// Tracks an instance for memory leaks.
    ///
    /// If the instance is not deallocated after the test completes,
    /// the test will fail with a memory leak warning pointing to the
    /// exact line where this method was called.
    ///
    /// - Parameters:
    ///   - instance: The object to track for memory leaks
    ///   - file: Source file where tracking was initiated (auto-captured)
    ///   - line: Source line where tracking was initiated (auto-captured)
    func trackForMemoryLeaks(
        _ instance: some AnyObject & Sendable,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { @Sendable [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}
