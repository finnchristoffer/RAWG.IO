# Animation & UX Rules

> **Framework**: SwiftUI Animations with modern patterns

## Animation Principles

### 1. Use Implicit Animations for State Changes

```swift
// ✅ Good - Implicit animation
Button("Toggle") {
    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
        isExpanded.toggle()
    }
}

// ❌ Avoid - No animation feels jarring
Button("Toggle") {
    isExpanded.toggle()
}
```

### 2. Prefer Spring Animations

Spring animations feel more natural than linear or easeInOut:

```swift
// ✅ Recommended defaults
.spring(response: 0.3, dampingFraction: 0.7)  // Snappy
.spring(response: 0.5, dampingFraction: 0.8)  // Smooth
.spring(response: 0.6, dampingFraction: 0.6)  // Bouncy
```

---

## Common Animation Patterns

### Loading States

```swift
struct ShimmerView: View {
    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.5), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isAnimating ? 200 : -200)
            )
            .clipped()
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}
```

### List Item Appearance

```swift
ForEach(Array(games.enumerated()), id: \.element.id) { index, game in
    GameRowView(game: game)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(
            .spring(response: 0.4, dampingFraction: 0.8)
                .delay(Double(index) * 0.05),
            value: appeared
        )
}
```

### Button Press Feedback

```swift
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// Usage
Button("Tap Me") { }
    .buttonStyle(ScaleButtonStyle())
```

### Page Transitions

```swift
NavigationStack {
    // ...
}
.navigationTransition(.slide)

// Or custom matched geometry
@Namespace private var animation

Image(game.thumbnail)
    .matchedGeometryEffect(id: game.id, in: animation)
```

---

## Micro-interactions

### Haptic Feedback

```swift
// Light tap
UIImpactFeedbackGenerator(style: .light).impactOccurred()

// Success
UINotificationFeedbackGenerator().notificationOccurred(.success)

// Selection change
UISelectionFeedbackGenerator().selectionChanged()
```

### Pull to Refresh

```swift
List {
    // content
}
.refreshable {
    await viewModel.refresh()
}
```

### Swipe Actions

```swift
ForEach(games) { game in
    GameRowView(game: game)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.delete(game)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                viewModel.toggleFavorite(game)
            } label: {
                Label("Favorite", systemImage: "heart")
            }
            .tint(.pink)
        }
}
```

---

## Transition Patterns

### Opacity + Move

```swift
.transition(.opacity.combined(with: .move(edge: .bottom)))
```

### Scale + Opacity

```swift
.transition(.scale(scale: 0.8).combined(with: .opacity))
```

### Asymmetric Transitions

```swift
.transition(.asymmetric(
    insertion: .opacity.combined(with: .move(edge: .trailing)),
    removal: .opacity.combined(with: .move(edge: .leading))
))
```

---

## Performance Guidelines

### Use `drawingGroup()` for Complex Animations

```swift
ComplexAnimatedView()
    .drawingGroup()  // Rasterizes to Metal
```

### Avoid Animating Layout-Heavy Properties

```swift
// ✅ Good - GPU properties
.opacity()
.scaleEffect()
.offset()
.rotation3DEffect()

// ❌ Avoid animating - causes layout recalculation
.frame()
.padding()
```

### Use `animation(_:value:)` Over Implicit

```swift
// ✅ Explicit - only animates when value changes
.animation(.spring(), value: isExpanded)

// ⚠️ Implicit - may animate unintended changes
.animation(.spring())
```

---

## Quality Gates

<checklist>
☐ State changes wrapped in `withAnimation`
☐ Spring animations used for natural feel
☐ Loading states have shimmer or skeleton
☐ Buttons have press feedback (scale or haptic)
☐ List items animate on appearance
☐ Heavy animations use `drawingGroup()`
☐ No jarring instant state changes
</checklist>
