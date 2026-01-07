//
//  NotificationService.swift
//  subhapp
//
//  Notification service for morning summaries and muhurta alerts
//

import Foundation
import UserNotifications
import SwiftUI

@Observable
class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()
    private let panchangaService = MockPanchangaService.shared

    var isAuthorized = false
    var morningNotificationTime: DateComponents = {
        var components = DateComponents()
        components.hour = 6
        components.minute = 0
        return components
    }()

    init() {
        Task {
            await checkAuthorizationStatus()
        }
    }

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run {
                self.isAuthorized = granted
            }
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func checkAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        await MainActor.run {
            self.isAuthorized = settings.authorizationStatus == .authorized
        }
    }

    // MARK: - Morning Summary

    func scheduleMorningSummary() async {
        guard isAuthorized else { return }

        // Remove existing morning notifications
        center.removePendingNotificationRequests(withIdentifiers: ["morning-summary"])

        let content = UNMutableNotificationContent()
        content.title = "🕉️ Good Morning"
        content.categoryIdentifier = "MORNING_SUMMARY"
        content.sound = .default

        // Get today's panchanga
        let panchanga = panchangaService.getPanchanga(for: Date())

        content.body = buildMorningSummaryBody(panchanga: panchanga)

        // Schedule for every morning
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: morningNotificationTime,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "morning-summary",
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
        } catch {
            print("Failed to schedule morning summary: \(error)")
        }
    }

    private func buildMorningSummaryBody(panchanga: Panchanga) -> String {
        var body = "\(panchanga.tithi.name) • \(panchanga.nakshatra.name)"

        if panchanga.overallAuspiciousnessScore >= 8 {
            body += "\n✨ Highly auspicious day!"
        } else if panchanga.overallAuspiciousnessScore >= 6 {
            body += "\n✅ Good day for activities"
        }

        body += "\n⚠️ Rahu Kalam: \(panchanga.rahuKalam.formatted)"

        return body
    }

    // MARK: - Muhurta Alerts

    func scheduleMuhurtaAlert(
        for muhurta: Muhurta,
        date: Date,
        activityName: String?
    ) async {
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        content.sound = .default

        if muhurta.type.isAuspicious {
            content.title = "✨ Auspicious Time Starting"
            if let activity = activityName {
                content.body = "Good time for \(activity). \(muhurta.name) begins now."
            } else {
                content.body = "\(muhurta.name) is starting - favorable for important activities."
            }
        } else {
            content.title = "⚠️ \(muhurta.name) Starting"
            content.body = "Avoid starting important activities during this period."
        }

        // Schedule 5 minutes before
        let alertTime = muhurta.timeRange.start.addingTimeInterval(-5 * 60)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertTime)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: "muhurta-\(muhurta.id.uuidString)",
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
        } catch {
            print("Failed to schedule muhurta alert: \(error)")
        }
    }

    // MARK: - Rahu Kalam Alert

    func scheduleRahuKalamAlert(for date: Date) async {
        guard isAuthorized else { return }

        let panchanga = panchangaService.getPanchanga(for: date)

        let content = UNMutableNotificationContent()
        content.title = "⚠️ Rahu Kalam Starting Soon"
        content.body = "Avoid starting new ventures. Rahu Kalam: \(panchanga.rahuKalam.formatted)"
        content.sound = .default

        // Alert 10 minutes before Rahu Kalam
        let alertTime = panchanga.rahuKalam.start.addingTimeInterval(-10 * 60)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertTime)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: "rahu-kalam-\(date.formatted(.dateTime.year().month().day()))",
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
        } catch {
            print("Failed to schedule Rahu Kalam alert: \(error)")
        }
    }

    // MARK: - Cancel Notifications

    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    func cancelNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // MARK: - Update Morning Time

    func updateMorningNotificationTime(hour: Int, minute: Int) async {
        morningNotificationTime.hour = hour
        morningNotificationTime.minute = minute
        await scheduleMorningSummary()
    }
}

// MARK: - Notification Settings View Model
@Observable
class NotificationSettingsViewModel {
    var isMorningSummaryEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isMorningSummaryEnabled, forKey: "morning_summary_enabled")
            Task {
                if isMorningSummaryEnabled {
                    await NotificationService.shared.scheduleMorningSummary()
                } else {
                    NotificationService.shared.cancelNotification(identifier: "morning-summary")
                }
            }
        }
    }

    var isRahuKalamAlertEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isRahuKalamAlertEnabled, forKey: "rahu_kalam_alert_enabled")
        }
    }

    var morningNotificationHour: Int {
        didSet {
            UserDefaults.standard.set(morningNotificationHour, forKey: "morning_notification_hour")
            Task {
                await NotificationService.shared.updateMorningNotificationTime(
                    hour: morningNotificationHour,
                    minute: morningNotificationMinute
                )
            }
        }
    }

    var morningNotificationMinute: Int {
        didSet {
            UserDefaults.standard.set(morningNotificationMinute, forKey: "morning_notification_minute")
            Task {
                await NotificationService.shared.updateMorningNotificationTime(
                    hour: morningNotificationHour,
                    minute: morningNotificationMinute
                )
            }
        }
    }

    init() {
        self.isMorningSummaryEnabled = UserDefaults.standard.bool(forKey: "morning_summary_enabled")
        self.isRahuKalamAlertEnabled = UserDefaults.standard.bool(forKey: "rahu_kalam_alert_enabled")
        self.morningNotificationHour = UserDefaults.standard.object(forKey: "morning_notification_hour") as? Int ?? 6
        self.morningNotificationMinute = UserDefaults.standard.object(forKey: "morning_notification_minute") as? Int ?? 0
    }

    var morningTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        var components = DateComponents()
        components.hour = morningNotificationHour
        components.minute = morningNotificationMinute

        if let date = Calendar.current.date(from: components) {
            return formatter.string(from: date)
        }
        return "6:00 AM"
    }
}
