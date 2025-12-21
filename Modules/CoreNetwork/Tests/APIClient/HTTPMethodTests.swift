import XCTest
@testable import CoreNetwork

/// Tests for HTTPMethod enum.
final class HTTPMethodTests: XCTestCase {
    func test_get_has_correct_raw_value() {
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
    }

    func test_post_has_correct_raw_value() {
        XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
    }

    func test_put_has_correct_raw_value() {
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
    }

    func test_delete_has_correct_raw_value() {
        XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")
    }

    func test_patch_has_correct_raw_value() {
        XCTAssertEqual(HTTPMethod.patch.rawValue, "PATCH")
    }
}
