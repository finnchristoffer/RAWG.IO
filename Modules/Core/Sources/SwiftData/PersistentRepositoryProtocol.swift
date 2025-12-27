import Foundation
import SwiftData

/// Generic protocol for persistent data CRUD operations.
///
/// Implementations provide async methods for fetching, inserting,
/// and deleting persisted models.
///
/// ## Usage
/// ```swift
/// let repo: any PersistentRepositoryProtocol<FavoriteGameModel>
/// let favorites = try await repo.fetch()
/// ```
public protocol PersistentRepositoryProtocol<Model>: Sendable {
    associatedtype Model: PersistentModel

    /// Fetches all models matching the optional predicate.
    /// - Parameter predicate: Optional filter predicate.
    /// - Returns: Array of matching models.
    @MainActor
    func fetch(predicate: Predicate<Model>?) async throws -> [Model]

    /// Fetches all models without filtering.
    @MainActor
    func fetch() async throws -> [Model]

    /// Inserts a model into the store.
    /// - Parameter model: The model to insert.
    @MainActor
    func insert(_ model: Model) async throws

    /// Deletes a model from the store.
    /// - Parameter model: The model to delete.
    @MainActor
    func delete(_ model: Model) async throws
}
