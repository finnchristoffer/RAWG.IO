import Foundation

/// Mapper for converting Game DTOs to Entities.
public enum GameMapper {
    /// Maps `GameDTO` to `GameEntity`.
    public static func map(_ dto: GameDTO) -> GameEntity {
        GameEntity(
            id: dto.id,
            slug: dto.slug,
            name: dto.name,
            released: dto.released,
            backgroundImage: dto.backgroundImage.flatMap { URL(string: $0) },
            rating: dto.rating,
            ratingsCount: dto.ratingsCount,
            metacritic: dto.metacritic,
            playtime: dto.playtime,
            platforms: dto.platforms?.map { mapPlatform($0.platform) } ?? [],
            genres: dto.genres?.map { mapGenre($0) } ?? []
        )
    }

    /// Maps array of `GameDTO` to array of `GameEntity`.
    public static func map(_ dtos: [GameDTO]) -> [GameEntity] {
        dtos.map { map($0) }
    }

    /// Maps `PaginatedResponseDTO<GameDTO>` to `PaginatedEntity<GameEntity>`.
    public static func map(_ dto: PaginatedResponseDTO<GameDTO>) -> PaginatedEntity<GameEntity> {
        PaginatedEntity(
            count: dto.count,
            hasNextPage: dto.next != nil,
            hasPreviousPage: dto.previous != nil,
            results: map(dto.results)
        )
    }

    // MARK: - Private

    private static func mapPlatform(_ dto: PlatformDTO) -> PlatformEntity {
        PlatformEntity(id: dto.id, name: dto.name, slug: dto.slug)
    }

    private static func mapGenre(_ dto: GenreDTO) -> GenreEntity {
        GenreEntity(id: dto.id, name: dto.name, slug: dto.slug)
    }
}
