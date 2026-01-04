//
//  Activity.swift
//  subhapp
//
//  Core Model - Activity types for muhurta search
//

import Foundation

struct Activity: Identifiable, Equatable, Hashable {
    let id: String
    let displayName: String
    let emoji: String
    let keywords: [String]
    let favorableConditions: MuhurtaConditions

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Activity, rhs: Activity) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Muhurta Conditions
struct MuhurtaConditions: Equatable {
    let avoidRahuKalam: Bool
    let requireAmritKalam: Bool
    let preferredTithis: [Int]           // Tithi numbers 1-15
    let preferredNakshatras: [String]    // Nakshatra names
    let avoidTithis: [Int]               // Rikta tithis, Amavasya, etc.
    let preferredVaras: [Vara]           // Preferred days of week

    // MARK: - Preset Conditions

    static let forTravel = MuhurtaConditions(
        avoidRahuKalam: true,
        requireAmritKalam: false,
        preferredTithis: [2, 3, 5, 7, 10, 11, 13],
        preferredNakshatras: ["Ashwini", "Mrigashira", "Pushya", "Hasta", "Anuradha", "Revati"],
        avoidTithis: [4, 9, 14, 30],
        preferredVaras: [.monday, .wednesday, .thursday, .friday]
    )

    static let forVehicle = MuhurtaConditions(
        avoidRahuKalam: true,
        requireAmritKalam: false,
        preferredTithis: [2, 3, 5, 7, 10, 11, 12, 13],
        preferredNakshatras: ["Ashwini", "Rohini", "Pushya", "Hasta", "Swati", "Anuradha", "Revati"],
        avoidTithis: [4, 8, 9, 14, 30],
        preferredVaras: [.wednesday, .thursday, .friday]
    )

    static let forPurchase = MuhurtaConditions(
        avoidRahuKalam: true,
        requireAmritKalam: false,
        preferredTithis: [2, 3, 5, 7, 10, 11, 13, 15],
        preferredNakshatras: ["Rohini", "Mrigashira", "Pushya", "Hasta", "Chitra", "Swati", "Anuradha", "Shravana", "Revati"],
        avoidTithis: [4, 9, 14, 30],
        preferredVaras: [.monday, .wednesday, .thursday, .friday]
    )

    static let forMeeting = MuhurtaConditions(
        avoidRahuKalam: true,
        requireAmritKalam: false,
        preferredTithis: [2, 3, 5, 7, 10, 11, 13],
        preferredNakshatras: ["Ashwini", "Rohini", "Mrigashira", "Pushya", "Hasta", "Swati", "Anuradha", "Shravana"],
        avoidTithis: [4, 9, 14],
        preferredVaras: [.monday, .wednesday, .thursday, .friday]
    )

    static let forSigning = MuhurtaConditions(
        avoidRahuKalam: true,
        requireAmritKalam: false,
        preferredTithis: [2, 3, 5, 7, 10, 11, 13],
        preferredNakshatras: ["Ashwini", "Rohini", "Mrigashira", "Pushya", "Hasta", "Anuradha", "Uttara Phalguni", "Uttara Ashadha", "Uttara Bhadrapada"],
        avoidTithis: [4, 8, 9, 14, 30],
        preferredVaras: [.monday, .wednesday, .thursday, .friday]
    )

    static let forGrihaPravesh = MuhurtaConditions(
        avoidRahuKalam: true,
        requireAmritKalam: true,
        preferredTithis: [2, 3, 5, 7, 10, 11, 12, 13, 15],
        preferredNakshatras: ["Rohini", "Mrigashira", "Uttara Phalguni", "Hasta", "Chitra", "Swati", "Anuradha", "Uttara Ashadha", "Shravana", "Dhanishta", "Uttara Bhadrapada", "Revati"],
        avoidTithis: [4, 6, 8, 9, 14, 30],
        preferredVaras: [.monday, .wednesday, .thursday, .friday]
    )

    static let general = MuhurtaConditions(
        avoidRahuKalam: true,
        requireAmritKalam: false,
        preferredTithis: [2, 3, 5, 7, 10, 11, 13],
        preferredNakshatras: [],
        avoidTithis: [4, 9, 14],
        preferredVaras: []
    )
}

// MARK: - Popular Activities
extension Activity {
    static let popular: [Activity] = [
        Activity(
            id: "travel",
            displayName: "Travel",
            emoji: "✈️",
            keywords: ["journey", "trip", "flight", "vacation"],
            favorableConditions: .forTravel
        ),
        Activity(
            id: "purchase_vehicle",
            displayName: "Vehicle Purchase",
            emoji: "🚗",
            keywords: ["car", "bike", "vehicle", "automobile"],
            favorableConditions: .forVehicle
        ),
        Activity(
            id: "major_purchase",
            displayName: "Major Purchase",
            emoji: "🛒",
            keywords: ["buy", "purchase", "shopping", "invest"],
            favorableConditions: .forPurchase
        ),
        Activity(
            id: "meeting",
            displayName: "Important Meeting",
            emoji: "💼",
            keywords: ["meeting", "interview", "presentation", "negotiation"],
            favorableConditions: .forMeeting
        ),
        Activity(
            id: "signing",
            displayName: "Sign Documents",
            emoji: "📝",
            keywords: ["contract", "agreement", "signing", "legal"],
            favorableConditions: .forSigning
        ),
        Activity(
            id: "moving",
            displayName: "Griha Pravesh",
            emoji: "🏠",
            keywords: ["house", "moving", "griha pravesh", "housewarming"],
            favorableConditions: .forGrihaPravesh
        )
    ]

    static func find(by id: String) -> Activity? {
        popular.first { $0.id == id }
    }

    static func search(query: String) -> [Activity] {
        let lowercasedQuery = query.lowercased()
        return popular.filter { activity in
            activity.displayName.lowercased().contains(lowercasedQuery) ||
            activity.keywords.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
}
