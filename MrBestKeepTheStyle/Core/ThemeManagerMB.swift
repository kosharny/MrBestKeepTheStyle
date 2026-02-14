import SwiftUI
import Combine

enum AppThemeMB: String, CaseIterable, Codable, Identifiable {
    case standard
    case royalBluePro
    case darkNeonPro
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .standard: return "Default"
        case .royalBluePro: return "Royal Blue Pro"
        case .darkNeonPro: return "Dark Neon Pro"
        }
    }
    
    var isPremium: Bool {
        return self != .standard
    }
    
    var productID: String? {
        switch self {
        case .standard: return nil
        case .royalBluePro: return "premium_theme_royal_blue"
        case .darkNeonPro: return "premium_theme_dark_neon"
        }
    }
}

class ThemeManagerMB: ObservableObject {
    @AppStorage("selectedTheme") var currentTheme: AppThemeMB = .standard
    
    // Electric Blue #2563FF
    // Neon Mint #2FFFD3
    // Deep Indigo #1E1B4B
    
    var primaryColor: Color {
        switch currentTheme {
        case .standard: return Color(hex: "2563FF")
        case .royalBluePro: return Color(hex: "4169E1")
        case .darkNeonPro: return Color(hex: "FF00FF")
        }
    }
    
    var secondaryColor: Color {
        switch currentTheme {
        case .standard: return Color(hex: "2FFFD3")
        case .royalBluePro: return Color(hex: "FFD700")
        case .darkNeonPro: return Color(hex: "00FFFF")
        }
    }
    
    var backgroundColor: Color {
        return Color(hex: "1E1B4B") // Deep Indigo
    }
    
    var backgroundGradient: LinearGradient {
        switch currentTheme {
        case .standard:
            return LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")], // Visible Deep Blue Gradient
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .royalBluePro:
            return LinearGradient(
                colors: [Color(hex: "000428"), Color(hex: "004e92")],
                startPoint: .top,
                endPoint: .bottom
            )
        case .darkNeonPro:
            return LinearGradient(
                colors: [Color.black, Color(hex: "2a0a2a"), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var glowColor: Color {
        return secondaryColor.opacity(0.6)
    }
    
    // MARK: - Theme-Specific Colors
    func primaryColor(for theme: AppThemeMB) -> Color {
        switch theme {
        case .standard: return Color(hex: "2563FF")
        case .royalBluePro: return Color(hex: "4169E1")
        case .darkNeonPro: return Color(hex: "FF00FF")
        }
    }
    
    func secondaryColor(for theme: AppThemeMB) -> Color {
        switch theme {
        case .standard: return Color(hex: "2FFFD3")
        case .royalBluePro: return Color(hex: "FFD700")
        case .darkNeonPro: return Color(hex: "00FFFF")
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ZStack {
        ThemeManagerMB().backgroundGradient.ignoresSafeArea()
        Text("Theme Preview")
            .foregroundColor(ThemeManagerMB().primaryColor)
            .shadow(color: ThemeManagerMB().glowColor, radius: 10)
    }
}
