import XCTest
@testable import Common

/// Tests for GamesRepository cache-first pattern.
final class GamesRepositoryTests: XCTestCase {
    // MARK: - Properties

    // swiftlint:disable implicitly_unwrapped_optional
    private var remoteDS: MockRemoteDataSource!
    private var localDS: MockLocalDataSource!
    private var sut: GamesRepository!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        remoteDS = MockRemoteDataSource()
        localDS = MockLocalDataSource()
        sut = GamesRepository(remoteDataSource: remoteDS, localDataSource: localDS)
    }

    override func tearDown() {
        remoteDS = nil
        localDS = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - getGames Tests

    func test_getGames_returnsCachedDataWhenAvailable() async throws {
        // Arrange
        let cachedGames = makePaginatedEntity(games: [makeGameEntity(id: 1)])
        localDS.stubbedCachedGames = cachedGames

        // Act
        let result = try await sut.getGames(GamesInput(page: 1))

        // Assert
        XCTAssertEqual(
            result.results.count,
            1,
            "Expected cached games to be returned, got \(result.results.count)"
        )
        XCTAssertEqual(
            result.results[0].id,
            1,
            "Expected cached game ID to be 1"
        )
        XCTAssertFalse(
            localDS.saveGamesCalled,
            "Expected saveGames NOT to be called when cache hit"
        )
    }

    func test_getGames_fetchesFromRemoteWhenCacheMiss() async throws {
        // Arrange
        let remoteGames = makePaginatedDTO(games: [makeGameDTO(id: 2)])
        localDS.stubbedCachedGames = nil  // Cache miss
        remoteDS.stubbedGamesResponse = remoteGames

        // Act
        let result = try await sut.getGames(GamesInput(page: 1))

        // Assert
        XCTAssertEqual(
            result.results.count,
            1,
            "Expected remote games to be fetched"
        )
        XCTAssertEqual(
            result.results[0].id,
            2,
            "Expected remote game ID to be 2"
        )
        XCTAssertTrue(
            localDS.saveGamesCalled,
            "Expected saveGames to be called after remote fetch"
        )
    }

    func test_getGames_throwsOnRemoteError() async {
        // Arrange
        localDS.stubbedCachedGames = nil
        remoteDS.stubbedError = NSError(domain: "test", code: 500)

        // Act & Assert
        do {
            _ = try await sut.getGames(GamesInput(page: 1))
            XCTFail("Expected error to be thrown when remote fails")
        } catch {
            XCTAssertNotNil(
                error,
                "Expected error to be non-nil"
            )
        }
    }

    // MARK: - getGameDetail Tests

    func test_getGameDetail_returnsCachedDetailWhenAvailable() async throws {
        // Arrange
        let cachedDetail = makeGameDetailEntity(id: 5)
        localDS.stubbedCachedDetail = cachedDetail

        // Act
        let result = try await sut.getGameDetail(GameDetailInput(id: 5))

        // Assert
        XCTAssertEqual(
            result.id,
            5,
            "Expected cached detail to be returned"
        )
    }

    func test_getGameDetail_fetchesFromRemoteWhenCacheMiss() async throws {
        // Arrange
        let remoteDetail = makeGameDetailDTO(id: 10)
        localDS.stubbedCachedDetail = nil
        remoteDS.stubbedDetailResponse = remoteDetail

        // Act
        let result = try await sut.getGameDetail(GameDetailInput(id: 10))

        // Assert
        XCTAssertEqual(
            result.id,
            10,
            "Expected remote detail to be fetched"
        )
        XCTAssertTrue(
            localDS.saveDetailCalled,
            "Expected saveGameDetail to be called after remote fetch"
        )
    }

    // MARK: - searchGames Tests

    func test_searchGames_alwaysFetchesFromRemote() async throws {
        // Arrange
        let remoteResults = makePaginatedDTO(games: [makeGameDTO(id: 3)])
        remoteDS.stubbedSearchResponse = remoteResults

        // Act
        let result = try await sut.searchGames(SearchGamesInput(query: "test"))

        // Assert
        XCTAssertEqual(
            result.results.count,
            1,
            "Expected search results from remote"
        )
        XCTAssertEqual(
            result.results[0].id,
            3,
            "Expected search result ID to be 3"
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

    private func makeGameDTO(id: Int) -> GameDTO {
        let json: [String: Any] = [
            "id": id,
            "slug": "game-\(id)",
            "name": "Game \(id)",
            "rating": 4.0,
            "ratings_count": 100,
            "playtime": 10
        ]
        // swiftlint:disable:next force_try
        let data = try! JSONSerialization.data(withJSONObject: json)
        // swiftlint:disable:next force_try
        return try! JSONDecoder().decode(GameDTO.self, from: data)
    }

    private func makeGameDetailEntity(id: Int) -> GameDetailEntity {
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
            rating: 4.0,
            ratingsCount: 100,
            metacritic: nil,
            playtime: 10,
            platforms: [],
            genres: [],
            developers: [],
            publishers: []
        )
    }

    private func makeGameDetailDTO(id: Int) -> GameDetailDTO {
        let json: [String: Any] = [
            "id": id,
            "slug": "game-\(id)",
            "name": "Game \(id)",
            "rating": 4.0,
            "ratings_count": 100,
            "playtime": 10
        ]
        // swiftlint:disable:next force_try
        let data = try! JSONSerialization.data(withJSONObject: json)
        // swiftlint:disable:next force_try
        return try! JSONDecoder().decode(GameDetailDTO.self, from: data)
    }

    private func makePaginatedEntity(games: [GameEntity]) -> PaginatedEntity<GameEntity> {
        PaginatedEntity(count: games.count, hasNextPage: false, hasPreviousPage: false, results: games)
    }

    private func makePaginatedDTO(games: [GameDTO]) -> PaginatedResponseDTO<GameDTO> {
        PaginatedResponseDTO(count: games.count, next: nil, previous: nil, results: games)
    }
}

// MARK: - Mocks

final class MockRemoteDataSource: GamesRemoteDataSourceProtocol, @unchecked Sendable {
    var stubbedGamesResponse: PaginatedResponseDTO<GameDTO>?
    var stubbedDetailResponse: GameDetailDTO?
    var stubbedSearchResponse: PaginatedResponseDTO<GameDTO>?
    var stubbedError: Error?

    func fetchGames(_ input: GamesInput) async throws -> PaginatedResponseDTO<GameDTO> {
        if let error = stubbedError { throw error }
        guard let response = stubbedGamesResponse else {
            fatalError("stubbedGamesResponse not set")
        }
        return response
    }

    func fetchGameDetail(_ input: GameDetailInput) async throws -> GameDetailDTO {
        if let error = stubbedError { throw error }
        guard let response = stubbedDetailResponse else {
            fatalError("stubbedDetailResponse not set")
        }
        return response
    }

    func searchGames(_ input: SearchGamesInput) async throws -> PaginatedResponseDTO<GameDTO> {
        if let error = stubbedError { throw error }
        guard let response = stubbedSearchResponse else {
            fatalError("stubbedSearchResponse not set")
        }
        return response
    }
}

final class MockLocalDataSource: GamesLocalDataSourceProtocol, @unchecked Sendable {
    var stubbedCachedGames: PaginatedEntity<GameEntity>?
    var stubbedCachedDetail: GameDetailEntity?
    var saveGamesCalled = false
    var saveDetailCalled = false

    func getCachedGames(page: Int) async -> PaginatedEntity<GameEntity>? {
        stubbedCachedGames
    }

    func saveGames(_ games: PaginatedEntity<GameEntity>, page: Int) async {
        saveGamesCalled = true
    }

    func getCachedGameDetail(id: Int) async -> GameDetailEntity? {
        stubbedCachedDetail
    }

    func saveGameDetail(_ detail: GameDetailEntity) async {
        saveDetailCalled = true
    }

    func clearCache() async {}
}
