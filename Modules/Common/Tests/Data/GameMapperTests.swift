import XCTest
@testable import Common

/// Tests for GameMapper.
final class GameMapperTests: XCTestCase {
    // MARK: - GameDTO to GameEntity

    func test_map_gameDTO_mapsAllFields() {
        // Arrange
        let dto = makeGameDTO()

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertEqual(
            entity.id,
            1,
            "Expected entity ID to be 1, got \(entity.id)"
        )
        XCTAssertEqual(
            entity.slug,
            "witcher-3",
            "Expected slug to be 'witcher-3', got '\(entity.slug)'"
        )
        XCTAssertEqual(
            entity.name,
            "The Witcher 3",
            "Expected name to be 'The Witcher 3', got '\(entity.name)'"
        )
        XCTAssertEqual(
            entity.released,
            "2015-05-19",
            "Expected released date to be '2015-05-19', got '\(entity.released ?? "nil")'"
        )
        XCTAssertEqual(
            entity.rating,
            4.8,
            "Expected rating to be 4.8, got \(entity.rating)"
        )
        XCTAssertEqual(
            entity.ratingsCount,
            5000,
            "Expected ratingsCount to be 5000, got \(entity.ratingsCount)"
        )
        XCTAssertEqual(
            entity.metacritic,
            93,
            "Expected metacritic to be 93, got \(entity.metacritic ?? 0)"
        )
        XCTAssertEqual(
            entity.playtime,
            50,
            "Expected playtime to be 50, got \(entity.playtime)"
        )
    }

    func test_map_gameDTO_withValidBackgroundImage_convertsToURL() {
        // Arrange
        let dto = makeGameDTO(backgroundImage: "https://example.com/image.jpg")

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertNotNil(
            entity.backgroundImage,
            "Expected backgroundImage URL to be non-nil when valid URL string is provided"
        )
        XCTAssertEqual(
            entity.backgroundImage?.absoluteString,
            "https://example.com/image.jpg",
            "Expected backgroundImage URL to match the provided string"
        )
    }

    func test_map_gameDTO_withNilBackgroundImage_returnsNilURL() {
        // Arrange
        let dto = makeGameDTO(backgroundImage: nil)

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertNil(
            entity.backgroundImage,
            "Expected backgroundImage to be nil when DTO has nil backgroundImage"
        )
    }

    func test_map_gameDTO_withEmptyBackgroundImage_returnsNilURL() {
        // Arrange
        let dto = makeGameDTO(backgroundImage: "")

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertNil(
            entity.backgroundImage,
            "Expected backgroundImage to be nil when empty string is provided"
        )
    }

    func test_map_gameDTO_withPlatforms_mapsPlatformEntities() {
        // Arrange
        let platforms = [
            PlatformWrapperDTO(platform: PlatformDTO(id: 1, name: "PC", slug: "pc")),
            PlatformWrapperDTO(platform: PlatformDTO(id: 2, name: "PlayStation 5", slug: "ps5"))
        ]
        let dto = makeGameDTO(platforms: platforms)

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertEqual(
            entity.platforms.count,
            2,
            "Expected 2 platforms, got \(entity.platforms.count)"
        )
        XCTAssertEqual(
            entity.platforms[0].name,
            "PC",
            "Expected first platform name to be 'PC', got '\(entity.platforms[0].name)'"
        )
        XCTAssertEqual(
            entity.platforms[1].slug,
            "ps5",
            "Expected second platform slug to be 'ps5', got '\(entity.platforms[1].slug)'"
        )
    }

    func test_map_gameDTO_withNilPlatforms_returnsEmptyArray() {
        // Arrange
        let dto = makeGameDTO(platforms: nil)

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertTrue(
            entity.platforms.isEmpty,
            "Expected platforms to be empty when DTO has nil platforms, got \(entity.platforms.count) items"
        )
    }

    func test_map_gameDTO_withGenres_mapsGenreEntities() {
        // Arrange
        let genres = [
            GenreDTO(id: 1, name: "RPG", slug: "rpg"),
            GenreDTO(id: 2, name: "Action", slug: "action")
        ]
        let dto = makeGameDTO(genres: genres)

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertEqual(
            entity.genres.count,
            2,
            "Expected 2 genres, got \(entity.genres.count)"
        )
        XCTAssertEqual(
            entity.genres[0].name,
            "RPG",
            "Expected first genre name to be 'RPG', got '\(entity.genres[0].name)'"
        )
    }

