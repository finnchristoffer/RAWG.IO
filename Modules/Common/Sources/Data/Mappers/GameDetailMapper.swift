import Foundation

/// Mapper for converting GameDetail DTOs to Entities.
public enum GameDetailMapper {
    /// Maps `GameDetailDTO` to `GameDetailEntity`.
    public static func map(_ dto: GameDetailDTO) -> GameDetailEntity {
        GameDetailEntity(
            id: dto.id,
            slug: dto.slug,
            name: dto.name,
            nameOriginal: dto.nameOriginal,
            description: dto.description,
            descriptionRaw: dto.descriptionRaw,
            released: dto.released,
            backgroundImage: dto.backgroundImage.flatMap { URL(string: $0) },
            backgroundImageAdditional: dto.backgroundImageAdditional.flatMap { URL(string: $0) },
            website: dto.website.flatMap { URL(string: $0) },
            rating: dto.rating,
            ratingsCount: dto.ratingsCount,
            metacritic: dto.metacritic,
            playtime: dto.playtime,
            platforms: dto.platforms?.map { mapPlatform($0.platform) } ?? [],
            genres: dto.genres?.map { mapGenre($0) } ?? [],
            developers: dto.developers?.map { mapDeveloper($0) } ?? [],
            publishers: dto.publishers?.map { mapPublisher($0) } ?? []
        )
    }

    // MARK: - Private

    private static func mapPlatform(_ dto: PlatformDTO) -> PlatformEntity {
        PlatformEntity(id: dto.id, name: dto.name, slug: dto.slug)
    }

    private static func mapGenre(_ dto: GenreDTO) -> GenreEntity {
        GenreEntity(id: dto.id, name: dto.name, slug: dto.slug)
    }

    private static func mapDeveloper(_ dto: DeveloperDTO) -> DeveloperEntity {
        DeveloperEntity(id: dto.id, name: dto.name, slug: dto.slug)
    }

    private static func mapPublisher(_ dto: PublisherDTO) -> PublisherEntity {
        PublisherEntity(id: dto.id, name: dto.name, slug: dto.slug)
    }
}
