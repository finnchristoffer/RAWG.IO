# SwiftUI View Rules

> **Framework**: SwiftUI with strict module encapsulation

## View Structure

```swift
internal struct GamesListView: View {
    @State private var viewModel: GamesViewModel

    init(viewModel: GamesViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .task { await viewModel.fetchGames() }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.error {
            errorView(error)
        } else {
            gamesList
        }
    }
}
```

---

## Key Principles

### 1. Views are `internal`

All Views inside feature modules are `internal`. Only the Navigator is `public`.

```swift
// ✅ Correct
internal struct GamesListView: View { }

// ❌ Wrong - leaking implementation
public struct GamesListView: View { }
```

### 2. Use `@State` for ViewModel

With `@Observable`, use `@State` to hold the ViewModel:

```swift
struct GamesListView: View {
    @State private var viewModel: GamesViewModel

    init(viewModel: GamesViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
}
```

### 3. Extract Complex Subviews

Keep `body` readable by extracting components:

```swift
var body: some View {
    ScrollView {
        LazyVStack {
            headerSection
            gamesList
            footerSection
        }
    }
}

@ViewBuilder
private var headerSection: some View {
    Text("Popular Games")
        .font(.title)
}

@ViewBuilder
private var gamesList: some View {
    ForEach(viewModel.games) { game in
        GameRowView(game: game)
    }
}
```

---

## Performance Best Practices

### Use Lazy Stacks

```swift
// ✅ Good - Lazy loading
LazyVStack {
    ForEach(games) { game in
        GameRowView(game: game)
    }
}

// ❌ Bad - Loads all items immediately
VStack {
    ForEach(games) { game in
        GameRowView(game: game)
    }
}
```

### Avoid Heavy Computations in body

```swift
// ✅ Good - Computed once
private var sortedGames: [Game] {
    games.sorted { $0.rating > $1.rating }
}

var body: some View {
    ForEach(sortedGames) { ... }
}

// ❌ Bad - Computed on every render
var body: some View {
    ForEach(games.sorted { $0.rating > $1.rating }) { ... }
}
```

### Use `.id()` for Efficient Updates

```swift
ForEach(games) { game in
    GameRowView(game: game)
}
.id(games.hashValue)  // Forces refresh when data changes
```

---

## Accessibility

### Always Provide Accessibility Labels

```swift
Image(systemName: "heart.fill")
    .accessibilityLabel("Favorite")
    .accessibilityHint("Double tap to remove from favorites")
```

### Support Dynamic Type

```swift
Text("Game Title")
    .font(.headline)  // Scales with Dynamic Type

// Avoid fixed font sizes
Text("Game Title")
    .font(.system(size: 16))  // ❌ Doesn't scale
```

### Semantic Containers

```swift
VStack {
    // Group related elements
}
.accessibilityElement(children: .combine)
.accessibilityLabel("Game: \(game.name), Rating: \(game.rating)")
```

---

## Loading States

```swift
@ViewBuilder
private var content: some View {
    switch (viewModel.isLoading, viewModel.error, viewModel.games.isEmpty) {
    case (true, _, _):
        ProgressView()
    case (_, let error?, _):
        ErrorView(error: error, retry: { await viewModel.fetchGames() })
    case (_, _, true):
        EmptyStateView(message: "No games found")
    default:
        gamesList
    }
}
```

---

## Navigation

Use the `NavigationRouter` from `CoreNavigation`:

```swift
struct GamesListView: View {
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        Button("View Details") {
            router.navigate(to: GameDetailRoute(id: game.id))
        }
    }
}
```

---

## Quality Gates

<checklist>
☐ Views are `internal`, not `public`
☐ ViewModel is held with `@State`
☐ Complex subviews extracted as computed properties
☐ Uses `LazyVStack`/`LazyHStack` for lists
☐ Accessibility labels provided
☐ Loading, error, and empty states handled
☐ No business logic in View
</checklist>
