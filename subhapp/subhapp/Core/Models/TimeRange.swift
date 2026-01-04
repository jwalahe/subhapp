//
//  TimeRange.swift
//  subhapp
//
//  Core Model - Time range for muhurta windows
//

import Foundation

struct TimeRange: Codable, Equatable, Identifiable {
    var id: String { "\(start.timeIntervalSince1970)-\(end.timeIntervalSince1970)" }

    let start: Date
    let end: Date

    /// Formatted as "10:30 AM - 12:00 PM"
    var formatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }

    /// Formatted start time only "10:30 AM"
    var startFormatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: start)
    }

    /// Formatted end time only "12:00 PM"
    var endFormatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: end)
    }

    /// Check if a given date falls within this range
    func contains(_ date: Date) -> Bool {
        return date >= start && date <= end
    }

    /// Duration in minutes
    var durationMinutes: Int {
        Int(end.timeIntervalSince(start) / 60)
    }

    /// Duration formatted as "1h 30m"
    var durationFormatted: String {
        let minutes = durationMinutes
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        if hours > 0 && remainingMinutes > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(remainingMinutes)m"
        }
    }
}

// MARK: - Convenience Initializers
extension TimeRange {
    /// Create a time range for today with given hours
    static func today(startHour: Int, startMinute: Int = 0, endHour: Int, endMinute: Int = 0) -> TimeRange {
        let calendar = Calendar.current
        let now = Date()

        let start = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: now) ?? now
        let end = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: now) ?? now

        return TimeRange(start: start, end: end)
    }
}
