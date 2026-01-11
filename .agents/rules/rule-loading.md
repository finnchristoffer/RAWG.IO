# Rule Loading Guide

> **⚠️ IMPORTANT**: Always start from `agents.md` first, then load this file to determine which additional rules are needed.

This file helps determine which rules to load based on the context and task at hand.

---

## Rule Loading Order

1. **`agents.md`** — Master entry point (ALWAYS load first)
2. **`ai-rules/rule-loading.md`** — This file (determines which rules to load)
3. **`ai-rules/general.md`** — Core engineering principles (ALWAYS load)
4. **Task-specific rules** — Based on what you're working on

---

## Available Rules

| File | Purpose | Load When... |
|------|---------|--------------|
| `general.md` | Core Swift/Clean Architecture principles | Always |
| `view.md` | SwiftUI View best practices | Creating or modifying Views |
| `view-model.md` | ViewModel patterns with @Observable | Creating or modifying ViewModels |
| `testing.md` | TDD, Unit & Snapshot testing | Writing or updating tests |
| `dependencies.md` | Factory DI patterns | Setting up dependency injection |
| `commits.md` | Git conventions | Making commits or PRs |

---

## Rule Loading Triggers

### 📝 general.md - Core Engineering Principles
**Load when:**
- Always (default)
- Starting any new feature or module
- Making architectural decisions
- Discussing code quality or best practices

**Keywords:** architecture, design, MVVM, Clean Architecture, UseCase, Repository, SOLID

---

### 🎨 view.md - SwiftUI Views
**Load when:**
- Creating new SwiftUI views
- Building UI components
- Implementing view performance optimizations
- Adding accessibility features

**Keywords:** SwiftUI, View, UI, LazyVStack, ForEach, accessibility, animation

---

### 🎯 view-model.md - ViewModel Architecture
**Load when:**
- Creating ViewModels for SwiftUI views
- Implementing state management
- Managing async operations in UI
- Handling user interactions

**Keywords:** ViewModel, @Observable, state, async, user action

---

### 🧪 testing.md - Testing Framework
**Load when:**
- Writing any tests
- Setting up test suites
- Testing async code
- Working with snapshot tests

**Keywords:** test, XCTest, unit test, snapshot, makeSUT, trackForMemoryLeaks

---

### 🧩 dependencies.md - Dependency Injection
**Load when:**
- Setting up dependency injection
- Working with Factory framework
- Creating testable code with injected dependencies
- Registering new services in Container

**Keywords:** dependency, injection, @Injected, Factory, Container, mock

---

### 📋 commits.md - Git Commit Conventions
**Load when:**
- Making git commits
- Creating commit messages
- Setting up branch naming
- Preparing pull requests

**Keywords:** commit, git, branch, PR, conventional commits, feat, fix

---

## Quick Reference

```swift
// When building a new feature:
// Load: general.md, view.md, view-model.md, dependencies.md

// When writing tests:
// Load: general.md, testing.md, dependencies.md

// When reviewing/committing code:
// Load: general.md, commits.md

// When fixing a bug:
// Load: general.md, testing.md (for regression test)
```

---

## Rule Combinations by Task

### 🚀 Feature Development
1. Start with `general.md` for architecture decisions
2. Use `view-model.md` for state coordination
3. Apply `view.md` for UI implementation
4. Include `dependencies.md` for service integration
5. Follow with `testing.md` for test coverage

### 🔧 Bug Fixing
1. Apply `general.md` for error handling patterns
2. Use `testing.md` to write regression tests
3. Reference `commits.md` for proper commit message

### 📝 Code Review & Maintenance
1. Apply `general.md` for quality standards
2. Use `commits.md` for version control
3. Reference domain-specific rules as needed

---

## Loading Strategy

1. **Always load `general.md` first** — It provides the foundation
2. **Load domain-specific rules** based on the task
3. **Keep loaded rules minimal** — Only what's directly relevant
4. **Refresh rules** when switching contexts or tasks
