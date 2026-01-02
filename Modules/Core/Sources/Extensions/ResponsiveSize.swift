import UIKit

// MARK: - Design Reference Size (iPhone 13)

/// Reference design size from Figma - iPhone 13
public enum DesignReference {
    public static let width: CGFloat = 390
    public static let height: CGFloat = 844
}

// MARK: - Screen Helper

/// Provides current screen dimensions
@MainActor
public enum ScreenSize {
    public static var width: CGFloat {
        UIScreen.main.bounds.width
    }

    public static var height: CGFloat {
        UIScreen.main.bounds.height
    }
}

// MARK: - Extension Namespace Wrapper

/// Namespace wrapper for responsive size extensions.
/// Usage: `150.ext.h` or `150.ext.w`
public struct ExtensionWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Protocol to add `.ext` namespace to types.
public protocol ExtensionCompatible {
    associatedtype CompatibleType
    var ext: ExtensionWrapper<CompatibleType> { get }
}

public extension ExtensionCompatible {
    var ext: ExtensionWrapper<Self> {
        ExtensionWrapper(self)
    }
}

// MARK: - Conformance

extension CGFloat: ExtensionCompatible {}
extension Double: ExtensionCompatible {}
extension Int: ExtensionCompatible {}

// MARK: - Responsive Size Extensions

@MainActor
public extension ExtensionWrapper where Base == CGFloat {
    /// Scales the value proportionally based on screen width relative to iPhone 13 design.
    /// Example: `150.ext.w` on iPhone 13 returns 150, on iPhone SE returns ~144
    var w: CGFloat { // swiftlint:disable:this identifier_name
        base * ScreenSize.width / DesignReference.width
    }

    /// Scales the value proportionally based on screen height relative to iPhone 13 design.
    /// Example: `150.ext.h` on iPhone 13 returns 150, on iPhone SE returns ~119
    var h: CGFloat { // swiftlint:disable:this identifier_name
        base * ScreenSize.height / DesignReference.height
    }

    /// Scales font size based on width, with a minimum scale factor for readability.
    var scaledFont: CGFloat {
        let scale = ScreenSize.width / DesignReference.width
        let minScale = max(scale, 0.85)
        return base * minScale
    }
}

@MainActor
public extension ExtensionWrapper where Base == Double {
    /// Scales the value proportionally based on screen width.
    var w: CGFloat { // swiftlint:disable:this identifier_name
        CGFloat(base) * ScreenSize.width / DesignReference.width
    }

    /// Scales the value proportionally based on screen height.
    var h: CGFloat { // swiftlint:disable:this identifier_name
        CGFloat(base) * ScreenSize.height / DesignReference.height
    }

    /// Scales font size with minimum safety.
    var scaledFont: CGFloat {
        let scale = ScreenSize.width / DesignReference.width
        let minScale = max(scale, 0.85)
        return CGFloat(base) * minScale
    }
}

@MainActor
public extension ExtensionWrapper where Base == Int {
    /// Scales the value proportionally based on screen width.
    var w: CGFloat { // swiftlint:disable:this identifier_name
        CGFloat(base) * ScreenSize.width / DesignReference.width
    }

    /// Scales the value proportionally based on screen height.
    var h: CGFloat { // swiftlint:disable:this identifier_name
        CGFloat(base) * ScreenSize.height / DesignReference.height
    }

    /// Scales font size with minimum safety.
    var scaledFont: CGFloat {
        let scale = ScreenSize.width / DesignReference.width
        let minScale = max(scale, 0.85)
        return CGFloat(base) * minScale
    }
}

// MARK: - Usage Examples
/*
 import Core

 // Width-based scaling
 .padding(.horizontal, 20.ext.w)
 .frame(width: 150.ext.w)

 // Height-based scaling
 .frame(height: 280.ext.h)
 .padding(.vertical, 16.ext.h)

 // Font scaling
 .font(.system(size: 18.ext.scaledFont))

 // Works with Int, Double, and CGFloat
 .padding(.vertical, 16.ext.h)
 .frame(height: 280.0.ext.h)
*/
