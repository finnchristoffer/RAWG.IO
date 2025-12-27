import Foundation
import SwiftData

/// Generic Swift Data repository implementation.
///
/// Provides CRUD operations for any PersistentModel type.
/// Uses MainActor isolation for thread safety with SwiftUI.
///
/// ## Usage
/// ```swift
/// @Model class MyModel { ... }
/// let repo = SwiftDataRepository<MyModel>(modelContext: context)
/// let models = try await repo.fetch()
/// ```
@MainActor
public final class SwiftDataRepository<Model: PersistentModel>: PersistentRepositoryProtocol, @unchecked Sendable {
    private let modelContext: ModelContext

    /// Creates a repository with the given model context.
    /// - Parameter modelContext: The Swift Data model context.
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func fetch(predicate: Predicate<Model>?) async throws -> [Model] {
        let descriptor = FetchDescriptor<Model>(predicate: predicate)
        return try modelContext.fetch(descriptor)
    }

    public func fetch() async throws -> [Model] {
        try await fetch(predicate: nil)
    }

    public func insert(_ model: Model) async throws {
        modelContext.insert(model)
        try modelContext.save()
    }

    public func delete(_ model: Model) async throws {
        modelContext.delete(model)
        try modelContext.save()
    }
}
