# Dependency Injection Rules

> **Framework**: [Factory](https://github.com/hmlongco/Factory)

## Overview

Factory is a lightweight dependency injection framework. Dependencies are registered in `Container` extensions and injected using `@Injected`.

---

## Registration Pattern

### Container Extension

Each module has its own `Container+ModuleName.swift`:

```swift
// Container+Games.swift
import Factory

extension Container {
    // Repository
    var gamesRepository: Factory<GamesRepositoryProtocol> {
        Factory(self) {
            GamesRepository(apiClient: self.apiClient())
        }
    }

    // UseCase
    var getGamesUseCase: Factory<GetGamesUseCaseProtocol> {
        Factory(self) {
            GetGamesUseCase(repository: self.gamesRepository())
        }
    }

    // ViewModel
    var gamesViewModel: Factory<GamesViewModel> {
        Factory(self) {
            GamesViewModel()
        }
    }
}
```

---

## Injection Patterns

### In ViewModels

```swift
@Observable
final class GamesViewModel {
    @Injected(\.getGamesUseCase) private var getGamesUseCase
    @Injected(\.searchGamesUseCase) private var searchGamesUseCase
}
```

### In Navigators

```swift
public final class GamesNavigator {
    @Injected(\.gamesViewModel) private var gamesViewModel

    public func makeGamesListView() -> some View {
        GamesListView(viewModel: gamesViewModel)
    }
}
```

---

## Scoping

### Singleton (Shared Instance)

```swift
var apiClient: Factory<APIClient> {
    Factory(self) { APIClient() }
        .singleton  // Same instance throughout app lifecycle
}
```

### Cached (Survives View Rebuilds)

```swift
var imageCache: Factory<ImageCache> {
    Factory(self) { ImageCache() }
        .cached  // Survives container resets
}
```

### Unique (Default - New Instance Each Time)

```swift
var gamesViewModel: Factory<GamesViewModel> {
    Factory(self) { GamesViewModel() }
    // Default scope - new instance each call
}
```

---

## Testing with Factory

### Override Dependencies in Tests

```swift
final class GamesViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func test_fetchGames_usesInjectedUseCase() async {
        // Arrange
        let spy = GetGamesUseCaseSpy()
        Container.shared.getGamesUseCase.register { spy }
        let sut = Container.shared.gamesViewModel()

        // Act
        await sut.fetchGames()

        // Assert
        XCTAssertEqual(
            spy.executeCallCount,
            1,
            "Expected UseCase to be called exactly once, verify @Injected usage"
        )
    }
}
```

### Using Contexts for Isolation

```swift
func test_apiClient_isolatedContext_usesMockClient() {
    // Arrange & Act
    Container.shared.with {
        $0.apiClient.register { MockAPIClient() }
    } do: {
        let client = Container.shared.apiClient()

        // Assert
        XCTAssertTrue(
            client is MockAPIClient,
            "Expected MockAPIClient inside context, check Factory version"
        )
    }
}
```




---

## Best Practices

### ✅ DO

```swift
// Register protocols, not concrete types
var gamesRepository: Factory<GamesRepositoryProtocol> {
    Factory(self) { GamesRepository(...) }
}

// Use @Injected for dependencies
@Injected(\.gamesRepository) private var repository

// Reset container in test setUp
override func setUp() {
    Container.shared.reset()
}
```

### ❌ DON'T

```swift
// Don't instantiate directly
let repository = GamesRepository()  // Not testable!

// Don't use Container.shared in production code
let repo = Container.shared.gamesRepository()  // Use @Injected instead

// Don't forget to register protocols
var gamesRepository: Factory<GamesRepository> {  // Should be protocol!
    Factory(self) { GamesRepository(...) }
}
```

---

## Module Dependencies

### Core Module

```swift
// Container+Core.swift
extension Container {
    var apiClient: Factory<APIClient> {
        Factory(self) { APIClient() }.singleton
    }

    var imageCache: Factory<ImageCacheProtocol> {
        Factory(self) { InMemoryImageCache() }
    }

    var logger: Factory<Logger> {
        Factory(self) { Logger() }.singleton
    }
}
```

### Feature Module

```swift
// Container+Games.swift
extension Container {
    var gamesRepository: Factory<GamesRepositoryProtocol> {
        Factory(self) {
            GamesRepository(apiClient: self.apiClient())
        }
    }
}
```

---

## Quality Gates

<checklist>
☐ All dependencies registered as Protocols
☐ Use `@Injected` in ViewModels, not direct Container access
☐ Singletons for shared state (APIClient, Logger)
☐ Tests reset Container in setUp
☐ Each module has its own Container extension
</checklist>
