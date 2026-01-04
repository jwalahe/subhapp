//
//  Nakshatra.swift
//  subhapp
//
//  Core Model - Lunar mansion (Nakshatra)
//

import Foundation

struct Nakshatra: Codable, Equatable {
    let name: String
    let teluguName: String
    let number: Int          // 1-27
    let endTime: Date
    let deity: String
    let rulingPlanet: String

    /// Is this nakshatra generally favorable for activities?
    var isFavorable: Bool {
        // Fixed/Sthira nakshatras are good for permanent work
        // Movable/Chara nakshatras are good for travel
        // Most nakshatras have specific favorable activities
        let generallyFavorable = [
            "Ashwini", "Rohini", "Mrigashira", "Pushya", "Hasta",
            "Chitra", "Swati", "Anuradha", "Shravana", "Dhanishta", "Revati"
        ]
        return generallyFavorable.contains(name)
    }

    /// Category of the nakshatra
    var category: NakshatraCategory {
        switch number {
        case 1, 5, 7, 8, 13, 15, 17, 22, 27:
            return .movable  // Chara - good for travel, change
        case 2, 10, 11, 12, 20, 25:
            return .fixed    // Sthira - good for permanent things
        case 3, 6, 9, 14, 18, 23:
            return .soft     // Mridu - good for art, romance
        case 4, 16, 21, 24:
            return .sharp    // Tikshna - good for competition
        default:
            return .mixed    // Mishra - mixed results
        }
    }

    enum NakshatraCategory: String {
        case movable = "Movable"
        case fixed = "Fixed"
        case soft = "Soft"
        case sharp = "Sharp"
        case mixed = "Mixed"
    }
}

// MARK: - All 27 Nakshatras Reference
extension Nakshatra {
    static let all: [(name: String, telugu: String, deity: String, planet: String)] = [
        ("Ashwini", "అశ్విని", "Ashwini Kumaras", "Ketu"),
        ("Bharani", "భరణి", "Yama", "Venus"),
        ("Krittika", "కృత్తిక", "Agni", "Sun"),
        ("Rohini", "రోహిణి", "Brahma", "Moon"),
        ("Mrigashira", "మృగశిర", "Soma", "Mars"),
        ("Ardra", "ఆర్ద్ర", "Rudra", "Rahu"),
        ("Punarvasu", "పునర్వసు", "Aditi", "Jupiter"),
        ("Pushya", "పుష్యమి", "Brihaspati", "Saturn"),
        ("Ashlesha", "ఆశ్లేష", "Nagas", "Mercury"),
        ("Magha", "మఖ", "Pitris", "Ketu"),
        ("Purva Phalguni", "పూర్వ ఫల్గుణి", "Bhaga", "Venus"),
        ("Uttara Phalguni", "ఉత్తర ఫల్గుణి", "Aryaman", "Sun"),
        ("Hasta", "హస్త", "Savitar", "Moon"),
        ("Chitra", "చిత్త", "Vishwakarma", "Mars"),
        ("Swati", "స్వాతి", "Vayu", "Rahu"),
        ("Vishakha", "విశాఖ", "Indra-Agni", "Jupiter"),
        ("Anuradha", "అనూరాధ", "Mitra", "Saturn"),
        ("Jyeshtha", "జ్యేష్ఠ", "Indra", "Mercury"),
        ("Mula", "మూల", "Nirriti", "Ketu"),
        ("Purva Ashadha", "పూర్వాషాఢ", "Apas", "Venus"),
        ("Uttara Ashadha", "ఉత్తరాషాఢ", "Vishvadevas", "Sun"),
        ("Shravana", "శ్రవణం", "Vishnu", "Moon"),
        ("Dhanishta", "ధనిష్ఠ", "Vasus", "Mars"),
        ("Shatabhisha", "శతభిషం", "Varuna", "Rahu"),
        ("Purva Bhadrapada", "పూర్వాభాద్ర", "Aja Ekapada", "Jupiter"),
        ("Uttara Bhadrapada", "ఉత్తరాభాద్ర", "Ahir Budhnya", "Saturn"),
        ("Revati", "రేవతి", "Pushan", "Mercury")
    ]
}
