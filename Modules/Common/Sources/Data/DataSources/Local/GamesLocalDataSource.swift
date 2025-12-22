import Foundation

/// Protocol for local games data source (caching).
public protocol GamesLocalDataSourceProtocol: Sendable {
    /// Gets cached games for a page.
    func getCachedGames(page: Int) async -> PaginatedEntity<GameEntity>?

    /// Saves games to cache.
    func saveGames(_ games: PaginatedEntity<GameEntity>, page: Int) async

    /// Gets cached game detail.
    func getCachedGameDetail(id: Int) async -> GameDetailEntity?

    /// Saves game detail to cache.
    func saveGameDetail(_ detail: GameDetailEntity) async

    /// Clears all cached data.
    func clearCache() async
}

/// Local data source for games caching using UserDefaults.
public actor GamesLocalDataSource: GamesLocalDataSourceProtocol {
    // MARK: - Keys

    private enum CacheKeys {
        static func gamesPage(_ page: Int) -> String { "games_page_\(page)" }
        static func gameDetail(_ id: Int) -> String { "game_detail_\(id)" }
    }

    // MARK: - Dependencies

    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // Cache expiration (1 hour)
    private let cacheExpirationInterval: TimeInterval = 3600

    // MARK: - Init

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - GamesLocalDataSourceProtocol

    public func getCachedGames(page: Int) async -> PaginatedEntity<GameEntity>? {
        let key = CacheKeys.gamesPage(page)
        guard let wrapper: CacheWrapper<CachedPaginatedGames> = getCached(key: key) else {
            return nil
        }
        return wrapper.data.toPaginatedEntity()
    }

    public func saveGames(_ games: PaginatedEntity<GameEntity>, page: Int) async {
        let key = CacheKeys.gamesPage(page)
        let cached = CachedPaginatedGames(from: games)
        saveToCache(cached, key: key)
    }

    public func getCachedGameDetail(id: Int) async -> GameDetailEntity? {
        let key = CacheKeys.gameDetail(id)
        guard let wrapper: CacheWrapper<CachedGameDetail> = getCached(key: key) else {
            return nil
        }
        return wrapper.data.toEntity()
    }

    public func saveGameDetail(_ detail: GameDetailEntity) async {
        let key = CacheKeys.gameDetail(detail.id)
        let cached = CachedGameDetail(from: detail)
        saveToCache(cached, key: key)
    }

    public func clearCache() async {
        let keys = userDefaults.dictionaryRepresentation().keys
        for key in keys where key.hasPrefix("games_") || key.hasPrefix("game_detail_") {
            userDefaults.removeObject(forKey: key)
        }
    }

    // MARK: - Private Helpers

    private func getCached<T: Codable>(key: String) -> CacheWrapper<T>? {
        guard let data = userDefaults.data(forKey: key) else { return nil }

        do {
            let wrapper = try decoder.decode(CacheWrapper<T>.self, from: data)
            // Check expiration
            if Date().timeIntervalSince(wrapper.timestamp) > cacheExpirationInterval {
                userDefaults.removeObject(forKey: key)
                return nil
            }
            return wrapper
        } catch {
            return nil
        }
    }

    private func saveToCache<T: Codable>(_ data: T, key: String) {
        let wrapper = CacheWrapper(data: data, timestamp: Date())
        do {
            let encoded = try encoder.encode(wrapper)
            userDefaults.set(encoded, forKey: key)
        } catch {
            // Silently fail cache saves
        }
    }
}

// MARK: - Cache Models

private struct CacheWrapper<T: Codable>: Codable {
    let data: T
    let timestamp: Date
}

private struct CachedPaginatedGames: Codable {
    let count: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let results: [CachedGame]

    init(from entity: PaginatedEntity<GameEntity>) {
        self.count = entity.count
        self.hasNextPage = entity.hasNextPage
        self.hasPreviousPage = entity.hasPreviousPage
        self.results = entity.results.map { CachedGame(from: $0) }
    }

    func toPaginatedEntity() -> PaginatedEntity<GameEntity> {
        PaginatedEntity(
            count: count,
            hasNextPage: hasNextPage,
            hasPreviousPage: hasPreviousPage,
            results: results.map { $0.toEntity() }
        )
    }
}

private struct CachedGame: Codable {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double
    let ratingsCount: Int
    let metacritic: Int?
    let playtime: Int
    let platforms: [CachedPlatform]
    let genres: [CachedGenre]

