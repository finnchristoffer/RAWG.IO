import XCTest
import Factory
@testable import FavoritesFeature

/// Tests for FavoritesFeature DI Assembly.
@MainActor
final class FavoritesFeatureAssemblyTests: XCTestCase {
    // MARK: - Container Resolution

    func test_favoritesLocalDataSource_resolves() {
        // Act
        let dataSource = Container.shared.favoritesLocalDataSource()

        // Assert
        XCTAssertNotNil(dataSource)
    }

    func test_favoritesRepository_resolves() {
        // Act
        let repository = Container.shared.favoritesRepository()

        // Assert
        XCTAssertNotNil(repository)
    }

    func test_addFavoriteUseCase_resolves() {
        // Act
        let useCase = Container.shared.addFavoriteUseCase()

        // Assert
        XCTAssertNotNil(useCase)
    }

    func test_removeFavoriteUseCase_resolves() {
        // Act
        let useCase = Container.shared.removeFavoriteUseCase()

        // Assert
        XCTAssertNotNil(useCase)
    }

    func test_getFavoritesUseCase_resolves() {
        // Act
        let useCase = Container.shared.getFavoritesUseCase()

        // Assert
        XCTAssertNotNil(useCase)
    }

    func test_isFavoriteUseCase_resolves() {
        // Act
        let useCase = Container.shared.isFavoriteUseCase()

        // Assert
        XCTAssertNotNil(useCase)
    }

    func test_favoritesViewModel_resolves() {
        // Act
        let viewModel = Container.shared.favoritesViewModel()

        // Assert
        XCTAssertNotNil(viewModel)
    }

    func test_favoriteModelContainer_isSingleton() {
        // Act
        let container1 = Container.shared.favoriteModelContainer()
        let container2 = Container.shared.favoriteModelContainer()

        // Assert - same instance
        XCTAssertTrue(container1 === container2)
    }
}
