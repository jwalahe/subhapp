//
//  Panchanga.swift
//  subhapp
//
//  Core Model - Complete Panchanga (Five limbs of Hindu calendar)
//

import Foundation
import SwiftUI

struct Panchanga: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date

    // The Five Limbs (Pancha + Anga)
    let tithi: Tithi           // Lunar day
    let nakshatra: Nakshatra   // Lunar mansion
    let yoga: Yoga             // Sun-Moon combination
    let karana: Karana         // Half of tithi
    let vara: Vara             // Day of week

    // Telugu Calendar Info
    let teluguMonth: String
    let teluguYear: String

    // Sun timings
    let sunrise: Date
    let sunset: Date

    // Inauspicious periods
    let rahuKalam: TimeRange
    let yamaganda: TimeRange
    let gulikaKalam: TimeRange

    // Auspicious periods (optional - may not occur every day)
    let amritKalam: TimeRange?
    let abhijitMuhurta: TimeRange?

    // Other inauspicious periods
    let varjyam: [TimeRange]
    let durMuhurtam: [TimeRange]

    // Calculated score
    let overallAuspiciousnessScore: Double  // 0-10

    // MARK: - Computed Properties

    var paksha: String {
        tithi.paksha.rawValue
    }

    var energyLevel: EnergyLevel {
        switch overallAuspiciousnessScore {
        case 8...10: return .excellent
        case 6..<8: return .good
        case 4..<6: return .neutral
        case 2..<4: return .caution
        default: return .avoid
        }
    }

    enum EnergyLevel: String {
        case excellent = "Highly Auspicious"
        case good = "Generally Favorable"
        case neutral = "Mixed Energy"
        case caution = "Exercise Caution"
        case avoid = "Less Favorable"

        var color: Color {
            switch self {
            case .excellent: return .muhurtaExcellent
            case .good: return .muhurtaGood
            case .neutral: return .muhurtaNeutral
            case .caution: return .muhurtaCaution
            case .avoid: return .muhurtaAvoid
            }
        }

        var icon: String {
            switch self {
            case .excellent: return "star.fill"
            case .good: return "hand.thumbsup.fill"
            case .neutral: return "equal.circle.fill"
            case .caution: return "exclamationmark.triangle.fill"
            case .avoid: return "xmark.circle.fill"
            }
        }
    }

    // MARK: - Time-based Methods

    /// Get the muhurta type for a specific hour
    func muhurtaAt(hour: Int) -> Muhurta? {
        let calendar = Calendar.current
        let testDate = calendar.date(bySettingHour: hour, minute: 30, second: 0, of: date) ?? date

        // Check inauspicious periods first
        if rahuKalam.contains(testDate) {
            return Muhurta(
                id: UUID(),
                name: "Rahu Kalam",
                timeRange: rahuKalam,
                type: .rahuKalam,
                auspiciousnessScore: 1
            )
        }

        if yamaganda.contains(testDate) {
            return Muhurta(
                id: UUID(),
                name: "Yamaganda",
                timeRange: yamaganda,
                type: .yamaganda,
                auspiciousnessScore: 2
            )
        }

        if gulikaKalam.contains(testDate) {
            return Muhurta(
                id: UUID(),
                name: "Gulika Kalam",
                timeRange: gulikaKalam,
                type: .gulikaKalam,
                auspiciousnessScore: 2
            )
        }

        // Check auspicious periods
        if let amrit = amritKalam, amrit.contains(testDate) {
            return Muhurta(
                id: UUID(),
                name: "Amrit Kalam",
                timeRange: amrit,
                type: .amritKalam,
                auspiciousnessScore: 10
            )
        }

        if let abhijit = abhijitMuhurta, abhijit.contains(testDate) {
            return Muhurta(
                id: UUID(),
                name: "Abhijit Muhurta",
                timeRange: abhijit,
                type: .abhijitMuhurta,
                auspiciousnessScore: 9
            )
        }

        // Check varjyam
        for varjyamPeriod in varjyam {
            if varjyamPeriod.contains(testDate) {
                return Muhurta(
                    id: UUID(),
                    name: "Varjyam",
                    timeRange: varjyamPeriod,
                    type: .varjyam,
                    auspiciousnessScore: 1
                )
            }
        }

        // Default regular muhurta
        let hourRange = TimeRange.today(startHour: hour, endHour: hour + 1)
        return Muhurta(
            id: UUID(),
            name: "Regular",
            timeRange: hourRange,
            type: .regular,
            auspiciousnessScore: calculateHourScore(hour: hour)
        )
    }

    /// Calculate score for a regular hour based on tithi, nakshatra, etc.
    private func calculateHourScore(hour: Int) -> Double {
        var score: Double = 5.0  // Base neutral score

        // Adjust based on tithi
        if tithi.isAuspicious { score += 1.0 }
        if tithi.isInauspicious { score -= 1.5 }

        // Adjust based on nakshatra
        if nakshatra.isFavorable { score += 1.0 }

        // Adjust based on yoga
        if yoga.isAuspicious { score += 0.5 }
        if yoga.isInauspicious { score -= 1.0 }

        // Adjust based on karana
        if karana.isBhadra { score -= 1.0 }

        return min(10, max(0, score))
    }

    /// Get current muhurta based on current time
    func currentMuhurta(at time: Date = Date()) -> Muhurta? {
        let hour = Calendar.current.component(.hour, from: time)
        return muhurtaAt(hour: hour)
    }

    /// Get all favorable windows for the day
    func favorableWindows() -> [MuhurtaWindow] {
        var windows: [MuhurtaWindow] = []

        // Add Amrit Kalam if present
        if let amrit = amritKalam {
            windows.append(MuhurtaWindow(
                id: UUID(),
                date: date,
                timeRange: amrit,
                score: 10,
                reasons: ["Amrit Kalam - highly auspicious"]
            ))
        }

        // Add Abhijit Muhurta if present
        if let abhijit = abhijitMuhurta {
            windows.append(MuhurtaWindow(
                id: UUID(),
                date: date,
                timeRange: abhijit,
                score: 9,
                reasons: ["Abhijit Muhurta - victory time"]
            ))
        }

        return windows.sorted { $0.score > $1.score }
    }
}

// MARK: - Equatable Conformance
extension Panchanga {
    static func == (lhs: Panchanga, rhs: Panchanga) -> Bool {
        lhs.id == rhs.id
    }
}
