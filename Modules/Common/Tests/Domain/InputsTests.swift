import XCTest
@testable import Common

/// Tests for domain input structs.
final class InputsTests: XCTestCase {
    // MARK: - GamesInput

    func test_gamesInput_has_default_values() {
        let sut = GamesInput()

        XCTAssertEqual(sut.page, 1)
        XCTAssertEqual(sut.pageSize, 20)
    }

    func test_gamesInput_accepts_custom_values() {
        let sut = GamesInput(page: 5, pageSize: 50)

        XCTAssertEqual(sut.page, 5)
        XCTAssertEqual(sut.pageSize, 50)
    }

    // MARK: - GameDetailInput

    func test_gameDetailInput_stores_id() {
        let sut = GameDetailInput(id: 123)

        XCTAssertEqual(sut.id, 123)
    }

    // MARK: - SearchGamesInput

    func test_searchGamesInput_has_default_page() {
        let sut = SearchGamesInput(query: "zelda")

        XCTAssertEqual(sut.query, "zelda")
        XCTAssertEqual(sut.page, 1)
    }

    func test_searchGamesInput_accepts_custom_page() {
        let sut = SearchGamesInput(query: "mario", page: 3)

        XCTAssertEqual(sut.query, "mario")
        XCTAssertEqual(sut.page, 3)
    }
}
