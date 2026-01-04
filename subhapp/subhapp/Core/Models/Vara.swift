//
//  Vara.swift
//  subhapp
//
//  Core Model - Day of the week (Vara)
//

import Foundation

enum Vara: Int, Codable, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var name: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }

    var teluguName: String {
        switch self {
        case .sunday: return "ఆదివారం"
        case .monday: return "సోమవారం"
        case .tuesday: return "మంగళవారం"
        case .wednesday: return "బుధవారం"
        case .thursday: return "గురువారం"
        case .friday: return "శుక్రవారం"
        case .saturday: return "శనివారం"
        }
    }

    var shortName: String {
        String(name.prefix(3))
    }

    var rulingPlanet: String {
        switch self {
        case .sunday: return "Sun"
        case .monday: return "Moon"
        case .tuesday: return "Mars"
        case .wednesday: return "Mercury"
        case .thursday: return "Jupiter"
        case .friday: return "Venus"
        case .saturday: return "Saturn"
        }
    }

    /// Get Vara from a Date
    static func from(date: Date) -> Vara {
        let weekday = Calendar.current.component(.weekday, from: date)
        return Vara(rawValue: weekday) ?? .sunday
    }

    /// Generally favorable activities for this day
    var favorableFor: [String] {
        switch self {
        case .sunday:
            return ["Government work", "Leadership", "Authority matters"]
        case .monday:
            return ["Travel", "New beginnings", "Creative work", "Meeting people"]
        case .tuesday:
            return ["Property", "Machinery", "Surgery", "Competition"]
        case .wednesday:
            return ["Education", "Communication", "Business", "Writing"]
        case .thursday:
            return ["Religious activities", "Learning", "Marriage", "Investments"]
        case .friday:
            return ["Marriage", "Art", "Entertainment", "Luxury purchases"]
        case .saturday:
            return ["Iron/oil business", "Agriculture", "Service work"]
        }
    }
}
