//
//  CalendarService.swift
//  subhapp
//
//  EventKit integration for Apple Calendar
//

import EventKit
import SwiftUI

@Observable
class CalendarService {
    static let shared = CalendarService()

    private let eventStore = EKEventStore()

    var authorizationStatus: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    var isAuthorized: Bool {
        authorizationStatus == .fullAccess
    }

    // MARK: - Request Access

    func requestAccess() async -> Bool {
        do {
            return try await eventStore.requestFullAccessToEvents()
        } catch {
            print("Calendar access error: \(error)")
            return false
        }
    }

    // MARK: - Create Event from Search Result

    func addMuhurtaToCalendar(
        date: Date,
        activity: Activity?,
        panchanga: Panchanga,
        score: Double
    ) async throws -> Bool {
        if !isAuthorized {
            let granted = await requestAccess()
            guard granted else {
                throw CalendarError.accessDenied
            }
        }

        let event = EKEvent(eventStore: eventStore)

        // Title
        if let activity = activity {
            event.title = "🕉️ \(activity.displayName) - Auspicious Time"
        } else {
            event.title = "🕉️ Auspicious Muhurta"
        }

        // All-day event on the selected date
        event.isAllDay = true
        event.startDate = Calendar.current.startOfDay(for: date)
        event.endDate = Calendar.current.startOfDay(for: date)

        // Notes with panchanga details
        event.notes = buildEventNotes(
            panchanga: panchanga,
            score: score,
            activity: activity
        )

        // Add alert
        event.addAlarm(EKAlarm(relativeOffset: -3600 * 8)) // 8 hours before (morning of)

        // Use default calendar
        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            return true
        } catch {
            throw CalendarError.saveFailed(error)
        }
    }

    // MARK: - Create Event for Muhurta Window

    func addMuhurtaWindowToCalendar(
        muhurta: Muhurta,
        date: Date
    ) async throws -> Bool {
        if !isAuthorized {
            let granted = await requestAccess()
            guard granted else {
                throw CalendarError.accessDenied
            }
        }

        let event = EKEvent(eventStore: eventStore)

        // Title based on type
        let emoji = muhurtaEmoji(for: muhurta.type)
        event.title = "\(emoji) \(muhurta.type.rawValue.capitalized)"

        // Set start and end times
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)

        event.startDate = calendar.date(
            byAdding: .second,
            value: Int(muhurta.timeRange.start.timeIntervalSince(startOfDay)),
            to: startOfDay
        ) ?? muhurta.timeRange.start

        event.endDate = calendar.date(
            byAdding: .second,
            value: Int(muhurta.timeRange.end.timeIntervalSince(startOfDay)),
            to: startOfDay
        ) ?? muhurta.timeRange.end

        // Notes
        if muhurta.type.isAuspicious {
            event.notes = "✨ Auspicious time window - Good for important activities\n\nAdded via Shubh App"
        } else {
            event.notes = "⚠️ Inauspicious period - Avoid important activities\n\nAdded via Shubh App"
        }

        // Add alert 15 min before
        event.addAlarm(EKAlarm(relativeOffset: -900))

        event.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(event, span: .thisEvent)
            return true
        } catch {
            throw CalendarError.saveFailed(error)
        }
    }

    // MARK: - Helpers

    private func buildEventNotes(panchanga: Panchanga, score: Double, activity: Activity?) -> String {
        var notes = """
        ✨ Auspiciousness Score: \(String(format: "%.1f", score))/10

        📅 Panchanga Details:
        • Tithi: \(panchanga.tithi.fullName)
        • Nakshatra: \(panchanga.nakshatra.name)
        • Yoga: \(panchanga.yoga.name)
        • Karana: \(panchanga.karana.name)

        ⏰ Timings:
        • Rahu Kalam: \(panchanga.rahuKalam.formatted)
        """

        if let amrit = panchanga.amritKalam {
            notes += "\n• Amrit Kalam: \(amrit.formatted)"
        }

        if let activity = activity {
            notes += "\n\n🎯 Activity: \(activity.displayName)"
        }

        notes += "\n\n🕉️ Added via Shubh App"

        return notes
    }

    private func muhurtaEmoji(for type: Muhurta.MuhurtaType) -> String {
        switch type {
        case .amritKalam: return "✨"
        case .abhijitMuhurta: return "☀️"
        case .rahuKalam: return "⚠️"
        case .yamaganda: return "⛔"
        case .gulikaKalam: return "🚫"
        case .varjyam: return "🚷"
        case .durMuhurtam: return "⏸️"
        case .regular: return "🕐"
        }
    }
}

// MARK: - Errors

enum CalendarError: LocalizedError {
    case accessDenied
    case saveFailed(Error)

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Calendar access was denied. Please enable in Settings."
        case .saveFailed(let error):
            return "Failed to save event: \(error.localizedDescription)"
        }
    }
}
