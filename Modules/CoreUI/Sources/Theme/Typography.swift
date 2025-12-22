import SwiftUI

/// Design system typography.
///
/// Provides consistent text styles across the app.
///
/// ## Usage
/// ```swift
/// Text("Title")
///     .font(Typography.title)
/// ```
public enum Typography {
    // MARK: - Display

    /// Large display text (32pt, bold).
    public static let largeTitle = Font.largeTitle.weight(.bold)

    /// Display title (28pt, bold).
    public static let title = Font.title.weight(.bold)

    /// Secondary title (22pt, semibold).
    public static let title2 = Font.title2.weight(.semibold)

    /// Tertiary title (20pt, semibold).
    public static let title3 = Font.title3.weight(.semibold)

    // MARK: - Body

    /// Headline text (17pt, semibold).
    public static let headline = Font.headline

    /// Body text (17pt, regular).
    public static let body = Font.body

    /// Callout text (16pt, regular).
    public static let callout = Font.callout

    /// Subheadline text (15pt, regular).
    public static let subheadline = Font.subheadline

    // MARK: - Supporting

    /// Footnote text (13pt, regular).
    public static let footnote = Font.footnote

    /// Caption text (12pt, regular).
    public static let caption = Font.caption

    /// Small caption text (11pt, regular).
    public static let caption2 = Font.caption2
}

// MARK: - View Modifier

/// Typography modifier for easy application.
public struct TypographyModifier: ViewModifier {
    let font: Font
    let color: Color

    public func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

public extension View {
    /// Applies typography style with optional color.
    func typography(_ font: Font, color: Color = ColorTokens.textPrimary) -> some View {
        modifier(TypographyModifier(font: font, color: color))
    }
}
