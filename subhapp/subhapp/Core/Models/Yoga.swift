//
//  Yoga.swift
//  subhapp
//
//  Core Model - Yoga (Sun-Moon combination)
//

import Foundation

struct Yoga: Codable, Equatable {
    let name: String
    let teluguName: String
    let number: Int          // 1-27
    let endTime: Date

    /// Is this yoga auspicious?
    var isAuspicious: Bool {
        // Generally auspicious yogas
        let auspiciousYogas = [
            "Siddha", "Amrita", "Shubha", "Shukla", "Brahma",
            "Indra", "Priti", "Ayushman", "Saubhagya", "Sobhana",
            "Sukarma", "Dhriti", "Shiva", "Sadhya", "Variyan"
        ]
        return auspiciousYogas.contains(name)
    }

    /// Is this yoga inauspicious?
    var isInauspicious: Bool {
        // Generally inauspicious yogas
        let inauspiciousYogas = [
            "Vishkumbha", "Atiganda", "Shoola", "Ganda",
            "Vyaghata", "Vajra", "Vyatipata", "Parigha", "Vaidhriti"
        ]
        return inauspiciousYogas.contains(name)
    }
}

// MARK: - All 27 Yogas Reference
extension Yoga {
    static let all: [(name: String, telugu: String, isAuspicious: Bool)] = [
        ("Vishkumbha", "విష్కుంభ", false),
        ("Priti", "ప్రీతి", true),
        ("Ayushman", "ఆయుష్మాన్", true),
        ("Saubhagya", "సౌభాగ్య", true),
        ("Sobhana", "శోభన", true),
        ("Atiganda", "అతిగండ", false),
        ("Sukarma", "సుకర్మ", true),
        ("Dhriti", "ధృతి", true),
        ("Shoola", "శూల", false),
        ("Ganda", "గండ", false),
        ("Vriddhi", "వృద్ధి", true),
        ("Dhruva", "ధ్రువ", true),
        ("Vyaghata", "వ్యాఘాత", false),
        ("Harshana", "హర్షణ", true),
        ("Vajra", "వజ్ర", false),
        ("Siddhi", "సిద్ధి", true),
        ("Vyatipata", "వ్యతీపాత", false),
        ("Variyan", "వరీయాన్", true),
        ("Parigha", "పరిఘ", false),
        ("Shiva", "శివ", true),
        ("Siddha", "సిద్ధ", true),
        ("Sadhya", "సాధ్య", true),
        ("Shubha", "శుభ", true),
        ("Shukla", "శుక్ల", true),
        ("Brahma", "బ్రహ్మ", true),
        ("Indra", "ఇంద్ర", true),
        ("Vaidhriti", "వైధృతి", false)
    ]
}
