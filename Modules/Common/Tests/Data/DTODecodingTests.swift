import XCTest
@testable import Common

/// Tests for DTO decoding from JSON.
final class DTODecodingTests: XCTestCase {
    // MARK: - GameDTO Tests

    func test_gameDTO_decodesFromFullJSON() throws {
        // Arrange
        let json = """
        {
            "id": 3498,
            "slug": "grand-theft-auto-v",
            "name": "Grand Theft Auto V",
            "released": "2013-09-17",
            "background_image": "https://media.rawg.io/games/456/456abc.jpg",
            "rating": 4.48,
            "ratings_count": 6421,
            "metacritic": 97,
            "playtime": 73,
            "platforms": [
                {"platform": {"id": 4, "name": "PC", "slug": "pc"}},
                {"platform": {"id": 18, "name": "PlayStation 4", "slug": "playstation4"}}
            ],
            "genres": [
                {"id": 4, "name": "Action", "slug": "action"}
            ]
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Act
        let dto = try JSONDecoder().decode(GameDTO.self, from: data)

        // Assert
        XCTAssertEqual(dto.id, 3498, "Expected id to be 3498")
        XCTAssertEqual(dto.slug, "grand-theft-auto-v", "Expected slug to match")
        XCTAssertEqual(dto.name, "Grand Theft Auto V", "Expected name to match")
        XCTAssertEqual(dto.released, "2013-09-17", "Expected released to match")
        XCTAssertEqual(dto.backgroundImage, "https://media.rawg.io/games/456/456abc.jpg", "Expected backgroundImage")
        XCTAssertEqual(dto.rating, 4.48, "Expected rating to be 4.48")
        XCTAssertEqual(dto.ratingsCount, 6421, "Expected ratingsCount to be 6421")
        XCTAssertEqual(dto.metacritic, 97, "Expected metacritic to be 97")
        XCTAssertEqual(dto.playtime, 73, "Expected playtime to be 73")
        XCTAssertEqual(dto.platforms?.count, 2, "Expected 2 platforms")
        XCTAssertEqual(dto.genres?.count, 1, "Expected 1 genre")
    }

    func test_gameDTO_decodesWithNilOptionals() throws {
        // Arrange
        let json = """
        {
            "id": 1,
            "slug": "game",
            "name": "Game",
            "rating": 0,
            "ratings_count": 0,
            "playtime": 0
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Act
        let dto = try JSONDecoder().decode(GameDTO.self, from: data)

        // Assert
        XCTAssertNil(dto.released, "Expected released to be nil")
        XCTAssertNil(dto.backgroundImage, "Expected backgroundImage to be nil")
        XCTAssertNil(dto.metacritic, "Expected metacritic to be nil")
        XCTAssertNil(dto.platforms, "Expected platforms to be nil")
        XCTAssertNil(dto.genres, "Expected genres to be nil")
    }

    // MARK: - PlatformDTO Tests

    func test_platformDTO_decodesCorrectly() throws {
        // Arrange
        let json = """
        {"id": 4, "name": "PC", "slug": "pc"}
        """
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Act
        let dto = try JSONDecoder().decode(PlatformDTO.self, from: data)

        // Assert
        XCTAssertEqual(dto.id, 4, "Expected id to be 4")
        XCTAssertEqual(dto.name, "PC", "Expected name to be 'PC'")
        XCTAssertEqual(dto.slug, "pc", "Expected slug to be 'pc'")
    }

    // MARK: - GenreDTO Tests

    func test_genreDTO_decodesCorrectly() throws {
        // Arrange
        let json = """
        {"id": 5, "name": "RPG", "slug": "role-playing-games-rpg"}
        """
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Act
        let dto = try JSONDecoder().decode(GenreDTO.self, from: data)

        // Assert
        XCTAssertEqual(dto.id, 5, "Expected id to be 5")
        XCTAssertEqual(dto.name, "RPG", "Expected name to be 'RPG'")
        XCTAssertEqual(dto.slug, "role-playing-games-rpg", "Expected slug to match")
    }

    // MARK: - PlatformWrapperDTO Tests

    func test_platformWrapperDTO_decodesCorrectly() throws {
        // Arrange
        let json = """
        {"platform": {"id": 18, "name": "PlayStation 4", "slug": "playstation4"}}
        """
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Act
        let dto = try JSONDecoder().decode(PlatformWrapperDTO.self, from: data)

        // Assert
        XCTAssertEqual(dto.platform.id, 18, "Expected platform id to be 18")
        XCTAssertEqual(dto.platform.name, "PlayStation 4", "Expected platform name")
    }

    // MARK: - GameDetailDTO Tests

    func test_gameDetailDTO_decodesFromFullJSON() throws {
        // Arrange
        let json = """
        {
            "id": 3498,
            "slug": "grand-theft-auto-v",
            "name": "Grand Theft Auto V",
            "name_original": "Grand Theft Auto V",
            "description": "<p>HTML description</p>",
            "description_raw": "Raw description",
            "released": "2013-09-17",
            "background_image": "https://media.rawg.io/games/456.jpg",
            "background_image_additional": "https://media.rawg.io/games/456_2.jpg",
            "website": "https://www.rockstargames.com/V",
            "rating": 4.48,
            "ratings_count": 6421,
            "metacritic": 97,
            "playtime": 73,
            "platforms": [],
            "genres": [],
            "developers": [{"id": 1, "name": "Rockstar North", "slug": "rockstar-north"}],
            "publishers": [{"id": 2, "name": "Rockstar Games", "slug": "rockstar-games"}]
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Act
        let dto = try JSONDecoder().decode(GameDetailDTO.self, from: data)

        // Assert
        XCTAssertEqual(dto.id, 3498, "Expected id to be 3498")
        XCTAssertEqual(dto.nameOriginal, "Grand Theft Auto V", "Expected nameOriginal")
        XCTAssertEqual(dto.description, "<p>HTML description</p>", "Expected HTML description")
        XCTAssertEqual(dto.descriptionRaw, "Raw description", "Expected raw description")
        XCTAssertEqual(dto.website, "https://www.rockstargames.com/V", "Expected website URL")
        XCTAssertEqual(dto.developers?.count, 1, "Expected 1 developer")
        XCTAssertEqual(dto.publishers?.count, 1, "Expected 1 publisher")
    }

    // MARK: - PaginatedResponseDTO Tests

    func test_paginatedResponseDTO_decodesCorrectly() throws {
        // Arrange
        let json = """
        {
            "count": 850458,
            "next": "https://api.rawg.io/api/games?page=2",
            "previous": null,
            "results": [
                {"id": 1, "slug": "game1", "name": "Game 1", "rating": 4.0, "ratings_count": 100, "playtime": 10}
            ]
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Act
        let dto = try JSONDecoder().decode(PaginatedResponseDTO<GameDTO>.self, from: data)

        // Assert
        XCTAssertEqual(dto.count, 850458, "Expected count to be 850458")
        XCTAssertEqual(dto.next, "https://api.rawg.io/api/games?page=2", "Expected next URL")
        XCTAssertNil(dto.previous, "Expected previous to be nil")
        XCTAssertEqual(dto.results.count, 1, "Expected 1 result")
    }

    func test_paginatedResponseDTO_handlesBothNextAndPrevious() throws {
        // Arrange
        let json = """
        {
            "count": 100,
            "next": "https://api.rawg.io/api/games?page=3",
            "previous": "https://api.rawg.io/api/games?page=1",
            "results": []
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))

        // Act
        let dto = try JSONDecoder().decode(PaginatedResponseDTO<GameDTO>.self, from: data)

        // Assert
        XCTAssertNotNil(dto.next, "Expected next to be present")
        XCTAssertNotNil(dto.previous, "Expected previous to be present")
    }
}
