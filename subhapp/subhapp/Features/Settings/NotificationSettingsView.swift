//
//  NotificationSettingsView.swift
//  subhapp
//
//  Settings - Notification preferences
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var viewModel = NotificationSettingsViewModel()
    @State private var showTimePicker = false
    @State private var showPermissionAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Permission status
                if !NotificationService.shared.isAuthorized {
                    permissionCard
                }

                // Morning Summary
                morningSummarySection

                // Rahu Kalam Alerts
                rahuKalamSection

                // Info
                infoSection
            }
            .padding(.horizontal)
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.xl)
        }
        .background(Color.surfacePrimary)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Enable Notifications", isPresented: $showPermissionAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable notifications in Settings to receive daily panchanga summaries and muhurta alerts.")
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerSheet(
                hour: $viewModel.morningNotificationHour,
                minute: $viewModel.morningNotificationMinute
            )
        }
    }

    // MARK: - Permission Card

    private var permissionCard: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.shubhSaffron)

            Text("Notifications Disabled")
                .font(.shubhHeadline)
                .foregroundStyle(Color.textPrimary)

            Text("Enable notifications to receive daily panchanga summaries and muhurta alerts.")
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            ShubhButton(title: "Enable Notifications", action: {
                Task {
                    let granted = await NotificationService.shared.requestAuthorization()
                    if !granted {
                        showPermissionAlert = true
                    }
                }
            })
        }
        .padding(Spacing.lg)
        .glassCard()
    }

    // MARK: - Morning Summary Section

    private var morningSummarySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Morning Summary")
                .font(.shubhHeadline)
                .foregroundStyle(Color.textPrimary)

            VStack(spacing: 0) {
                // Enable toggle
                Toggle(isOn: $viewModel.isMorningSummaryEnabled) {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "sun.horizon.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.shubhGold)
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Daily Panchanga")
                                .font(.shubhSubheadline)
                                .foregroundStyle(Color.textPrimary)

                            Text("Get today's tithi, nakshatra, and timings")
                                .font(.shubhCaption)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                }
                .tint(Color.shubhSaffron)
                .padding(Spacing.md)

                if viewModel.isMorningSummaryEnabled {
                    Divider()
                        .background(Color.glassBorder)

                    // Time picker button
                    Button {
                        showTimePicker = true
                    } label: {
                        HStack {
                            Image(systemName: "clock")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.textTertiary)
                                .frame(width: 28)

                            Text("Notification Time")
                                .font(.shubhSubheadline)
                                .foregroundStyle(Color.textPrimary)

                            Spacer()

                            Text(viewModel.morningTimeFormatted)
                                .font(.shubhSubheadline)
                                .foregroundStyle(Color.shubhSaffron)

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textTertiary)
                        }
                        .padding(Spacing.md)
                    }
                }
            }
            .background(Color.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Rahu Kalam Section

    private var rahuKalamSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Muhurta Alerts")
                .font(.shubhHeadline)
                .foregroundStyle(Color.textPrimary)

            VStack(spacing: 0) {
                Toggle(isOn: $viewModel.isRahuKalamAlertEnabled) {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.muhurtaCaution)
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Rahu Kalam Alert")
                                .font(.shubhSubheadline)
                                .foregroundStyle(Color.textPrimary)

                            Text("Get notified before Rahu Kalam starts")
                                .font(.shubhCaption)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                }
                .tint(Color.shubhSaffron)
                .padding(Spacing.md)
            }
            .background(Color.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textTertiary)

                Text("About Notifications")
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textTertiary)
            }

            Text("Notifications help you stay aligned with auspicious times. Morning summaries provide daily panchanga at a glance, while muhurta alerts remind you of important time windows throughout the day.")
                .font(.shubhCaption)
                .foregroundStyle(Color.textTertiary)
        }
        .padding(.top, Spacing.sm)
    }
}

// MARK: - Time Picker Sheet
struct TimePickerSheet: View {
    @Binding var hour: Int
    @Binding var minute: Int
    @Environment(\.dismiss) private var dismiss

    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.lg) {
                Text("Choose when to receive your daily panchanga summary")
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                DatePicker(
                    "Time",
                    selection: $selectedDate,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()

                Spacer()
            }
            .padding(.top, Spacing.lg)
            .background(Color.surfacePrimary)
            .navigationTitle("Notification Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color.textSecondary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
                        hour = components.hour ?? 6
                        minute = components.minute ?? 0
                        dismiss()
                    }
                    .foregroundStyle(Color.shubhSaffron)
                }
            }
            .onAppear {
                // Set initial date from hour/minute
                var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                components.hour = hour
                components.minute = minute
                if let date = Calendar.current.date(from: components) {
                    selectedDate = date
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
