import XCTest
@testable import Common

/// Tests for GameDetailEntity and supporting entities.
final class GameDetailEntityTests: XCTestCase {
    // MARK: - GameDetailEntity Tests

    func test_init_setsAllProperties() {
        // Arrange & Act
        let entity = makeFullGameDetailEntity()

        // Assert
        XCTAssertEqual(entity.id, 1, "Expected id to be 1")
        XCTAssertEqual(entity.slug, "witcher-3", "Expected slug to match")
        XCTAssertEqual(entity.name, "The Witcher 3", "Expected name to match")
        XCTAssertEqual(entity.nameOriginal, "The Witcher 3: Wild Hunt", "Expected nameOriginal to match")
        XCTAssertEqual(entity.description, "<p>HTML Description</p>", "Expected description to match")
        XCTAssertEqual(entity.descriptionRaw, "Raw Description", "Expected descriptionRaw to match")
        XCTAssertEqual(entity.released, "2015-05-19", "Expected released to match")
        XCTAssertEqual(entity.rating, 4.8, "Expected rating to match")
        XCTAssertEqual(entity.ratingsCount, 5000, "Expected ratingsCount to match")
        XCTAssertEqual(entity.metacritic, 93, "Expected metacritic to match")
        XCTAssertEqual(entity.playtime, 50, "Expected playtime to match")
    }

    func test_init_withNilOptionalValues() {
        // Arrange & Act
        let entity = GameDetailEntity(
            id: 1,
            slug: "game",
            name: "Game",
            nameOriginal: nil,
            description: nil,
            descriptionRaw: nil,
            released: nil,
            backgroundImage: nil,
            backgroundImageAdditional: nil,
            website: nil,
            rating: 0,
            ratingsCount: 0,
            metacritic: nil,
            playtime: 0,
            platforms: [],
            genres: [],
            developers: [],
            publishers: []
        )

        // Assert
        XCTAssertNil(entity.nameOriginal, "Expected nameOriginal to be nil")
        XCTAssertNil(entity.description, "Expected description to be nil")
        XCTAssertNil(entity.descriptionRaw, "Expected descriptionRaw to be nil")
        XCTAssertNil(entity.released, "Expected released to be nil")
        XCTAssertNil(entity.backgroundImage, "Expected backgroundImage to be nil")
        XCTAssertNil(entity.backgroundImageAdditional, "Expected backgroundImageAdditional to be nil")
        XCTAssertNil(entity.website, "Expected website to be nil")
        XCTAssertNil(entity.metacritic, "Expected metacritic to be nil")
    }

    func test_identifiable_usesIdAsIdentifier() {
        // Arrange
        let entity = makeGameDetailEntity(id: 42)

        // Assert
        XCTAssertEqual(entity.id, 42, "Expected Identifiable id to be 42")
    }

    func test_equatable_sameIdAreEqual() {
        // Arrange
        let entity1 = makeGameDetailEntity(id: 1)
        let entity2 = makeGameDetailEntity(id: 1)

        // Assert
        XCTAssertEqual(entity1, entity2, "Expected entities with same ID to be equal")
    }

    func test_equatable_differentIdAreNotEqual() {
        // Arrange
        let entity1 = makeGameDetailEntity(id: 1)
        let entity2 = makeGameDetailEntity(id: 2)

        // Assert
        XCTAssertNotEqual(entity1, entity2, "Expected entities with different IDs to not be equal")
    }

    // MARK: - URL Properties Tests

    func test_backgroundImage_storesValidURL() {
        // Arrange
        let url = URL(string: "https://media.rawg.io/games/image.jpg")
        let entity = GameDetailEntity(
            id: 1,
            slug: "game",
            name: "Game",
            nameOriginal: nil,
            description: nil,
            descriptionRaw: nil,
            released: nil,
            backgroundImage: url,
            backgroundImageAdditional: nil,
            website: nil,
            rating: 0,
            ratingsCount: 0,
            metacritic: nil,
            playtime: 0,
            platforms: [],
            genres: [],
            developers: [],
            publishers: []
        )

        // Assert
        XCTAssertEqual(
            entity.backgroundImage?.absoluteString,
            "https://media.rawg.io/games/image.jpg",
            "Expected backgroundImage URL to match"
        )
    }

    // MARK: - Arrays Tests

    func test_platforms_preservesOrder() {
        // Arrange
        let platforms = [
            PlatformEntity(id: 1, name: "PC", slug: "pc"),
            PlatformEntity(id: 2, name: "PS5", slug: "ps5")
        ]
        let entity = makeGameDetailEntity(platforms: platforms)

        // Assert
        XCTAssertEqual(entity.platforms.count, 2, "Expected 2 platforms")
        XCTAssertEqual(entity.platforms[0].name, "PC", "Expected first platform to be PC")
    }

    func test_genres_preservesOrder() {
        // Arrange
        let genres = [
            GenreEntity(id: 1, name: "RPG", slug: "rpg"),
            GenreEntity(id: 2, name: "Action", slug: "action")
        ]
        let entity = makeGameDetailEntity(genres: genres)

        // Assert
        XCTAssertEqual(entity.genres.count, 2, "Expected 2 genres")
        XCTAssertEqual(entity.genres[0].name, "RPG", "Expected first genre to be RPG")
    }

