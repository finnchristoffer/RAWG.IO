import Foundation

// MARK: - Game Detail UseCase

/// UseCase protocol for fetching game details.
public protocol GetGameDetailUseCaseProtocol: Sendable {
    func execute(id: Int) async throws -> GameDetailEntity
}
