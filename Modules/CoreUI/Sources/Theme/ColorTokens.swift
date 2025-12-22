import SwiftUI

/// Design system color tokens.
///
/// Provides a centralized color palette for the app.
/// 
/// ## Usage
/// ```swift
/// Text("Hello")
///     .foregroundColor(ColorTokens.primary)
/// ```
public enum ColorTokens {
    // MARK: - Primary Colors

    /// Main brand color.
    public static let primary = Color("Primary", bundle: .module)

    /// Secondary brand color.
    public static let secondary = Color("Secondary", bundle: .module)

    /// Accent color for highlights.
    public static let accent = Color("Accent", bundle: .module)

    // MARK: - Background Colors

    /// Primary background color.
    public static let background = Color("Background", bundle: .module)

    /// Secondary/elevated background.
    public static let backgroundSecondary = Color("BackgroundSecondary", bundle: .module)

    /// Card/surface background.
    public static let surface = Color("Surface", bundle: .module)

    // MARK: - Text Colors

    /// Primary text color.
    public static let textPrimary = Color("TextPrimary", bundle: .module)

    /// Secondary/muted text color.
    public static let textSecondary = Color("TextSecondary", bundle: .module)

    // MARK: - Semantic Colors

    /// Success/positive color.
    public static let success = Color.green

    /// Warning color.
    public static let warning = Color.orange

    /// Error/destructive color.
    public static let error = Color.red

    // MARK: - Rating Colors

    /// Color for high ratings (4-5).
    public static let ratingHigh = Color.green

    /// Color for medium ratings (3-4).
    public static let ratingMedium = Color.yellow

    /// Color for low ratings (0-3).
    public static let ratingLow = Color.red

    /// Returns appropriate color for a rating value.
    public static func rating(_ value: Double) -> Color {
        switch value {
        case 4...5: return ratingHigh
        case 3..<4: return ratingMedium
        default: return ratingLow
        }
    }
}
