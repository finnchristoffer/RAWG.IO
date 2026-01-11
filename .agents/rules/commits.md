# Git Commit Conventions

> **Format**: Conventional Commits

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Examples

```
feat(games): add infinite scroll to games list

fix(search): debounce search input to reduce API calls

refactor(core): extract ImageCache to separate actor

test(favorites): add unit tests for FavoritesService

docs(readme): update architecture diagram

chore(ci): add Periphery dead code detection
```

---

## Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or updating tests |
| `docs` | Documentation only changes |
| `style` | Formatting, missing semicolons, etc. |
| `perf` | Performance improvement |
| `chore` | Maintenance tasks (CI, dependencies, etc.) |
| `build` | Changes to build system or dependencies |
| `ci` | Changes to CI configuration |

---

## Scopes

Use module names as scopes:

| Scope | Module |
|-------|--------|
| `core` | Core module |
| `navigation` | CoreNavigation module |
| `network` | CoreNetwork module |
| `ui` | CoreUI module |
| `common` | Common module |
| `games` | GamesFeature |
| `search` | SearchFeature |
| `favorites` | FavoritesFeature |
| `detail` | DetailFeature |
| `app` | Main app target |
| `ci` | GitHub Actions workflows |
| `tuist` | Tuist configuration |

---

## Branch Naming

```
<type>/<short-description>
```

### Examples

```
feat/infinite-scroll
fix/search-debounce
refactor/image-cache-actor
test/favorites-unit-tests
```

---

## Best Practices

### ✅ DO

- Use lowercase for type and scope
- Keep subject line under 72 characters
- Use imperative mood ("add" not "added")
- Reference issue numbers in footer: `Closes #123`
- Squash fixup commits locally before pushing

### ❌ DON'T

- Don't end subject with period
- Don't use vague messages like "fix bug" or "update code"
- Don't mix unrelated changes in one commit
- Don't commit generated files (`.xcodeproj` is managed by Tuist)

---

## PR Checklist

```markdown
## Description
[Describe what this PR does]

## Type
- [ ] feat
- [ ] fix
- [ ] refactor
- [ ] test
- [ ] docs
- [ ] chore

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] SwiftLint passes
- [ ] Snapshot tests updated (if UI changes)
```

---

## Danger Automation

The project uses Danger to enforce:

- PR size limits (500 lines, 20 files)
- Test coverage for source changes
- PR description validation
- SwiftLint inline comments
