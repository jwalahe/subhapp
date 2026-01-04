//
//  NotificationPermissionView.swift
//  subhapp
//
//  Onboarding Page 4 - Notification permission with value proposition
//

import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    let onContinue: () -> Void

    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    @State private var isRequesting = false

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Icon with bell
            ZStack {
                Circle()
                    .fill(Color.shubhGold.opacity(0.15))
                    .frame(width: 120, height: 120)

                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.shubhGold)
            }

            VStack(spacing: Spacing.md) {
                Text("Never Miss an\nAuspicious Moment")
                    .font(.shubhTitle1)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Get timely reminders about favorable muhurtas and daily panchanga summaries.")
                    .font(.shubhBody)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, Spacing.md)
            }

            Spacer()

            // Notification examples
            VStack(spacing: Spacing.md) {
                NotificationPreview(
                    icon: "sunrise.fill",
                    title: "Good Morning",
                    message: "Today is Shukla Panchami. Favorable for new beginnings.",
                    time: "7:00 AM"
                )

                NotificationPreview(
                    icon: "sparkles",
                    title: "Amrit Kalam Starting",
                    message: "Auspicious window for 90 minutes",
                    time: "10:30 AM"
                )
            }
            .padding(.horizontal, Spacing.lg)

            Spacer()

            // Permission buttons
            VStack(spacing: Spacing.sm) {
                if notificationStatus == .authorized {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.muhurtaExcellent)
                        Text("Notifications enabled")
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.muhurtaExcellent)
                    }
                    .padding(.bottom, Spacing.sm)

                    ShubhButton(title: "Continue") {
                        onContinue()
                    }
                } else {
                    ShubhButton(title: "Enable Notifications") {
                        requestNotificationPermission()
                    }
                    .disabled(isRequesting)

                    Button {
                        onContinue()
                    } label: {
                        Text("Maybe later")
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.textTertiary)
                    }
                    .padding(.top, Spacing.xs)
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
        .onAppear {
            checkNotificationStatus()
        }
    }

    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationStatus = settings.authorizationStatus
            }
        }
    }

    private func requestNotificationPermission() {
        isRequesting = true

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                isRequesting = false
                checkNotificationStatus()

                if granted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onContinue()
                    }
                }
            }
        }
    }
}

// MARK: - Notification Preview Component
struct NotificationPreview: View {
    let icon: String
    let title: String
    let message: String
    let time: String

    var body: some View {
        HStack(spacing: Spacing.sm) {
            // App icon placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [Color.shubhSaffron, Color.shubhGold],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(Color.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("SHUBH")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.textTertiary)

                    Spacer()

                    Text(time)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textTertiary)
                }

                Text(title)
                    .font(.shubhSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                Text(message)
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
        }
        .padding(Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.surfaceElevated)
        )
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.shubhDeepPurple, Color.surfacePrimary],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        NotificationPermissionView(onContinue: {})
    }
}
