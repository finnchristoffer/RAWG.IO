import Foundation
import Factory
import CoreNetwork

// MARK: - Common Module DI Assembly

public extension Container {
    // MARK: - Configuration

    /// APIClient for RAWG API.
    var apiClient: Factory<APIClient> {
        self {
            APIClient(baseURL: URL(string: "https://api.rawg.io/api")!) // swiftlint:disable:this force_unwrapping
        }
    }

    // MARK: - DataSources

    /// Remote data source for games API.
    var gamesRemoteDataSource: Factory<GamesRemoteDataSourceProtocol> {
        self { GamesRemoteDataSource(client: self.apiClient()) }
    }

    /// Local data source for games caching.
    var gamesLocalDataSource: Factory<GamesLocalDataSourceProtocol> {
        self { GamesLocalDataSource() }
    }

    // MARK: - Repositories

    /// Games repository with cache-first pattern.
    var gamesRepository: Factory<GamesRepositoryProtocol> {
        self {
            GamesRepository(
                remoteDataSource: self.gamesRemoteDataSource(),
                localDataSource: self.gamesLocalDataSource()
            )
        }
    }
}
