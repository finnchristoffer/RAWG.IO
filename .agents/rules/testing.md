# Testing Rules

> **Framework**: XCTest + swift-snapshot-testing

## Test-Driven Development (TDD)

Follow the **Red-Green-Refactor** cycle:

```
1. 🔴 Write failing test
2. 🟢 Write minimal code to pass
3. 🔵 Refactor while tests stay green
```

---

## Test Types

| Type | Framework | Use Case |
|------|-----------|----------|
| **Unit Tests** | XCTest | ViewModels, UseCases, Repositories, Mappers |
| **Snapshot Tests** | swift-snapshot-testing | SwiftUI Views |
| **Integration Tests** | XCTest | API Client, SwiftData |

---

## Unit Test Patterns

### The `makeSUT()` Pattern

Always use a factory method to create the System Under Test:

```swift
final class GamesViewModelTests: XCTestCase {

    func test_fetchGames_success() async {
        // Arrange
        let (sut, spy) = makeSUT()
        spy.stubbedGames = [.fixture()]

        // Act
        await sut.fetchGames()

        // Assert
        XCTAssertEqual(sut.games.count, 1)
        XCTAssertFalse(sut.isLoading)
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

### Memory Leak Detection

Add this helper to your test target:

```swift
extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}
```

### Test Doubles (Spies)

```swift
final class GetGamesUseCaseSpy: GetGamesUseCaseProtocol {
    var executeCallCount = 0
    var stubbedGames: [Game] = []
    var stubbedError: Error?

    func execute(page: Int) async throws -> [Game] {
        executeCallCount += 1
        if let error = stubbedError {
            throw error
        }
        return stubbedGames
    }
}
```

---

## Writing Descriptive Test Expectations

Every test should have a clear structure and descriptive assertion messages.

### Test Naming Convention

Use this format: `test_[methodUnderTest]_[scenario]_[expectedBehavior]`

```swift
// ✅ Good - Clear what is being tested
func test_fetchGames_whenSuccess_updatesGamesArray() async { }
func test_fetchGames_whenError_setsErrorState() async { }
func test_fetchGames_whileLoading_doesNotFetchAgain() async { }

// ❌ Bad - Vague naming
func test_fetchGames() async { }
func test_success() async { }
```

### Test Structure with Descriptive Assertions

```swift
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
    XCTAssertFalse(
        sut.isLoading,
        "Expected isLoading to be false after fetch completes, check defer block"
    )
}
```

### Failure Troubleshooting Guide

| Assertion Failure | Likely Cause | How to Fix |
|-------------------|--------------|------------|
| `games.count != expected` | UseCase not returning data, or ViewModel not updating state | Check spy stubbed values; verify state assignment in ViewModel |
| `isLoading == true` after fetch | Missing `defer { isLoading = false }` | Add defer block or ensure loading is reset in all paths |
| `error == nil` when expected | Error not being captured | Check if catch block assigns `self.error = error` |
| Memory leak detected | Retain cycle in closure | Add `[weak self]` to closures; check captured references |
| Snapshot mismatch | UI changed or different simulator | Re-record with `record = true`; use consistent simulator |

### Complex Test Example

```swift
func test_search_withDebounce_onlyCallsUseCaseOnce() async {
    // Arrange
    let (sut, spy) = makeSUT()

    // Act
    sut.updateQuery("W")
    sut.updateQuery("Wi")
    sut.updateQuery("Wit")
    sut.updateQuery("Witch")
    try? await Task.sleep(nanoseconds: 600_000_000)

    // Assert
    XCTAssertEqual(
        spy.executeCallCount,
        1,
        "Expected UseCase to be called once due to debouncing"
    )
    XCTAssertEqual(
        spy.capturedQuery,
        "Witch",
        "Expected final debounced query to be 'Witch'"
    )
}
```

### Error Case Example

```swift
func test_fetchGames_whenUseCaseThrows_setsErrorState() async {
    // Arrange
    let (sut, spy) = makeSUT()
    spy.stubbedError = NSError(domain: "TestError", code: 500)

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
    XCTAssertFalse(
        sut.isLoading,
        "Expected isLoading to be false after error, check defer block"
    )
}
```



---

## Snapshot Testing

### Setup

```swift
import SnapshotTesting
import XCTest

final class GameDetailViewSnapshotTests: XCTestCase {

    func test_gameDetailView_displaysGameInfo() {
        // Arrange
        let viewModel = GameDetailViewModel(
            gameId: 123,
            gameName: "The Witcher 3: Wild Hunt",
            rating: 4.5,
            isPreview: true
        )
        let view = GameDetailView(viewModel: viewModel)
            .frame(width: 390, height: 844)

        // Assert
        assertSnapshot(of: view, as: .image)
    }
}
```

### Best Practices

- Set `isPreview: true` in ViewModels for deterministic data
- Use fixed frame sizes (e.g., iPhone 14 Pro: 390x844)
- Run `record = true` once to generate reference images
- Commit reference images to the repository

---

## Testing Async Code

```swift
func test_fetchGames_setsLoadingState() async {
    let (sut, _) = makeSUT()

    XCTAssertFalse(sut.isLoading)

    async let _ = sut.fetchGames()

    // Use XCTAssertEventually or wait for state changes
    XCTAssertTrue(sut.isLoading)
}
```

---

## Quality Gates

<checklist>
☐ Every UseCase has unit tests
☐ Every ViewModel has unit tests
☐ Every public View has snapshot tests
☐ All tests use `makeSUT()` pattern
☐ All SUTs are tracked for memory leaks
☐ No real network calls in unit tests (use spies)
☐ Snapshot reference images are committed
</checklist>