    func test_developers_preservesOrder() {
        // Arrange
        let developers = [
            DeveloperEntity(id: 1, name: "CD Projekt RED", slug: "cd-projekt-red"),
            DeveloperEntity(id: 2, name: "Rockstar", slug: "rockstar")
        ]
        let entity = makeGameDetailEntity(developers: developers)

        // Assert
        XCTAssertEqual(entity.developers.count, 2, "Expected 2 developers")
        XCTAssertEqual(entity.developers[0].name, "CD Projekt RED", "Expected first developer")
    }

    func test_publishers_preservesOrder() {
        // Arrange
        let publishers = [
            PublisherEntity(id: 1, name: "Bandai Namco", slug: "bandai-namco"),
            PublisherEntity(id: 2, name: "EA", slug: "ea")
        ]
        let entity = makeGameDetailEntity(publishers: publishers)

        // Assert
        XCTAssertEqual(entity.publishers.count, 2, "Expected 2 publishers")
        XCTAssertEqual(entity.publishers[0].name, "Bandai Namco", "Expected first publisher")
    }

    // MARK: - DeveloperEntity Tests

    func test_developerEntity_init() {
        // Arrange & Act
        let developer = DeveloperEntity(id: 1, name: "CD Projekt RED", slug: "cd-projekt-red")

        // Assert
        XCTAssertEqual(developer.id, 1, "Expected id to be 1")
        XCTAssertEqual(developer.name, "CD Projekt RED", "Expected name to match")
        XCTAssertEqual(developer.slug, "cd-projekt-red", "Expected slug to match")
    }

    func test_developerEntity_equatable() {
        // Arrange
        let dev1 = DeveloperEntity(id: 1, name: "Dev", slug: "dev")
        let dev2 = DeveloperEntity(id: 1, name: "Dev", slug: "dev")
        let dev3 = DeveloperEntity(id: 2, name: "Dev", slug: "dev")

        // Assert
        XCTAssertEqual(dev1, dev2, "Expected same ID developers to be equal")
        XCTAssertNotEqual(dev1, dev3, "Expected different ID developers to not be equal")
    }

    // MARK: - PublisherEntity Tests

    func test_publisherEntity_init() {
        // Arrange & Act
        let publisher = PublisherEntity(id: 1, name: "Nintendo", slug: "nintendo")

        // Assert
        XCTAssertEqual(publisher.id, 1, "Expected id to be 1")
        XCTAssertEqual(publisher.name, "Nintendo", "Expected name to match")
        XCTAssertEqual(publisher.slug, "nintendo", "Expected slug to match")
    }

    func test_publisherEntity_equatable() {
        // Arrange
        let pub1 = PublisherEntity(id: 1, name: "Pub", slug: "pub")
        let pub2 = PublisherEntity(id: 1, name: "Pub", slug: "pub")
        let pub3 = PublisherEntity(id: 2, name: "Pub", slug: "pub")

        // Assert
        XCTAssertEqual(pub1, pub2, "Expected same ID publishers to be equal")
        XCTAssertNotEqual(pub1, pub3, "Expected different ID publishers to not be equal")
    }

    // MARK: - Helpers

    private func makeGameDetailEntity(
        id: Int = 1,
        platforms: [PlatformEntity] = [],
        genres: [GenreEntity] = [],
        developers: [DeveloperEntity] = [],
        publishers: [PublisherEntity] = []
    ) -> GameDetailEntity {
        GameDetailEntity(
            id: id,
            slug: "game-\(id)",
            name: "Game \(id)",
            nameOriginal: nil,
            description: nil,
            descriptionRaw: nil,
            released: nil,
            backgroundImage: nil,
            backgroundImageAdditional: nil,
            website: nil,
            rating: 0,
            ratingsCount: 0,
            metacritic: nil,
            playtime: 0,
            platforms: platforms,
            genres: genres,
            developers: developers,
            publishers: publishers
        )
    }

    private func makeFullGameDetailEntity() -> GameDetailEntity {
        GameDetailEntity(
            id: 1,
            slug: "witcher-3",
            name: "The Witcher 3",
            nameOriginal: "The Witcher 3: Wild Hunt",
            description: "<p>HTML Description</p>",
            descriptionRaw: "Raw Description",
            released: "2015-05-19",
            backgroundImage: URL(string: "https://media.rawg.io/games/witcher3.jpg"),
            backgroundImageAdditional: URL(string: "https://media.rawg.io/games/witcher3_2.jpg"),
            website: URL(string: "https://thewitcher.com"),
            rating: 4.8,
            ratingsCount: 5000,
            metacritic: 93,
            playtime: 50,
            platforms: [PlatformEntity(id: 1, name: "PC", slug: "pc")],
            genres: [GenreEntity(id: 1, name: "RPG", slug: "rpg")],
            developers: [DeveloperEntity(id: 1, name: "CD Projekt RED", slug: "cd-projekt-red")],
            publishers: [PublisherEntity(id: 1, name: "CD Projekt", slug: "cd-projekt")]
        )
    }
}
