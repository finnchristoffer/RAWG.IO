import XCTest
@testable import Common

/// Tests for GameEntity.
final class GameEntityTests: XCTestCase {
    // MARK: - Initialization

    func test_init_setsAllRequiredProperties() {
        // Arrange & Act
        let entity = GameEntity(
            id: 1,
            slug: "witcher-3",
            name: "The Witcher 3",
            released: "2015-05-19",
            backgroundImage: URL(string: "https://example.com/image.jpg"),
            rating: 4.8,
            ratingsCount: 5000,
            metacritic: 93,
            playtime: 50,
            platforms: [PlatformEntity(id: 1, name: "PC", slug: "pc")],
            genres: [GenreEntity(id: 1, name: "RPG", slug: "rpg")]
        )

        // Assert
        XCTAssertEqual(
            entity.id,
            1,
            "Expected id to be 1"
        )
        XCTAssertEqual(
            entity.slug,
            "witcher-3",
            "Expected slug to match"
        )
        XCTAssertEqual(
            entity.name,
            "The Witcher 3",
            "Expected name to match"
        )
    }

    func test_init_withOptionalNilValues() {
        // Arrange & Act
        let entity = GameEntity(
            id: 1,
            slug: "game",
            name: "Game",
            released: nil,
            backgroundImage: nil,
            rating: 0,
            ratingsCount: 0,
            metacritic: nil,
            playtime: 0,
            platforms: [],
            genres: []
        )

        // Assert
        XCTAssertNil(
            entity.released,
            "Expected released to be nil"
        )
        XCTAssertNil(
            entity.backgroundImage,
            "Expected backgroundImage to be nil"
        )
        XCTAssertNil(
            entity.metacritic,
            "Expected metacritic to be nil"
        )
    }

    // MARK: - Identifiable Conformance

    func test_identifiable_usesIdAsIdentifier() {
        // Arrange
        let entity = makeGameEntity(id: 42)

        // Assert
        XCTAssertEqual(
            entity.id,
            42,
            "Expected Identifiable id to be 42"
        )
    }

    // MARK: - Equatable Conformance

    func test_equatable_sameIdAreEqual() {
        // Arrange
        let entity1 = makeGameEntity(id: 1)
        let entity2 = makeGameEntity(id: 1)

        // Assert
        XCTAssertEqual(
            entity1,
            entity2,
            "Expected entities with same ID to be equal"
        )
    }

    func test_equatable_differentIdAreNotEqual() {
        // Arrange
        let entity1 = makeGameEntity(id: 1)
        let entity2 = makeGameEntity(id: 2)

        // Assert
        XCTAssertNotEqual(
            entity1,
            entity2,
            "Expected entities with different IDs to not be equal"
        )
    }

    // MARK: - Platform & Genre Arrays

    func test_platforms_preservesOrder() {
        // Arrange
        let platforms = [
            PlatformEntity(id: 1, name: "PC", slug: "pc"),
            PlatformEntity(id: 2, name: "PlayStation 5", slug: "ps5"),
            PlatformEntity(id: 3, name: "Xbox Series X", slug: "xbox-series-x")
        ]

        let entity = GameEntity(
            id: 1,
            slug: "game",
            name: "Game",
            released: nil,
            backgroundImage: nil,
            rating: 0,
            ratingsCount: 0,
            metacritic: nil,
            playtime: 0,
            platforms: platforms,
            genres: []
        )

        // Assert
        XCTAssertEqual(
            entity.platforms.count,
            3,
            "Expected 3 platforms"
        )
        XCTAssertEqual(
            entity.platforms[0].name,
            "PC",
            "Expected first platform to be PC"
        )
        XCTAssertEqual(
            entity.platforms[2].name,
            "Xbox Series X",
            "Expected last platform to be Xbox Series X"
        )
    }

    func test_genres_preservesOrder() {
        // Arrange
        let genres = [
            GenreEntity(id: 1, name: "RPG", slug: "rpg"),
            GenreEntity(id: 2, name: "Action", slug: "action")
        ]

        let entity = GameEntity(
            id: 1,
            slug: "game",
            name: "Game",
            released: nil,
            backgroundImage: nil,
            rating: 0,
            ratingsCount: 0,
            metacritic: nil,
            playtime: 0,
            platforms: [],
            genres: genres
        )

        // Assert
        XCTAssertEqual(
            entity.genres.count,
            2,
            "Expected 2 genres"
        )
        XCTAssertEqual(
            entity.genres[0].name,
            "RPG",
            "Expected first genre to be RPG"
        )
    }

    // MARK: - Helpers

    private func makeGameEntity(id: Int) -> GameEntity {
        GameEntity(
            id: id,
            slug: "game-\(id)",
            name: "Game \(id)",
            released: nil,
            backgroundImage: nil,
            rating: 4.0,
            ratingsCount: 100,
            metacritic: nil,
            playtime: 10,
            platforms: [],
            genres: []
        )
    }
}
