import XCTest

/// Extension providing additional testing utilities.
public extension XCTestCase {
    /// Creates test data from a JSON file in the test bundle.
    func loadJSON<T: Decodable>(
        _ filename: String,
        as type: T.Type,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> T {
        let bundle = Bundle(for: Self.self)
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            XCTFail("Missing file: \(filename).json", file: file, line: line)
            throw TestError.missingFile(filename)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Waits for an async operation with timeout.
    func awaitResult<T: Sendable>(
        timeout: TimeInterval = 1.0,
        _ operation: @escaping @Sendable () async throws -> T
    ) async throws -> T {
        try await withTimeout(seconds: timeout) {
            try await operation()
        }
    }

    /// Expects an async operation to throw a specific error.
    func expectError<E: Error & Equatable>(
        _ expectedError: E,
        file: StaticString = #filePath,
        line: UInt = #line,
        from operation: @Sendable () async throws -> some Any
    ) async {
        do {
            _ = try await operation()
            XCTFail("Expected error \(expectedError) but operation succeeded", file: file, line: line)
        } catch let error as E {
            XCTAssertEqual(error, expectedError, file: file, line: line)
        } catch {
            XCTFail("Expected \(E.self) but got \(type(of: error))", file: file, line: line)
        }
    }
}

private func withTimeout<T: Sendable>(
    seconds: TimeInterval,
    operation: @escaping @Sendable () async throws -> T
) async throws -> T {
    try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask { try await operation() }
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            throw TestError.timeout
        }
        guard let result = try await group.next() else {
            throw TestError.unexpectedNil
        }
        group.cancelAll()
        return result
    }
}
