//
//  SettingsView.swift
//  subhapp
//
//  Settings Screen - App preferences and configuration
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("locationName") private var locationName = "Milwaukee, WI"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("morningNotificationHour") private var morningNotificationHour = 7
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true

    @State private var showLocationSheet = false
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    HStack(spacing: Spacing.md) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.shubhSaffron, Color.shubhGold],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)

                            Text(avatarInitial)
                                .font(.shubhTitle1)
                                .foregroundStyle(Color.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(userName.isEmpty ? "Shubh User" : userName)
                                .font(.shubhHeadline)
                                .foregroundStyle(Color.textPrimary)

                            Text("Tap to edit profile")
                                .font(.shubhCaption)
                                .foregroundStyle(Color.textTertiary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.textTertiary)
                    }
                    .padding(.vertical, Spacing.xs)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // TODO: Navigate to profile edit
                    }
                }
                .listRowBackground(Color.surfaceElevated)

                // Location Section
                Section {
                    Button {
                        showLocationSheet = true
                    } label: {
                        HStack {
                            SettingsIcon(systemName: "location.fill", color: .blue)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Location")
                                    .font(.shubhBody)
                                    .foregroundStyle(Color.textPrimary)

                                Text(locationName)
                                    .font(.shubhCaption)
                                    .foregroundStyle(Color.textSecondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                } header: {
                    Text("Panchanga Calculation")
                } footer: {
                    Text("Location is used to calculate accurate sunrise, sunset, and muhurta timings.")
                }
                .listRowBackground(Color.surfaceElevated)

                // Notifications Section
                Section {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        HStack {
                            SettingsIcon(systemName: "bell.fill", color: .shubhSaffron)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Notifications")
                                    .font(.shubhBody)
                                    .foregroundStyle(Color.textPrimary)

                                Text(notificationsEnabled ? "Daily summary enabled" : "Disabled")
                                    .font(.shubhCaption)
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                } header: {
                    Text("Notifications")
                }
                .listRowBackground(Color.surfaceElevated)

                // Appearance Section
                Section {
                    NavigationLink {
                        AppearanceSettingsView()
                    } label: {
                        HStack {
                            SettingsIcon(systemName: "paintbrush.fill", color: .purple)
                            Text("Appearance")
                                .font(.shubhBody)
                        }
                    }
                } header: {
                    Text("Appearance")
                }
                .listRowBackground(Color.surfaceElevated)

                // About Section
                Section {
                    HStack {
                        SettingsIcon(systemName: "info.circle.fill", color: .gray)
                        Text("Version")
                            .font(.shubhBody)
                        Spacer()
                        Text("1.0.0 (MVP)")
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.textSecondary)
                    }

                    Link(destination: URL(string: "https://shubhapp.com/privacy")!) {
                        HStack {
                            SettingsIcon(systemName: "hand.raised.fill", color: .green)
                            Text("Privacy Policy")
                                .font(.shubhBody)
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }

                    Link(destination: URL(string: "https://shubhapp.com/terms")!) {
                        HStack {
                            SettingsIcon(systemName: "doc.text.fill", color: .orange)
                            Text("Terms of Service")
                                .font(.shubhBody)
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                } header: {
                    Text("About")
                }
                .listRowBackground(Color.surfaceElevated)

                // Developer Section (for testing)
                Section {
                    Button {
                        showResetAlert = true
                    } label: {
                        HStack {
                            SettingsIcon(systemName: "arrow.counterclockwise", color: .red)
                            Text("Reset Onboarding")
                                .font(.shubhBody)
                                .foregroundStyle(Color.muhurtaAvoid)
                        }
                    }
                } header: {
                    Text("Developer")
                } footer: {
                    Text("Reset the app to show the onboarding flow again.")
                }
                .listRowBackground(Color.surfaceElevated)
            }
            .scrollContentBackground(.hidden)
            .background(Color.surfacePrimary)
            .navigationTitle("Settings")
            .sheet(isPresented: $showLocationSheet) {
                LocationSettingsSheet(locationName: $locationName)
            }
            .alert("Reset Onboarding?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    hasCompletedOnboarding = false
                }
            } message: {
                Text("This will show the onboarding flow again when you restart the app.")
            }
        }
    }

    private var avatarInitial: String {
        if userName.isEmpty {
            return "S"
        }
        return String(userName.prefix(1)).uppercased()
    }
}

// MARK: - Settings Icon
struct SettingsIcon: View {
    let systemName: String
    let color: Color

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 16))
            .foregroundStyle(color)
            .frame(width: 28, height: 28)
            .background(color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

// MARK: - Location Settings Sheet
struct LocationSettingsSheet: View {
    @Binding var locationName: String
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""

    // Predefined locations for MVP
    private let popularLocations = [
        "Milwaukee, WI",
        "Chicago, IL",
        "New York, NY",
        "Los Angeles, CA",
        "Houston, TX",
        "Phoenix, AZ",
        "San Francisco, CA",
        "Seattle, WA",
        "Hyderabad, India",
        "Chennai, India",
        "Mumbai, India",
        "Bangalore, India",
        "Delhi, India"
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(filteredLocations, id: \.self) { location in
                        Button {
                            locationName = location
                            dismiss()
                        } label: {
                            HStack {
                                Text(location)
                                    .font(.shubhBody)
                                    .foregroundStyle(Color.textPrimary)

                                Spacer()

                                if location == locationName {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.shubhSaffron)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Select Location")
                } footer: {
                    Text("More locations and automatic detection coming soon.")
                }
                .listRowBackground(Color.surfaceElevated)
            }
            .searchable(text: $searchText, prompt: "Search cities")
            .scrollContentBackground(.hidden)
            .background(Color.surfacePrimary)
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.shubhSaffron)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    private var filteredLocations: [String] {
        if searchText.isEmpty {
            return popularLocations
        }
        return popularLocations.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
}

// MARK: - Appearance Settings View (Placeholder)
struct AppearanceSettingsView: View {
    var body: some View {
        ZStack {
            Color.surfacePrimary.ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Color.textTertiary)

                Text("Coming Soon")
                    .font(.shubhTitle3)
                    .foregroundStyle(Color.textPrimary)

                Text("Theme customization and\nTelugu language support")
                    .font(.shubhBody)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
