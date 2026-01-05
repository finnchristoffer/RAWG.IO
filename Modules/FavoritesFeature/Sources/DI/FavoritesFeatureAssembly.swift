import Foundation
import SwiftData
import Factory
import Common
import Core

// MARK: - FavoritesFeature Module DI Assembly
// All factories are internal - only FavoritesNavigator is public.

extension Container {
    // MARK: - Internal Services

    /// DefaultFavoritesService - internal singleton.
    var defaultFavoritesService: Factory<DefaultFavoritesService> {
        self { DefaultFavoritesService() }
            .singleton
    }

    // MARK: - UseCases (Internal)

    /// AddFavoriteUseCase - returns protocol type.
    var addFavoriteUseCase: Factory<AddFavoriteUseCaseProtocol> {
        self { AddFavoriteUseCase(repository: self.defaultFavoritesService()) as AddFavoriteUseCaseProtocol }
    }

    /// RemoveFavoriteUseCase - returns protocol type.
    var removeFavoriteUseCase: Factory<RemoveFavoriteUseCaseProtocol> {
        self { RemoveFavoriteUseCase(repository: self.defaultFavoritesService()) as RemoveFavoriteUseCaseProtocol }
    }

    /// IsFavoriteUseCase - returns protocol type.
    var isFavoriteUseCase: Factory<IsFavoriteUseCaseProtocol> {
        self { IsFavoriteUseCase(repository: self.defaultFavoritesService()) as IsFavoriteUseCaseProtocol }
    }

    /// GetFavoritesUseCase - returns protocol type.
    var getFavoritesUseCase: Factory<GetFavoritesUseCaseProtocol> {
        self { GetFavoritesUseCase(repository: self.defaultFavoritesService()) as GetFavoritesUseCaseProtocol }
    }

    // MARK: - ViewModels (Internal)

    /// FavoritesViewModel - internal.
    @MainActor var favoritesViewModel: Factory<FavoritesViewModel> {
        self {
            FavoritesViewModel(
                getFavoritesUseCase: self.getFavoritesUseCase(),
                removeFavoriteUseCase: self.removeFavoriteUseCase()
            )
        }
    }
}