    func test_map_gameDTO_withNilGenres_returnsEmptyArray() {
        // Arrange
        let dto = makeGameDTO(genres: nil)

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertTrue(
            entity.genres.isEmpty,
            "Expected genres to be empty when DTO has nil genres, got \(entity.genres.count) items"
        )
    }

    // MARK: - Array Mapping

    func test_map_gameDTOArray_mapsAllItems() {
        // Arrange
        let dtos = [
            makeGameDTO(id: 1, name: "Game 1"),
            makeGameDTO(id: 2, name: "Game 2"),
            makeGameDTO(id: 3, name: "Game 3")
        ]

        // Act
        let entities = GameMapper.map(dtos)

        // Assert
        XCTAssertEqual(
            entities.count,
            3,
            "Expected 3 entities, got \(entities.count)"
        )
        XCTAssertEqual(
            entities[0].id,
            1,
            "Expected first entity ID to be 1, got \(entities[0].id)"
        )
        XCTAssertEqual(
            entities[2].name,
            "Game 3",
            "Expected third entity name to be 'Game 3', got '\(entities[2].name)'"
        )
    }

    // MARK: - PaginatedResponse Mapping

    func test_map_paginatedResponse_mapsCorrectly() {
        // Arrange
        let dto = PaginatedResponseDTO(
            count: 100,
            next: "https://api.rawg.io/games?page=2",
            previous: nil,
            results: [makeGameDTO(id: 1), makeGameDTO(id: 2)]
        )

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertEqual(
            entity.count,
            100,
            "Expected count to be 100, got \(entity.count)"
        )
        XCTAssertTrue(
            entity.hasNextPage,
            "Expected hasNextPage to be true when 'next' URL is present"
        )
        XCTAssertFalse(
            entity.hasPreviousPage,
            "Expected hasPreviousPage to be false when 'previous' is nil"
        )
        XCTAssertEqual(
            entity.results.count,
            2,
            "Expected 2 results, got \(entity.results.count)"
        )
    }

    func test_map_paginatedResponse_withNoPagination() {
        // Arrange
        let dto = PaginatedResponseDTO(
            count: 5,
            next: nil,
            previous: nil,
            results: [makeGameDTO()]
        )

        // Act
        let entity = GameMapper.map(dto)

        // Assert
        XCTAssertFalse(
            entity.hasNextPage,
            "Expected hasNextPage to be false when 'next' is nil"
        )
        XCTAssertFalse(
            entity.hasPreviousPage,
            "Expected hasPreviousPage to be false when 'previous' is nil"
        )
    }

    // MARK: - Helpers

    private func makeGameDTO(
        id: Int = 1,
        slug: String = "witcher-3",
        name: String = "The Witcher 3",
        released: String? = "2015-05-19",
        backgroundImage: String? = "https://example.com/image.jpg",
        rating: Double = 4.8,
        ratingsCount: Int = 5000,
        metacritic: Int? = 93,
        playtime: Int = 50,
        platforms: [PlatformWrapperDTO]? = [],
        genres: [GenreDTO]? = []
    ) -> GameDTO {
        // Create DTO using JSON decoding since DTOs are Decodable
        let json: [String: Any?] = [
            "id": id,
            "slug": slug,
            "name": name,
            "released": released,
            "background_image": backgroundImage,
            "rating": rating,
            "ratings_count": ratingsCount,
            "metacritic": metacritic,
            "playtime": playtime,
            "platforms": platforms?.map { wrapper in
                ["platform": ["id": wrapper.platform.id, "name": wrapper.platform.name, "slug": wrapper.platform.slug]]
            },
            "genres": genres?.map { ["id": $0.id, "name": $0.name, "slug": $0.slug] }
        ]

        // swiftlint:disable:next force_try
        let data = try! JSONSerialization.data(withJSONObject: json.compactMapValues { $0 })
        // swiftlint:disable:next force_try
        return try! JSONDecoder().decode(GameDTO.self, from: data)
    }
}
