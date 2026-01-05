import XCTest
import Factory
@testable import FavoritesFeature

/// Tests for FavoritesFeature DI Assembly.
@MainActor
final class FavoritesFeatureAssemblyTests: XCTestCase {
    // MARK: - Container Resolution

    func test_favoritesRepository_resolves() {
        // Act
        let service = Container.shared.defaultFavoritesService()

        // Assert
        XCTAssertNotNil(service)
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

    func test_defaultFavoritesService_isSingleton() {
        // Act
        let service1 = Container.shared.defaultFavoritesService()
        let service2 = Container.shared.defaultFavoritesService()

        // Assert - same instance
        XCTAssertTrue(service1 === service2)
    }
}
