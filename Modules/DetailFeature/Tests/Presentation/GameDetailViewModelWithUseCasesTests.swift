import XCTest
import Common
@testable import DetailFeature

/// Comprehensive tests for GameDetailViewModel with Use Cases.
@MainActor
final class GameDetailViewModelWithUseCasesTests: XCTestCase {
    // MARK: - loadDetails Tests

    func test_loadDetails_fetchesGameDetailFromUseCase() async {
        // Arrange
        let mockDetail = makeGameDetailEntity(id: 1, name: "Witcher 3", rating: 4.8)
        let mockUseCase = MockGetGameDetailUseCase()
        mockUseCase.stubbedResult = mockDetail
        let sut = makeSUT(getGameDetailUseCase: mockUseCase)

        // Act
        await sut.loadDetails()

        // Assert
        XCTAssertEqual(
            sut.gameName,
            "Witcher 3",
            "Expected gameName to be updated from detail"
        )
        XCTAssertEqual(
            sut.rating,
            4.8,
            "Expected rating to be 4.8"
        )
    }

    func test_loadDetails_setsLoadingDuringFetch() async {
        // Arrange
        let mockUseCase = MockGetGameDetailUseCase()
        mockUseCase.stubbedResult = makeGameDetailEntity()
        let sut = makeSUT(getGameDetailUseCase: mockUseCase)

        // Assert initial state
        XCTAssertFalse(sut.isLoading, "Expected isLoading to be false initially")

        // Act
        await sut.loadDetails()

        // Assert final state
        XCTAssertFalse(sut.isLoading, "Expected isLoading to be false after completion")
    }

    func test_loadDetails_setsErrorOnFailure() async {
        // Arrange
        let mockUseCase = MockGetGameDetailUseCase()
        mockUseCase.stubbedError = NSError(domain: "test", code: 500)
        let sut = makeSUT(getGameDetailUseCase: mockUseCase)

        // Act
        await sut.loadDetails()

        // Assert
        XCTAssertNotNil(
            sut.error,
            "Expected error to be set when use case fails"
        )
    }

    func test_loadDetails_updatesAllDetailProperties() async {
        // Arrange
        let mockDetail = GameDetailEntity(
            id: 1,
            slug: "witcher",
            name: "Witcher",
            nameOriginal: "Witcher Original",
            description: "HTML Description",
            descriptionRaw: "Raw Description",
            released: "2020-01-15",
            backgroundImage: URL(string: "https://example.com/image.jpg"),
            backgroundImageAdditional: nil,
            website: nil,
            rating: 4.5,
            ratingsCount: 1000,
            metacritic: 92,
            playtime: 50,
            platforms: [PlatformEntity(id: 1, name: "PC", slug: "pc")],
            genres: [],
            developers: [],
            publishers: []
        )
        let mockUseCase = MockGetGameDetailUseCase()
        mockUseCase.stubbedResult = mockDetail
        let sut = makeSUT(getGameDetailUseCase: mockUseCase)

        // Act
        await sut.loadDetails()

        // Assert
        XCTAssertEqual(sut.descriptionText, "Raw Description", "Expected raw description to be preferred")
        XCTAssertEqual(sut.metacritic, 92, "Expected metacritic to be 92")
        XCTAssertEqual(sut.platforms.count, 1, "Expected 1 platform")
        XCTAssertEqual(sut.released, "2020-01-15", "Expected released date to be set")
    }

    // MARK: - toggleFavorite Tests

    func test_toggleFavorite_addsToFavoriteWhenNotFavorited() async {
        // Arrange
        let mockAddUseCase = MockAddFavoriteUseCase()
        let mockIsFavoriteUseCase = MockIsFavoriteUseCase()
        mockIsFavoriteUseCase.stubbedResult = false
        let sut = makeSUT(
            addFavoriteUseCase: mockAddUseCase,
            isFavoriteUseCase: mockIsFavoriteUseCase
        )

        // Act
        await sut.toggleFavorite()

        // Assert
        XCTAssertTrue(
            mockAddUseCase.executeCalled,
            "Expected addFavoriteUseCase to be called"
        )
        XCTAssertTrue(
            sut.isFavorite,
            "Expected isFavorite to be true after adding"
        )
    }

