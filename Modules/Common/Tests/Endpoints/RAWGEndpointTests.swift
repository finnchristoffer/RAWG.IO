import XCTest
@testable import Common

/// Tests for RAWG configuration.
final class RAWGConfigurationTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        RAWGConfiguration.setAPIKey("")
    }

    func test_baseURL_is_correct() {
        XCTAssertEqual(RAWGConfiguration.baseURL.absoluteString, "https://api.rawg.io/api")
    }

    func test_defaultPageSize_is_20() {
        XCTAssertEqual(RAWGConfiguration.defaultPageSize, 20)
    }

    func test_apiKey_can_be_set_and_retrieved() {
        RAWGConfiguration.setAPIKey("test_key")

        XCTAssertEqual(RAWGConfiguration.apiKey, "test_key")
    }

    func test_apiKey_is_empty_by_default() {
        RAWGConfiguration.setAPIKey("")

        XCTAssertEqual(RAWGConfiguration.apiKey, "")
    }
}
