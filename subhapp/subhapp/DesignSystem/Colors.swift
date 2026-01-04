//
//  Colors.swift
//  subhapp
//
//  Design System - Color Palette
//

import SwiftUI

extension Color {
    // MARK: - Primary Brand Colors
    static let shubhSaffron = Color(hex: "#FF9933")      // Sacred saffron - accent
    static let shubhGold = Color(hex: "#FFD700")         // Auspicious gold - highlights
    static let shubhDeepPurple = Color(hex: "#4A1C6B")   // Spiritual purple - premium feel

    // MARK: - Auspiciousness Gradient (for heat map)
    static let muhurtaExcellent = Color(hex: "#22C55E")  // Green - highly auspicious
    static let muhurtaGood = Color(hex: "#84CC16")       // Lime - good
    static let muhurtaNeutral = Color(hex: "#EAB308")    // Yellow - neutral
    static let muhurtaCaution = Color(hex: "#F97316")    // Orange - less favorable
    static let muhurtaAvoid = Color(hex: "#EF4444")      // Red - inauspicious (Rahu Kalam etc.)

    // MARK: - Semantic Surface Colors
    static let surfacePrimary = Color(hex: "#000000")    // Pure black for OLED
    static let surfaceElevated = Color(hex: "#1C1C1E")   // Elevated cards
    static let surfaceSecondary = Color(hex: "#2C2C2E") // Secondary surfaces

    // MARK: - Text Colors
    static let textPrimary = Color(hex: "#FFFFFF")
    static let textSecondary = Color(hex: "#EBEBF5").opacity(0.6)
    static let textTertiary = Color(hex: "#EBEBF5").opacity(0.3)

    // MARK: - Glass Effect Colors
    static let glassBackground = Color.white.opacity(0.15)
    static let glassBorder = Color.white.opacity(0.3)
}

// MARK: - Hex Initializer
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
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
