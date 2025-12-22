import Foundation
import Common

/// Mock implementation of GamesRepositoryProtocol for testing.
final class MockGamesRepository: GamesRepositoryProtocol, @unchecked Sendable {
    var stubbedGamesResult: PaginatedResponse<Game>?
    var stubbedGameDetailResult: GameDetail?
    var stubbedSearchResult: PaginatedResponse<Game>?
    var stubbedError: Error?

    var getGamesCallCount = 0
    var getGameDetailCallCount = 0
    var searchGamesCallCount = 0

    var lastGamesInput: GamesInput?
    var lastGameDetailInput: GameDetailInput?
    var lastSearchInput: SearchGamesInput?

    func getGames(_ input: GamesInput) async throws -> PaginatedResponse<Game> {
        getGamesCallCount += 1
        lastGamesInput = input

        if let error = stubbedError {
            throw error
        }

        return stubbedGamesResult ?? PaginatedResponse(count: 0, next: nil, previous: nil, results: [])
    }

    func getGameDetail(_ input: GameDetailInput) async throws -> GameDetail {
        getGameDetailCallCount += 1
        lastGameDetailInput = input

        if let error = stubbedError {
            throw error
        }

        guard let result = stubbedGameDetailResult else {
            throw NSError(domain: "MockGamesRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "No stubbed result"])
        }

        return result
    }

    func searchGames(_ input: SearchGamesInput) async throws -> PaginatedResponse<Game> {
        searchGamesCallCount += 1
        lastSearchInput = input

        if let error = stubbedError {
            throw error
        }

        return stubbedSearchResult ?? PaginatedResponse(count: 0, next: nil, previous: nil, results: [])
    }
}