    func test_toggleFavorite_removesFromFavoriteWhenFavorited() async {
        // Arrange
        let mockRemoveUseCase = MockRemoveFavoriteUseCase()
        let mockIsFavoriteUseCase = MockIsFavoriteUseCase()
        mockIsFavoriteUseCase.stubbedResult = true
        let sut = makeSUT(
            removeFavoriteUseCase: mockRemoveUseCase,
            isFavoriteUseCase: mockIsFavoriteUseCase
        )

        // Pre-load to set isFavorite to true
        await sut.loadDetails()
        XCTAssertTrue(sut.isFavorite, "Pre-condition: should be favorited")

        // Act
        await sut.toggleFavorite()

        // Assert
        XCTAssertTrue(
            mockRemoveUseCase.executeCalled,
            "Expected removeFavoriteUseCase to be called"
        )
        XCTAssertFalse(
            sut.isFavorite,
            "Expected isFavorite to be false after removing"
        )
    }

    func test_toggleFavorite_setsErrorOnFailure() async {
        // Arrange
        let mockAddUseCase = MockAddFavoriteUseCase()
        mockAddUseCase.stubbedError = NSError(domain: "test", code: 1)
        let sut = makeSUT(addFavoriteUseCase: mockAddUseCase)

        // Act
        await sut.toggleFavorite()

        // Assert
        XCTAssertNotNil(
            sut.error,
            "Expected error to be set when toggle fails"
        )
    }

    // MARK: - checkFavoriteStatus Tests

    func test_loadDetails_checksFavoriteStatus() async {
        // Arrange
        let mockIsFavoriteUseCase = MockIsFavoriteUseCase()
        mockIsFavoriteUseCase.stubbedResult = true
        let sut = makeSUT(isFavoriteUseCase: mockIsFavoriteUseCase)

        // Act
        await sut.loadDetails()

        // Assert
        XCTAssertTrue(
            sut.isFavorite,
            "Expected isFavorite to be true after loading"
        )
    }

    // MARK: - Helpers

    private func makeSUT(
        gameId: Int = 1,
        gameName: String = "Test Game",
        getGameDetailUseCase: MockGetGameDetailUseCase? = nil,
        addFavoriteUseCase: MockAddFavoriteUseCase? = nil,
        removeFavoriteUseCase: MockRemoveFavoriteUseCase? = nil,
        isFavoriteUseCase: MockIsFavoriteUseCase? = nil
    ) -> GameDetailViewModel {
        GameDetailViewModel(
            gameId: gameId,
            gameName: gameName,
            backgroundImageURL: nil,
            getGameDetailUseCase: getGameDetailUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase
        )
    }

    private func makeGameDetailEntity(
        id: Int = 1,
        name: String = "Game",
        rating: Double = 4.0
    ) -> GameDetailEntity {
        GameDetailEntity(
            id: id,
            slug: "game-\(id)",
            name: name,
            nameOriginal: nil,
            description: nil,
            descriptionRaw: nil,
            released: nil,
            backgroundImage: nil,
            backgroundImageAdditional: nil,
            website: nil,
            rating: rating,
            ratingsCount: 100,
            metacritic: nil,
            playtime: 10,
            platforms: [],
            genres: [],
            developers: [],
            publishers: []
        )
    }
}

// MARK: - Mocks

final class MockGetGameDetailUseCase: GetGameDetailUseCaseProtocol, @unchecked Sendable {
    var stubbedResult: GameDetailEntity?
    var stubbedError: Error?

    func execute(id: Int) async throws -> GameDetailEntity {
        if let error = stubbedError { throw error }
        guard let result = stubbedResult else {
            fatalError("stubbedResult not set")
        }
        return result
    }
}

final class MockAddFavoriteUseCase: AddFavoriteUseCaseProtocol, @unchecked Sendable {
    var executeCalled = false
    var stubbedError: Error?

    func execute(_ game: GameEntity) async throws {
        executeCalled = true
        if let error = stubbedError { throw error }
    }
}

final class MockRemoveFavoriteUseCase: RemoveFavoriteUseCaseProtocol, @unchecked Sendable {
    var executeCalled = false
    var stubbedError: Error?

    func execute(gameId: Int) async throws {
        executeCalled = true
        if let error = stubbedError { throw error }
    }
}

final class MockIsFavoriteUseCase: IsFavoriteUseCaseProtocol, @unchecked Sendable {
    var stubbedResult = false

    func execute(gameId: Int) async throws -> Bool {
        stubbedResult
    }
}
