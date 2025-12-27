import SwiftUI

/// Type-erased wrapper for sheet presentations.
///
/// Allows storing any SheetProtocol conforming type in a single published property.
public struct AnySheet: Identifiable, Equatable {
    public let id: AnyHashable
    private let viewBuilder: () -> AnyView

    public init<S: SheetProtocol>(_ sheet: S, @ViewBuilder content: @escaping () -> some View) {
        self.id = AnyHashable(sheet.id)
        self.viewBuilder = { AnyView(content()) }
    }

    /// The view to present.
    public var view: AnyView {
        viewBuilder()
    }

    public static func == (lhs: AnySheet, rhs: AnySheet) -> Bool {
        lhs.id == rhs.id
    }
}
