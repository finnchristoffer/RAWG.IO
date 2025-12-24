import Foundation

/// ViewModel for Game Detail screen.
@MainActor
public final class GameDetailViewModel: ObservableObject {
    @Published public private(set) var gameId: Int
    @Published public private(set) var gameName: String
    @Published public private(set) var isLoading = false
    @Published public private(set) var error: Error?

    public init(gameId: Int, gameName: String) {
        self.gameId = gameId
        self.gameName = gameName
    }

    /// Placeholder for future detail loading.
    public func loadDetails() async {
        isLoading = true
        // Future: Call GetGameDetailUseCase
        isLoading = false
    }
}
