import XCTest
@testable import Common

/// Tests for GameDetailMapper.
final class GameDetailMapperTests: XCTestCase {
    // MARK: - Basic Mapping

    func test_map_gameDetailDTO_mapsAllRequiredFields() {
        // Arrange
        let dto = makeGameDetailDTO()

        // Act
        let entity = GameDetailMapper.map(dto)

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
            "The Witcher 3: Wild Hunt",
            "Expected name to match, got '\(entity.name)'"
        )
        XCTAssertEqual(
            entity.rating,
            4.8,
            "Expected rating to be 4.8, got \(entity.rating)"
        )
    }

    func test_map_gameDetailDTO_mapsOptionalStrings() {
        // Arrange
        let dto = makeGameDetailDTO(
            nameOriginal: "Wiedźmin 3: Dziki Gon",
            description: "<p>An action RPG</p>",
            descriptionRaw: "An action RPG"
        )

        // Act
        let entity = GameDetailMapper.map(dto)

        // Assert
        XCTAssertEqual(
            entity.nameOriginal,
            "Wiedźmin 3: Dziki Gon",
            "Expected nameOriginal to be preserved, got '\(entity.nameOriginal ?? "nil")'"
        )
        XCTAssertEqual(
            entity.description,
            "<p>An action RPG</p>",
            "Expected HTML description to be preserved"
        )
        XCTAssertEqual(
            entity.descriptionRaw,
            "An action RPG",
            "Expected raw description to be preserved"
        )
    }

    // MARK: - URL Mapping

    func test_map_gameDetailDTO_mapsValidURLs() {
        // Arrange
        let dto = makeGameDetailDTO(
            backgroundImage: "https://example.com/main.jpg",
            backgroundImageAdditional: "https://example.com/additional.jpg",
            website: "https://thewitcher.com"
        )

        // Act
        let entity = GameDetailMapper.map(dto)

        // Assert
        XCTAssertNotNil(
            entity.backgroundImage,
            "Expected backgroundImage URL to be non-nil"
        )
        XCTAssertNotNil(
            entity.backgroundImageAdditional,
            "Expected backgroundImageAdditional URL to be non-nil"
        )
        XCTAssertEqual(
            entity.website?.host,
            "thewitcher.com",
            "Expected website host to be 'thewitcher.com'"
        )
    }

    func test_map_gameDetailDTO_withNilURLs_returnsNilURLs() {
        // Arrange
        let dto = makeGameDetailDTO(
            backgroundImage: nil,
            backgroundImageAdditional: nil,
            website: nil
        )

        // Act
        let entity = GameDetailMapper.map(dto)

        // Assert
        XCTAssertNil(
            entity.backgroundImage,
            "Expected backgroundImage to be nil when DTO value is nil"
        )
        XCTAssertNil(
            entity.backgroundImageAdditional,
            "Expected backgroundImageAdditional to be nil when DTO value is nil"
        )
        XCTAssertNil(
            entity.website,
            "Expected website to be nil when DTO value is nil"
        )
    }

    // MARK: - Developers and Publishers

    func test_map_gameDetailDTO_mapsDevelopers() {
        // Arrange
        let developers = [
            DeveloperDTO(id: 1, name: "CD Projekt Red", slug: "cd-projekt-red")
        ]
        let dto = makeGameDetailDTO(developers: developers)

        // Act
        let entity = GameDetailMapper.map(dto)

        // Assert
        XCTAssertEqual(
            entity.developers.count,
            1,
            "Expected 1 developer, got \(entity.developers.count)"
        )
        XCTAssertEqual(
            entity.developers[0].name,
            "CD Projekt Red",
            "Expected developer name to be 'CD Projekt Red'"
        )
    }

    func test_map_gameDetailDTO_mapsPublishers() {
        // Arrange
        let publishers = [
            PublisherDTO(id: 1, name: "CD Projekt", slug: "cd-projekt"),
            PublisherDTO(id: 2, name: "Bandai Namco", slug: "bandai-namco")
        ]
        let dto = makeGameDetailDTO(publishers: publishers)

        // Act
        let entity = GameDetailMapper.map(dto)

        // Assert
        XCTAssertEqual(
            entity.publishers.count,
            2,
            "Expected 2 publishers, got \(entity.publishers.count)"
        )
    }

    func test_map_gameDetailDTO_withNilDevelopersAndPublishers_returnsEmptyArrays() {
        // Arrange
        let dto = makeGameDetailDTO(developers: nil, publishers: nil)

        // Act
        let entity = GameDetailMapper.map(dto)

        // Assert
        XCTAssertTrue(
            entity.developers.isEmpty,
            "Expected developers to be empty when DTO value is nil"
        )
        XCTAssertTrue(
            entity.publishers.isEmpty,
            "Expected publishers to be empty when DTO value is nil"
        )
    }

    // MARK: - Helpers

    private func makeGameDetailDTO(
        id: Int = 1,
        slug: String = "witcher-3",
        name: String = "The Witcher 3: Wild Hunt",
        nameOriginal: String? = nil,
        description: String? = nil,
        descriptionRaw: String? = nil,
        released: String? = "2015-05-19",
        backgroundImage: String? = "https://example.com/image.jpg",
        backgroundImageAdditional: String? = nil,
        website: String? = nil,
        rating: Double = 4.8,
        ratingsCount: Int = 5000,
        metacritic: Int? = 93,
        playtime: Int = 50,
        platforms: [PlatformWrapperDTO]? = [],
        genres: [GenreDTO]? = [],
        developers: [DeveloperDTO]? = [],
        publishers: [PublisherDTO]? = []
    ) -> GameDetailDTO {
        let json: [String: Any?] = [
            "id": id,
            "slug": slug,
            "name": name,
            "name_original": nameOriginal,
            "description": description,
            "description_raw": descriptionRaw,
            "released": released,
            "background_image": backgroundImage,
            "background_image_additional": backgroundImageAdditional,
            "website": website,
            "rating": rating,
            "ratings_count": ratingsCount,
            "metacritic": metacritic,
            "playtime": playtime,
            "platforms": platforms?.map { wrapper in
                ["platform": ["id": wrapper.platform.id, "name": wrapper.platform.name, "slug": wrapper.platform.slug]]
            },
            "genres": genres?.map { ["id": $0.id, "name": $0.name, "slug": $0.slug] },
            "developers": developers?.map { ["id": $0.id, "name": $0.name, "slug": $0.slug] },
            "publishers": publishers?.map { ["id": $0.id, "name": $0.name, "slug": $0.slug] }
        ]

        // swiftlint:disable:next force_try
        let data = try! JSONSerialization.data(withJSONObject: json.compactMapValues { $0 })
        // swiftlint:disable:next force_try
        return try! JSONDecoder().decode(GameDetailDTO.self, from: data)
    }
}
