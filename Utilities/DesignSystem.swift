import SwiftUI

// MARK: - App Colors
struct AppColors {
    static let primary = Color("PrimaryColor")
    static let background = Color("BackgroundColor")
    static let text = Color("TextColor")
    static let textSecondary = Color("TextSecondaryColor")
    
    // Additional colors
    static let accent = Color("AccentColor")
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
}

// MARK: - App Typography
struct AppTypography {
    static func display(_ weight: Font.Weight = .bold) -> Font {
        return .system(size: 32, weight: weight, design: .rounded)
    }
    
    static func headline(_ weight: Font.Weight = .semibold) -> Font {
        return .system(size: 24, weight: weight, design: .rounded)
    }
    
    static func title(_ weight: Font.Weight = .semibold) -> Font {
        return .system(size: 20, weight: weight, design: .rounded)
    }
    
    static func body(_ weight: Font.Weight = .regular) -> Font {
        return .system(size: 16, weight: weight, design: .default)
    }
    
    static func caption(_ weight: Font.Weight = .regular) -> Font {
        return .system(size: 12, weight: weight, design: .default)
    }
    
    static func button(_ weight: Font.Weight = .semibold) -> Font {
        return .system(size: 16, weight: weight, design: .rounded)
    }
}

// MARK: - Spacing
struct Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
struct CornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 24
}

// MARK: - Shadows
struct AppShadows {
    static let small = Color.black.opacity(0.1)
    static let medium = Color.black.opacity(0.15)
    static let large = Color.black.opacity(0.2)
}

