import Foundation
import SwiftData
import Factory

// MARK: - FavoritesFeature Module DI Assembly

extension Container {
    // MARK: - SwiftData

    /// ModelContainer for FavoriteGame.
    var favoriteModelContainer: Factory<ModelContainer> {
        self {
            do {
                return try ModelContainer(for: FavoriteGame.self)
            } catch {
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
        .singleton
    }

    // MARK: - DataSources

    /// FavoritesLocalDataSource.
    var favoritesLocalDataSource: Factory<FavoritesLocalDataSource> {
        self { FavoritesLocalDataSource(modelContainer: self.favoriteModelContainer()) }
    }

    // MARK: - Repositories

    /// FavoritesRepository.
    var favoritesRepository: Factory<FavoritesRepository> {
        self { FavoritesRepository(localDataSource: self.favoritesLocalDataSource()) }
    }

    // MARK: - UseCases

    /// AddFavoriteUseCase.
    var addFavoriteUseCase: Factory<AddFavoriteUseCase> {
        self { AddFavoriteUseCase(repository: self.favoritesRepository()) }
    }

    /// RemoveFavoriteUseCase.
    var removeFavoriteUseCase: Factory<RemoveFavoriteUseCase> {
        self { RemoveFavoriteUseCase(repository: self.favoritesRepository()) }
    }

    /// GetFavoritesUseCase.
    var getFavoritesUseCase: Factory<GetFavoritesUseCase> {
        self { GetFavoritesUseCase(repository: self.favoritesRepository()) }
    }

    /// IsFavoriteUseCase.
    var isFavoriteUseCase: Factory<IsFavoriteUseCase> {
        self { IsFavoriteUseCase(repository: self.favoritesRepository()) }
    }

    // MARK: - ViewModels

    /// FavoritesViewModel.
    @MainActor var favoritesViewModel: Factory<FavoritesViewModel> {
        self {
            FavoritesViewModel(
                getFavoritesUseCase: self.getFavoritesUseCase(),
                removeFavoriteUseCase: self.removeFavoriteUseCase()
            )
        }
    }
}
