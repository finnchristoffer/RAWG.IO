import XCTest
@testable import Common

/// Tests for Game model decoding.
final class GameTests: XCTestCase {
    func test_game_decodes_from_valid_json() throws {
        // Arrange
        let json = Data("""
        {
            "id": 1,
            "slug": "test-game",
            "name": "Test Game",
            "released": "2024-01-15",
            "background_image": "https://example.com/image.jpg",
            "rating": 4.5,
            "ratings_count": 100,
            "metacritic": 85,
            "playtime": 20,
            "platforms": [
                {"platform": {"id": 1, "name": "PC", "slug": "pc"}}
            ],
            "genres": [
                {"id": 1, "name": "Action", "slug": "action"}
            ]
        }
        """.utf8)

        // Act
        let sut = try JSONDecoder().decode(Game.self, from: json)

        // Assert
        XCTAssertEqual(sut.id, 1)
        XCTAssertEqual(sut.name, "Test Game")
        XCTAssertEqual(sut.rating, 4.5)
        XCTAssertEqual(sut.metacritic, 85)
        XCTAssertEqual(sut.platforms?.first?.platform.name, "PC")
        XCTAssertEqual(sut.genres?.first?.name, "Action")
    }

    func test_game_decodes_with_missing_optional_fields() throws {
        // Arrange
        let json = Data("""
        {
            "id": 1,
            "slug": "test",
            "name": "Test",
            "released": null,
            "background_image": null,
            "rating": 0,
            "ratings_count": 0,
            "metacritic": null,
            "playtime": 0,
            "platforms": null,
            "genres": null
        }
        """.utf8)

        // Act
        let sut = try JSONDecoder().decode(Game.self, from: json)

        // Assert
        XCTAssertEqual(sut.id, 1)
        XCTAssertNil(sut.released)
        XCTAssertNil(sut.backgroundImage)
        XCTAssertNil(sut.metacritic)
        XCTAssertNil(sut.platforms)
        XCTAssertNil(sut.genres)
    }
}