    init(from entity: GameEntity) {
        self.id = entity.id
        self.slug = entity.slug
        self.name = entity.name
        self.released = entity.released
        self.backgroundImage = entity.backgroundImage?.absoluteString
        self.rating = entity.rating
        self.ratingsCount = entity.ratingsCount
        self.metacritic = entity.metacritic
        self.playtime = entity.playtime
        self.platforms = entity.platforms.map { CachedPlatform(from: $0) }
        self.genres = entity.genres.map { CachedGenre(from: $0) }
    }

    func toEntity() -> GameEntity {
        GameEntity(
            id: id,
            slug: slug,
            name: name,
            released: released,
            backgroundImage: backgroundImage.flatMap { URL(string: $0) },
            rating: rating,
            ratingsCount: ratingsCount,
            metacritic: metacritic,
            playtime: playtime,
            platforms: platforms.map { $0.toEntity() },
            genres: genres.map { $0.toEntity() }
        )
    }
}

private struct CachedPlatform: Codable {
    let id: Int
    let name: String
    let slug: String

    init(from entity: PlatformEntity) {
        self.id = entity.id
        self.name = entity.name
        self.slug = entity.slug
    }

    func toEntity() -> PlatformEntity {
        PlatformEntity(id: id, name: name, slug: slug)
    }
}

private struct CachedGenre: Codable {
    let id: Int
    let name: String
    let slug: String

    init(from entity: GenreEntity) {
        self.id = entity.id
        self.name = entity.name
        self.slug = entity.slug
    }

    func toEntity() -> GenreEntity {
        GenreEntity(id: id, name: name, slug: slug)
    }
}

private struct CachedGameDetail: Codable {
    let id: Int
    let slug: String
    let name: String
    let nameOriginal: String?
    let description: String?
    let descriptionRaw: String?
    let released: String?
    let backgroundImage: String?
    let backgroundImageAdditional: String?
    let website: String?
    let rating: Double
    let ratingsCount: Int
    let metacritic: Int?
    let playtime: Int
    let platforms: [CachedPlatform]
    let genres: [CachedGenre]
    let developers: [CachedDeveloper]
    let publishers: [CachedPublisher]

    init(from entity: GameDetailEntity) {
        self.id = entity.id
        self.slug = entity.slug
        self.name = entity.name
        self.nameOriginal = entity.nameOriginal
        self.description = entity.description
        self.descriptionRaw = entity.descriptionRaw
        self.released = entity.released
        self.backgroundImage = entity.backgroundImage?.absoluteString
        self.backgroundImageAdditional = entity.backgroundImageAdditional?.absoluteString
        self.website = entity.website?.absoluteString
        self.rating = entity.rating
        self.ratingsCount = entity.ratingsCount
        self.metacritic = entity.metacritic
        self.playtime = entity.playtime
        self.platforms = entity.platforms.map { CachedPlatform(from: $0) }
        self.genres = entity.genres.map { CachedGenre(from: $0) }
        self.developers = entity.developers.map { CachedDeveloper(from: $0) }
        self.publishers = entity.publishers.map { CachedPublisher(from: $0) }
    }

    func toEntity() -> GameDetailEntity {
        GameDetailEntity(
            id: id,
            slug: slug,
            name: name,
            nameOriginal: nameOriginal,
            description: description,
            descriptionRaw: descriptionRaw,
            released: released,
            backgroundImage: backgroundImage.flatMap { URL(string: $0) },
            backgroundImageAdditional: backgroundImageAdditional.flatMap { URL(string: $0) },
            website: website.flatMap { URL(string: $0) },
            rating: rating,
            ratingsCount: ratingsCount,
            metacritic: metacritic,
            playtime: playtime,
            platforms: platforms.map { $0.toEntity() },
            genres: genres.map { $0.toEntity() },
            developers: developers.map { $0.toEntity() },
            publishers: publishers.map { $0.toEntity() }
        )
    }
}

private struct CachedDeveloper: Codable {
    let id: Int
    let name: String
    let slug: String

    init(from entity: DeveloperEntity) {
        self.id = entity.id
        self.name = entity.name
        self.slug = entity.slug
    }

    func toEntity() -> DeveloperEntity {
        DeveloperEntity(id: id, name: name, slug: slug)
    }
}

private struct CachedPublisher: Codable {
    let id: Int
    let name: String
    let slug: String

    init(from entity: PublisherEntity) {
        self.id = entity.id
        self.name = entity.name
        self.slug = entity.slug
    }

    func toEntity() -> PublisherEntity {
        PublisherEntity(id: id, name: name, slug: slug)
    }
}
