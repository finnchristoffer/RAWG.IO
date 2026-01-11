# ViewModel Rules

> **Pattern**: MVVM with @Observable

## ViewModel Structure

```swift
@Observable
final class GamesViewModel {
    // MARK: - State (read-only from outside)
    private(set) var games: [Game] = []
    private(set) var isLoading = false
    private(set) var error: Error?

    // MARK: - Dependencies
    @Injected(\.getGamesUseCase) private var getGamesUseCase

    // MARK: - Actions
    func fetchGames() async { ... }
    func loadMore() async { ... }
}
```

---

## Key Principles

### 1. Single Source of Truth

The ViewModel owns all UI state. Views only read and call actions.

```swift
// ✅ Good - ViewModel owns state
@Observable
final class SearchViewModel {
    private(set) var query: String = ""
    private(set) var results: [Game] = []

    func updateQuery(_ newQuery: String) {
        query = newQuery
        // debounce and search...
    }
}

// ❌ Bad - State split between View and ViewModel
struct SearchView: View {
    @State private var query = ""  // Don't do this
    @Bindable var viewModel: SearchViewModel
}
```

### 2. Dependency Injection via Factory

All dependencies must be injected, never instantiated directly:

```swift
// ✅ Good - Injected dependency
@Observable
final class GamesViewModel {
    @Injected(\.getGamesUseCase) private var getGamesUseCase
}

// ❌ Bad - Direct instantiation
@Observable
final class GamesViewModel {
    private let useCase = GetGamesUseCase()  // Not testable!
}
```

### 3. Async Actions

Use async/await for all asynchronous work:

```swift
func fetchGames() async {
    isLoading = true
    defer { isLoading = false }

    do {
        games = try await getGamesUseCase.execute(page: currentPage)
    } catch {
        self.error = error
    }
}
```

### 4. Error Handling

Always capture and expose errors for the UI to handle:

```swift
@Observable
final class GamesViewModel {
    private(set) var error: Error?

    func fetchGames() async {
        do {
            games = try await getGamesUseCase.execute()
            error = nil  // Clear previous error on success
        } catch {
            self.error = error
        }
    }

    func clearError() {
        error = nil
    }
}
```

---

## View Integration

### Binding to ViewModel

```swift
struct GamesListView: View {
    @State private var viewModel: GamesViewModel

    init(viewModel: GamesViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                gamesList
            }
        }
        .task {
            await viewModel.fetchGames()
        }
        .alert(
            "Error",
            isPresented: .constant(viewModel.error != nil),
            presenting: viewModel.error
        ) { _ in
            Button("OK") { viewModel.clearError() }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
}
```

---

## Testing ViewModels

```swift
final class GamesViewModelTests: XCTestCase {

    func test_fetchGames_whenSuccess_updatesGamesArray() async {
        // Arrange
        let (sut, spy) = makeSUT()
        spy.stubbedGames = [.fixture()]

        // Act
        await sut.fetchGames()

        // Assert
        XCTAssertEqual(
            sut.games.count,
            1,
            "Expected games.count to be 1 after successful fetch, check ViewModel state update"
        )
        XCTAssertNil(
            sut.error,
            "Expected error to be nil after successful fetch"
        )
    }

    func test_fetchGames_whenFailure_setsErrorState() async {
        // Arrange
        let (sut, spy) = makeSUT()
        spy.stubbedError = NSError(domain: "test", code: 1)

        // Act
        await sut.fetchGames()

        // Assert
        XCTAssertNotNil(
            sut.error,
            "Expected error to be set when UseCase throws, check catch block"
        )
        XCTAssertTrue(
            sut.games.isEmpty,
            "Expected games to remain empty on error"
        )
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: GamesViewModel, spy: GetGamesUseCaseSpy) {
        let spy = GetGamesUseCaseSpy()
        let sut = GamesViewModel(getGamesUseCase: spy)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, spy)
    }
}
```




---

## Anti-Patterns

<avoid>
❌ God ViewModels (500+ lines) — split into child ViewModels
❌ Business logic in ViewModel — delegate to UseCases
❌ Direct network calls — use Repository via UseCase
❌ Mutable public state — use `private(set)`
❌ Force unwrapping — handle optionals gracefully
❌ Mixing UI concerns (navigation) with state
</avoid>
