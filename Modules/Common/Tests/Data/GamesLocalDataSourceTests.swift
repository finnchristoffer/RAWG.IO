import XCTest
@testable import Common

/// Tests for GamesLocalDataSource caching functionality.
final class GamesLocalDataSourceTests: XCTestCase {
    // MARK: - Games Caching Tests

    func test_getCachedGames_returnsNilWhenCacheEmpty() async {
        // Arrange
        let sut = makeSUT()

        // Act
        let result = await sut.getCachedGames(page: 1)

        // Assert
        XCTAssertNil(
            result,
            "Expected nil when no cached games"
        )
    }

    func test_saveAndGetCachedGames_roundTrip() async {
        // Arrange
        let sut = makeSUT()
        let games = makePaginatedEntity(games: [
            makeGameEntity(id: 1, name: "Game 1"),
            makeGameEntity(id: 2, name: "Game 2")
        ])

        // Act
        await sut.saveGames(games, page: 1)
        let result = await sut.getCachedGames(page: 1)

        // Assert
        XCTAssertNotNil(
            result,
            "Expected cached games to be returned"
        )
        XCTAssertEqual(
            result?.results.count,
            2,
            "Expected 2 cached games"
        )
        XCTAssertEqual(
            result?.results[0].name,
            "Game 1",
            "Expected first game name to match"
        )
    }

    func test_getCachedGames_differentPagesAreSeparate() async {
        // Arrange
        let sut = makeSUT()
        let page1Games = makePaginatedEntity(games: [makeGameEntity(id: 1)])
        let page2Games = makePaginatedEntity(games: [makeGameEntity(id: 2)])

        // Act
        await sut.saveGames(page1Games, page: 1)
        await sut.saveGames(page2Games, page: 2)
        let result1 = await sut.getCachedGames(page: 1)
        let result2 = await sut.getCachedGames(page: 2)

        // Assert
        XCTAssertEqual(
            result1?.results[0].id,
            1,
            "Expected page 1 to have game ID 1"
        )
        XCTAssertEqual(
            result2?.results[0].id,
            2,
            "Expected page 2 to have game ID 2"
        )
    }

    // MARK: - Game Detail Caching Tests

    func test_getCachedGameDetail_returnsNilWhenCacheEmpty() async {
        // Arrange
        let sut = makeSUT()

        // Act
        let result = await sut.getCachedGameDetail(id: 1)

        // Assert
        XCTAssertNil(
            result,
            "Expected nil when no cached detail"
        )
    }

    func test_saveAndGetCachedGameDetail_roundTrip() async {
        // Arrange
        let sut = makeSUT()
        let detail = makeGameDetailEntity(id: 5, name: "Witcher 3")

        // Act
        await sut.saveGameDetail(detail)
        let result = await sut.getCachedGameDetail(id: 5)

        // Assert
        XCTAssertNotNil(
            result,
            "Expected cached detail to be returned"
        )
        XCTAssertEqual(
            result?.name,
            "Witcher 3",
            "Expected cached detail name to match"
        )
    }

    func test_getCachedGameDetail_differentIdsAreSeparate() async {
        // Arrange
        let sut = makeSUT()
        let detail1 = makeGameDetailEntity(id: 1, name: "Game 1")
        let detail2 = makeGameDetailEntity(id: 2, name: "Game 2")

        // Act
        await sut.saveGameDetail(detail1)
        await sut.saveGameDetail(detail2)
        let result1 = await sut.getCachedGameDetail(id: 1)
        let result2 = await sut.getCachedGameDetail(id: 2)

        // Assert
        XCTAssertEqual(result1?.name, "Game 1", "Expected ID 1 to have name 'Game 1'")
        XCTAssertEqual(result2?.name, "Game 2", "Expected ID 2 to have name 'Game 2'")
    }

    // MARK: - Clear Cache Tests

    func test_clearCache_removesAllCachedData() async {
        // Arrange
        let sut = makeSUT()
        await sut.saveGames(makePaginatedEntity(games: [makeGameEntity()]), page: 1)
        await sut.saveGameDetail(makeGameDetailEntity())

        // Act
        await sut.clearCache()
        let games = await sut.getCachedGames(page: 1)
        let detail = await sut.getCachedGameDetail(id: 1)

        // Assert
        XCTAssertNil(games, "Expected games cache to be cleared")
        XCTAssertNil(detail, "Expected detail cache to be cleared")
    }

    // MARK: - Pagination Properties Tests

    func test_saveGames_preservesPaginationProperties() async {
        // Arrange
        let sut = makeSUT()
        let games = PaginatedEntity(
            count: 100,
            hasNextPage: true,
            hasPreviousPage: true,
            results: [makeGameEntity()]
        )

        // Act
        await sut.saveGames(games, page: 5)
        let result = await sut.getCachedGames(page: 5)

        // Assert
        XCTAssertEqual(result?.count, 100, "Expected count to be preserved")
        XCTAssertTrue(result?.hasNextPage ?? false, "Expected hasNextPage to be preserved")
        XCTAssertTrue(result?.hasPreviousPage ?? false, "Expected hasPreviousPage to be preserved")
    }

    // MARK: - Helpers

    private func makeSUT() -> GamesLocalDataSource {
        let suiteName = "test_\(UUID().uuidString)"
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            fatalError("Failed to create UserDefaults with suite name")
        }
        return GamesLocalDataSource(userDefaults: userDefaults)
    }

    private func makeGameEntity(
        id: Int = 1,
        name: String = "Game"
    ) -> GameEntity {
        GameEntity(
            id: id,
            slug: "game-\(id)",
            name: name,
            released: "2023-01-01",
            backgroundImage: URL(string: "https://example.com/\(id).jpg"),
            rating: 4.5,
            ratingsCount: 100,
            metacritic: 85,
            playtime: 20,
            platforms: [PlatformEntity(id: 1, name: "PC", slug: "pc")],
            genres: [GenreEntity(id: 1, name: "RPG", slug: "rpg")]
        )
    }

    private func makeGameDetailEntity(
        id: Int = 1,
        name: String = "Game"
    ) -> GameDetailEntity {
        GameDetailEntity(
            id: id,
            slug: "game-\(id)",
            name: name,
            nameOriginal: nil,
            description: "Description",
            descriptionRaw: "Raw description",
            released: "2023-01-01",
            backgroundImage: URL(string: "https://example.com/\(id).jpg"),
            backgroundImageAdditional: nil,
            website: nil,
            rating: 4.5,
            ratingsCount: 100,
            metacritic: 85,
            playtime: 20,
            platforms: [PlatformEntity(id: 1, name: "PC", slug: "pc")],
            genres: [GenreEntity(id: 1, name: "RPG", slug: "rpg")],
            developers: [DeveloperEntity(id: 1, name: "Dev", slug: "dev")],
            publishers: [PublisherEntity(id: 1, name: "Pub", slug: "pub")]
        )
    }

    private func makePaginatedEntity(games: [GameEntity]) -> PaginatedEntity<GameEntity> {
        PaginatedEntity(count: games.count, hasNextPage: false, hasPreviousPage: false, results: games)
    }
}
