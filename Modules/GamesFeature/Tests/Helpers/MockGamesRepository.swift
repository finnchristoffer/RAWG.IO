import Foundation
import Common

/// Mock implementation of GamesRepositoryProtocol for testing.
public final class MockGamesRepository: GamesRepositoryProtocol, @unchecked Sendable {
    public var stubbedGamesResult: PaginatedEntity<GameEntity>?
    public var stubbedGameDetailResult: GameDetailEntity?
    public var stubbedSearchResult: PaginatedEntity<GameEntity>?
    public var stubbedError: Error?

    public var getGamesCallCount = 0
    public var getGameDetailCallCount = 0
    public var searchGamesCallCount = 0

    public var lastGamesInput: GamesInput?
    public var lastGameDetailInput: GameDetailInput?
    public var lastSearchInput: SearchGamesInput?

    public init() {}

    public func getGames(_ input: GamesInput) async throws -> PaginatedEntity<GameEntity> {
        getGamesCallCount += 1
        lastGamesInput = input

        if let error = stubbedError {
            throw error
        }

        return stubbedGamesResult ?? PaginatedEntity(
            count: 0,
            hasNextPage: false,
            hasPreviousPage: false,
            results: []
        )
    }

    public func getGameDetail(_ input: GameDetailInput) async throws -> GameDetailEntity {
        getGameDetailCallCount += 1
        lastGameDetailInput = input

        if let error = stubbedError {
            throw error
        }

        guard let result = stubbedGameDetailResult else {
            throw NSError(
                domain: "MockGamesRepository",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "No stubbed result"]
            )
        }

        return result
    }

    public func searchGames(_ input: SearchGamesInput) async throws -> PaginatedEntity<GameEntity> {
        searchGamesCallCount += 1
        lastSearchInput = input

        if let error = stubbedError {
            throw error
        }

        return stubbedSearchResult ?? PaginatedEntity(
            count: 0,
            hasNextPage: false,
            hasPreviousPage: false,
            results: []
        )
    }
}
