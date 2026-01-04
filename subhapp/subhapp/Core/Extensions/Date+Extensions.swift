//
//  Date+Extensions.swift
//  subhapp
//
//  Date utility extensions
//

import Foundation

extension Date {
    /// Start of the current day (midnight)
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// End of the current day (23:59:59)
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }

    /// Get the next month from this date
    var nextMonth: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: self) ?? self
    }

    /// Get the previous month from this date
    var previousMonth: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: self) ?? self
    }

    /// Check if this date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Get hour component
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }

    /// Get day component
    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    /// Get month component
    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    /// Get year component
    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    /// Formatted as "January 15, 2026"
    var formattedLong: String {
        formatted(.dateTime.month(.wide).day().year())
    }

    /// Formatted as "Jan 15"
    var formattedShort: String {
        formatted(.dateTime.month(.abbreviated).day())
    }

    /// Formatted as "Saturday"
    var weekdayName: String {
        formatted(.dateTime.weekday(.wide))
    }
}
