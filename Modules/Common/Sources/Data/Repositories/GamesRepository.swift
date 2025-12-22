import Foundation
import CoreNetwork

/// Implementation of GamesRepositoryProtocol using cache-first pattern.
///
/// Pattern: Check local cache → if miss → fetch from remote → save to cache
public final class GamesRepository: GamesRepositoryProtocol, @unchecked Sendable {
    // MARK: - Dependencies

    private let remoteDataSource: GamesRemoteDataSourceProtocol
    private let localDataSource: GamesLocalDataSourceProtocol

    // MARK: - Init

    public init(
        remoteDataSource: GamesRemoteDataSourceProtocol,
        localDataSource: GamesLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    // MARK: - GamesRepositoryProtocol

    public func getGames(_ input: GamesInput) async throws -> PaginatedEntity<GameEntity> {
        // 1. Check cache first
        if let cached = await localDataSource.getCachedGames(page: input.page) {
            return cached
        }

        // 2. Fetch from remote
        let dto = try await remoteDataSource.fetchGames(input)

        // 3. Map to entity
        let entity = GameMapper.map(dto)

        // 4. Save to cache
        await localDataSource.saveGames(entity, page: input.page)

        return entity
    }

    public func getGameDetail(_ input: GameDetailInput) async throws -> GameDetailEntity {
        // 1. Check cache first
        if let cached = await localDataSource.getCachedGameDetail(id: input.id) {
            return cached
        }

        // 2. Fetch from remote
        let dto = try await remoteDataSource.fetchGameDetail(input)

        // 3. Map to entity
        let entity = GameDetailMapper.map(dto)

        // 4. Save to cache
        await localDataSource.saveGameDetail(entity)

        return entity
    }

    public func searchGames(_ input: SearchGamesInput) async throws -> PaginatedEntity<GameEntity> {
        // Search is not cached (real-time results)
        let dto = try await remoteDataSource.searchGames(input)
        return GameMapper.map(dto)
    }
}
