import SwiftUI
import Common

/// Public entry point for DetailFeature module.
/// Accepts UseCase protocols for clean architecture.
public struct DetailNavigator {
    private let getGameDetailUseCase: GetGameDetailUseCaseProtocol?
    private let addFavoriteUseCase: AddFavoriteUseCaseProtocol?
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol?
    private let isFavoriteUseCase: IsFavoriteUseCaseProtocol?

    public init(
        getGameDetailUseCase: GetGameDetailUseCaseProtocol?,
        addFavoriteUseCase: AddFavoriteUseCaseProtocol?,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol?,
        isFavoriteUseCase: IsFavoriteUseCaseProtocol?
    ) {
        self.getGameDetailUseCase = getGameDetailUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
    }

    /// Creates the game detail view.
    @MainActor
    public func navigateToDetail(
        gameId: Int,
        name: String,
        backgroundImageURL: URL? = nil
    ) -> some View {
        GameDetailView(
            gameId: gameId,
            gameName: name,
            backgroundImageURL: backgroundImageURL,
            getGameDetailUseCase: getGameDetailUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase
        )
    }
}
