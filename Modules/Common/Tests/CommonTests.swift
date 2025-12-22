import XCTest
@testable import Common

/// Tests for Common module.
final class CommonTests: XCTestCase {
    func testCommonModuleLoads() {
        XCTAssertEqual(CommonModule.version, "1.0.0")
    }
}
