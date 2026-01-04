//
//  Tithi.swift
//  subhapp
//
//  Core Model - Lunar day (Tithi)
//

import Foundation

struct Tithi: Codable, Equatable {
    let name: String
    let teluguName: String
    let number: Int          // 1-30 (1-15 Shukla, 16-30 Krishna mapped as 1-15)
    let endTime: Date
    let paksha: Paksha

    enum Paksha: String, Codable {
        case shukla = "Shukla"   // Bright half (waxing moon)
        case krishna = "Krishna" // Dark half (waning moon)

        var teluguName: String {
            switch self {
            case .shukla: return "శుక్ల"
            case .krishna: return "కృష్ణ"
            }
        }
    }

    /// Full name with paksha: "Shukla Panchami"
    var fullName: String {
        "\(paksha.rawValue) \(name)"
    }

    /// Is this a special/auspicious tithi?
    var isAuspicious: Bool {
        // Panchami (5), Dashami (10), Purnima (15), Ekadashi (11) are generally auspicious
        let auspiciousTithis = [5, 10, 11, 15]
        return auspiciousTithis.contains(number)
    }

    /// Is this an inauspicious tithi?
    var isInauspicious: Bool {
        // Rikta tithis (4, 9, 14) and Amavasya (30) are generally avoided
        let riktaTithis = [4, 9, 14, 30]
        return riktaTithis.contains(number)
    }
}

// MARK: - All Tithis Reference
extension Tithi {
    static let names: [(english: String, telugu: String)] = [
        ("Prathama", "పాడ్యమి"),
        ("Dwitiya", "విదియ"),
        ("Tritiya", "తదియ"),
        ("Chaturthi", "చవితి"),
        ("Panchami", "పంచమి"),
        ("Shashthi", "షష్ఠి"),
        ("Saptami", "సప్తమి"),
        ("Ashtami", "అష్టమి"),
        ("Navami", "నవమి"),
        ("Dashami", "దశమి"),
        ("Ekadashi", "ఏకాదశి"),
        ("Dwadashi", "ద్వాదశి"),
        ("Trayodashi", "త్రయోదశి"),
        ("Chaturdashi", "చతుర్దశి"),
        ("Purnima", "పౌర్ణమి"),      // Full moon (end of Shukla)
        ("Amavasya", "అమావాస్య")     // New moon (end of Krishna, number 30)
    ]
}
