import Foundation
import Core
import Common

/// ViewModel for Game Detail screen.
/// Uses Clean Architecture - only injects UseCase protocols.
@MainActor
final class GameDetailViewModel: ObservableObject {
    // MARK: - Published State

    @Published private(set) var gameId: Int
    @Published private(set) var gameName: String
    @Published private(set) var backgroundImageURL: URL?
    @Published private(set) var isLoading = false
    @Published private(set) var isFavorite = false
    @Published private(set) var error: Error?

    // Game Detail Data
    @Published private(set) var rating: Double = 0.0
    @Published private(set) var released: String?
    @Published private(set) var platforms: [String] = []
    @Published private(set) var descriptionText: String?
    @Published private(set) var metacritic: Int?

    // MARK: - Dependencies (UseCases)

    private let getGameDetailUseCase: GetGameDetailUseCaseProtocol?
    private let addFavoriteUseCase: AddFavoriteUseCaseProtocol?
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol?
    private let isFavoriteUseCase: IsFavoriteUseCaseProtocol?

    // MARK: - Private State

    private var gameDetail: GameDetailEntity?
    private let isPreview: Bool

    /// Standard initializer with UseCase injection.
    init(
        gameId: Int,
        gameName: String,
        backgroundImageURL: URL? = nil,
        getGameDetailUseCase: GetGameDetailUseCaseProtocol?,
        addFavoriteUseCase: AddFavoriteUseCaseProtocol?,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol?,
        isFavoriteUseCase: IsFavoriteUseCaseProtocol?
    ) {
        self.gameId = gameId
        self.gameName = gameName
        self.backgroundImageURL = backgroundImageURL
        self.getGameDetailUseCase = getGameDetailUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.isPreview = false
    }

    /// Preview initializer with mock data.
    init(
        gameId: Int,
        gameName: String,
        backgroundImageURL: URL? = nil,
        rating: Double = 0.0,
        released: String? = nil,
        platforms: [String] = [],
        descriptionText: String? = nil,
        metacritic: Int? = nil,
        isPreview: Bool = true
    ) {
        self.gameId = gameId
        self.gameName = gameName
        self.backgroundImageURL = backgroundImageURL
        self.rating = rating
        self.released = released
        self.platforms = platforms
        self.descriptionText = descriptionText
        self.metacritic = metacritic
        self.getGameDetailUseCase = nil
        self.addFavoriteUseCase = nil
        self.removeFavoriteUseCase = nil
        self.isFavoriteUseCase = nil
        self.isPreview = isPreview
    }

    /// Loads game details from API and checks favorite status.
    func loadDetails() async {
        guard !isPreview else { return }

        isLoading = true
        error = nil

        if let useCase = getGameDetailUseCase {
            do {
                let detail = try await useCase.execute(id: gameId)
                gameDetail = detail

                gameName = detail.name
                rating = detail.rating
                released = detail.released
                descriptionText = detail.descriptionRaw ?? detail.description
                metacritic = detail.metacritic
                platforms = detail.platforms.map { $0.name }
                if let imageURL = detail.backgroundImage {
                    backgroundImageURL = imageURL
                }
            } catch {
                self.error = error
                Logger.error("Failed to load game detail: \(error)")
            }
        }

        await checkFavoriteStatus()
        isLoading = false
    }

    /// Toggles the favorite status of the game.
    func toggleFavorite() async {
        guard !isPreview else { return }

        do {
            if isFavorite {
                try await removeFavoriteUseCase?.execute(gameId: gameId)
                isFavorite = false
            } else {
                let game = GameEntity(
                    id: gameId,
                    slug: "",
                    name: gameName,
                    released: released,
                    backgroundImage: backgroundImageURL,
                    rating: rating,
                    ratingsCount: 0,
                    metacritic: metacritic,
                    playtime: 0,
                    platforms: platforms.map { PlatformEntity(id: 0, name: $0, slug: $0.lowercased()) },
                    genres: []
                )
                try await addFavoriteUseCase?.execute(game)
                isFavorite = true
            }
        } catch {
            self.error = error
            Logger.error("Favorite toggle error: \(error)")
        }
    }

    // MARK: - Computed Properties

    var releaseYear: String {
        guard let released else { return "—" }
        return String(released.prefix(4))
    }

    var primaryPlatform: String {
        platforms.first ?? "—"
    }

    var ratingString: String {
        String(format: "%.1f", rating)
    }

    // MARK: - Private

    private func checkFavoriteStatus() async {
        guard !isPreview, let useCase = isFavoriteUseCase else { return }

        do {
            isFavorite = try await useCase.execute(gameId: gameId)
        } catch {
            self.error = error
        }
    }
}
