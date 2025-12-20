import XCTest
import SwiftUI
import SnapshotTesting

/// Extension providing snapshot testing helpers.
@MainActor
public extension XCTestCase {
    /// Asserts or records a snapshot of a SwiftUI view.
    func assertSnapshot<V: View>(
        of view: V,
        named name: String? = nil,
        record: Bool = false,
        file: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line
    ) {
        let controller = UIHostingController(rootView: view)
        controller.view.frame = UIScreen.main.bounds
        controller.view.layoutIfNeeded()

        SnapshotTesting.assertSnapshot(
            of: controller,
            as: .image(on: .iPhone13),
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Asserts or records a snapshot of a UIViewController.
    func assertSnapshot(
        of controller: UIViewController,
        named name: String? = nil,
        record: Bool = false,
        file: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line
    ) {
        SnapshotTesting.assertSnapshot(
            of: controller,
            as: .image(on: .iPhone13),
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }
}
