import XCTest
import SwiftUI
@testable import CoreNavigation

/// Tests for CoreNavigation module.
@MainActor
final class CoreNavigationTests: XCTestCase {
    // MARK: - RouteProtocol

    func test_routeProtocol_conformsToHashable() {
        // Arrange
        let route1 = TestRoute.detail(id: 1)
        let route2 = TestRoute.detail(id: 1)
        let route3 = TestRoute.detail(id: 2)

        // Assert
        XCTAssertEqual(route1, route2)
        XCTAssertNotEqual(route1, route3)
    }

    // MARK: - RouteRegistry

    func test_routeRegistry_registerAndResolve() {
        // Arrange
        let registry = RouteRegistry.shared
        registry.register(TestRoute.self) { route in
            switch route {
            case .detail(let id):
                AnyView(Text("Detail \(id)"))
            case .list:
                AnyView(Text("List"))
            }
        }

        // Act
        let resolved = registry.resolve(TestRoute.detail(id: 42))

        // Assert
        XCTAssertNotNil(resolved)
    }

    func test_routeRegistry_unregisteredRouteReturnsPlaceholder() {
        // Arrange
        let registry = RouteRegistry.shared

        // Act
        let resolved = registry.resolve(UnregisteredRoute.unknown)

        // Assert - should not crash, returns placeholder view
        XCTAssertNotNil(resolved)
    }

    // MARK: - NavigationRouter

    func test_navigationRouter_initialState() {
        // Arrange
        let router = NavigationRouter()

        // Assert
        XCTAssertTrue(router.path.isEmpty)
    }

    func test_navigationRouter_navigate() {
        // Arrange
        let router = NavigationRouter()

        // Act
        router.navigate(to: TestRoute.detail(id: 1))

        // Assert
        XCTAssertEqual(router.path.count, 1)
    }

    func test_navigationRouter_goBack() {
        // Arrange
        let router = NavigationRouter()
        router.navigate(to: TestRoute.detail(id: 1))
        XCTAssertEqual(router.path.count, 1)

        // Act
        router.goBack()

        // Assert
        XCTAssertTrue(router.path.isEmpty)
    }

    func test_navigationRouter_goBackOnEmptyPath() {
        // Arrange
        let router = NavigationRouter()
        XCTAssertTrue(router.path.isEmpty)

        // Act - should not crash
        router.goBack()

        // Assert
        XCTAssertTrue(router.path.isEmpty)
    }

    func test_navigationRouter_popToRoot() {
        // Arrange
        let router = NavigationRouter()
        router.navigate(to: TestRoute.detail(id: 1))
        router.navigate(to: TestRoute.detail(id: 2))
        router.navigate(to: TestRoute.detail(id: 3))
        XCTAssertEqual(router.path.count, 3)

        // Act
        router.popToRoot()

        // Assert
        XCTAssertTrue(router.path.isEmpty)
    }

    // MARK: - AnyRoute

    func test_anyRoute_equality() {
        // Arrange
        let route1 = AnyRoute(route: TestRoute.detail(id: 1)) { AnyView(Text("A")) }
        let route2 = AnyRoute(route: TestRoute.detail(id: 1)) { AnyView(Text("B")) }
        let route3 = AnyRoute(route: TestRoute.detail(id: 2)) { AnyView(Text("A")) }

        // Assert - equality based on route id, not view
        XCTAssertEqual(route1, route2)
        XCTAssertNotEqual(route1, route3)
    }

    func test_anyRoute_hashable() {
        // Arrange
        let route1 = AnyRoute(route: TestRoute.detail(id: 1)) { AnyView(Text("A")) }
        let route2 = AnyRoute(route: TestRoute.detail(id: 1)) { AnyView(Text("B")) }

        // Assert - can be used in Set
        var set: Set<AnyRoute> = []
        set.insert(route1)
        set.insert(route2)
        XCTAssertEqual(set.count, 1)
    }
}

// MARK: - Test Helpers

enum TestRoute: RouteProtocol {
    case detail(id: Int)
    case list
}

enum UnregisteredRoute: RouteProtocol {
    case unknown
}
