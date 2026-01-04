//
//  Muhurta.swift
//  subhapp
//
//  Core Model - Muhurta (auspicious time period)
//

import Foundation
import SwiftUI

struct Muhurta: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let timeRange: TimeRange
    let type: MuhurtaType
    let auspiciousnessScore: Double  // 0-10

    enum MuhurtaType: String, Codable {
        case amritKalam = "Amrit Kalam"
        case abhijitMuhurta = "Abhijit Muhurta"
        case rahuKalam = "Rahu Kalam"
        case yamaganda = "Yamaganda"
        case gulikaKalam = "Gulika Kalam"
        case varjyam = "Varjyam"
        case durMuhurtam = "Dur Muhurtam"
        case regular = "Regular"

        var isAuspicious: Bool {
            switch self {
            case .amritKalam, .abhijitMuhurta:
                return true
            case .rahuKalam, .yamaganda, .gulikaKalam, .varjyam, .durMuhurtam:
                return false
            case .regular:
                return true  // Neutral, generally okay
            }
        }

        var icon: String {
            switch self {
            case .amritKalam: return "sparkles"
            case .abhijitMuhurta: return "star.fill"
            case .rahuKalam: return "exclamationmark.triangle.fill"
            case .yamaganda: return "xmark.circle.fill"
            case .gulikaKalam: return "moon.fill"
            case .varjyam: return "nosign"
            case .durMuhurtam: return "exclamationmark.circle.fill"
            case .regular: return "clock"
            }
        }

        var description: String {
            switch self {
            case .amritKalam:
                return "Highly auspicious time for important activities"
            case .abhijitMuhurta:
                return "Victory muhurta - excellent for new beginnings"
            case .rahuKalam:
                return "Avoid starting new ventures during this time"
            case .yamaganda:
                return "Associated with obstacles - avoid important work"
            case .gulikaKalam:
                return "Son of Saturn - avoid auspicious activities"
            case .varjyam:
                return "Inauspicious period - avoid important activities"
            case .durMuhurtam:
                return "Bad muhurta - avoid starting new work"
            case .regular:
                return "Normal time period"
            }
        }
    }

    /// Color based on auspiciousness
    var color: Color {
        switch auspiciousnessScore {
        case 8...10: return .muhurtaExcellent
        case 6..<8: return .muhurtaGood
        case 4..<6: return .muhurtaNeutral
        case 2..<4: return .muhurtaCaution
        default: return .muhurtaAvoid
        }
    }

    var isAuspicious: Bool {
        type.isAuspicious && auspiciousnessScore >= 6
    }

    var isRahuKalam: Bool { type == .rahuKalam }
    var isYamaganda: Bool { type == .yamaganda }
    var isGulikaKalam: Bool { type == .gulikaKalam }
    var isAmritKalam: Bool { type == .amritKalam }
    var isAbhijitMuhurta: Bool { type == .abhijitMuhurta }
}

// MARK: - Muhurta Window (for search results)
struct MuhurtaWindow: Identifiable, Equatable {
    let id: UUID
    let date: Date
    let timeRange: TimeRange
    let score: Double
    let reasons: [String]

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(date)
    }

    var dateLabel: String {
        if isToday {
            return "Today"
        } else if isTomorrow {
            return "Tomorrow"
        } else {
            return date.formattedShort
        }
    }
}
