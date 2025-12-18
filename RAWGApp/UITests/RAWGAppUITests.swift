import XCTest

final class RAWGAppUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testAppLaunches() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify tab bar exists
        XCTAssertTrue(app.tabBars.element.exists)
    }
}
