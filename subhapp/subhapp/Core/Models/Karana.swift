//
//  Karana.swift
//  subhapp
//
//  Core Model - Karana (Half of a Tithi)
//

import Foundation

struct Karana: Codable, Equatable {
    let name: String
    let teluguName: String
    let number: Int          // 1-11 (7 movable repeat, 4 fixed occur once per month)
    let endTime: Date

    /// Is this a movable (repeating) karana?
    var isMovable: Bool {
        // Bava, Balava, Kaulava, Taitila, Garija, Vanija, Vishti repeat
        number <= 7
    }

    /// Is this karana favorable?
    var isFavorable: Bool {
        // Vishti (Bhadra) is generally unfavorable
        // Fixed karanas are neutral to unfavorable
        let unfavorable = ["Vishti", "Shakuni", "Chatushpada", "Nagava", "Kimstughna"]
        return !unfavorable.contains(name)
    }

    /// Is this Bhadra/Vishti karana (to be avoided)?
    var isBhadra: Bool {
        name == "Vishti"
    }
}

// MARK: - All Karanas Reference
extension Karana {
    // 7 Movable Karanas (repeat 8 times in a lunar month = 56)
    // 4 Fixed Karanas (occur once each = 4)
    // Total = 60 half-tithis in a lunar month (30 tithis × 2)

    static let movable: [(name: String, telugu: String)] = [
        ("Bava", "బవ"),
        ("Balava", "బాలవ"),
        ("Kaulava", "కౌలవ"),
        ("Taitila", "తైతిల"),
        ("Garija", "గరజ"),
        ("Vanija", "వణిజ"),
        ("Vishti", "విష్టి")      // Also called Bhadra - inauspicious
    ]

    static let fixed: [(name: String, telugu: String)] = [
        ("Shakuni", "శకుని"),
        ("Chatushpada", "చతుష్పాద"),
        ("Nagava", "నాగవ"),
        ("Kimstughna", "కింస్తుఘ్న")
    ]
}
