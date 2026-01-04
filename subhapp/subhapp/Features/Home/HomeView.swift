//
//  HomeView.swift
//  subhapp
//
//  Home Screen - Daily summary at a glance
//  Answer "what do I need to know NOW" in 3 seconds
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showNotificationSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Date subtitle
                    HStack {
                        Text(viewModel.formattedDate)
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.textSecondary)

                        Spacer()
                    }
                    .padding(.horizontal, Spacing.md)

                    // Hero Summary Card
                    TodaySummaryCard(panchanga: viewModel.todayPanchanga)
                        .padding(.horizontal, Spacing.md)

                    // Timeline Section
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "Today's Timeline")
                            .padding(.horizontal, Spacing.md)

                        MuhurtaTimelineView(panchanga: viewModel.todayPanchanga)
                            .padding(.horizontal, Spacing.md)
                    }

                    // Upcoming Favorable Windows
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "Upcoming Favorable Windows")
                            .padding(.horizontal, Spacing.md)

                        UpcomingWindowsCarousel(windows: viewModel.upcomingFavorableWindows)
                            .padding(.leading, Spacing.md)
                    }

                    // Quick Actions
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "Find Auspicious Time For")
                            .padding(.horizontal, Spacing.md)

                        QuickActionsGrid { activity in
                            // TODO: Navigate to search with activity pre-selected
                            print("Selected activity: \(activity.displayName)")
                        }
                        .padding(.horizontal, Spacing.md)
                    }

                    // Bottom spacing for tab bar
                    Spacer()
                        .frame(height: Spacing.xl)
                }
                .padding(.top, Spacing.sm)
            }
            .background(Color.surfacePrimary)
            .navigationTitle(viewModel.personalizedGreeting)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNotificationSheet = true
                    } label: {
                        Image(systemName: "bell.badge")
                            .foregroundStyle(Color.shubhSaffron)
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.loadTodayData()
        }
        .sheet(isPresented: $showNotificationSheet) {
            NotificationCenterSheet()
        }
    }
}

// MARK: - Notification Center Sheet (Placeholder)
struct NotificationCenterSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.surfacePrimary.ignoresSafeArea()

                VStack(spacing: Spacing.lg) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.textTertiary)

                    Text("No Notifications")
                        .font(.shubhTitle3)
                        .foregroundStyle(Color.textPrimary)

                    Text("You're all caught up! Notifications about\nauspicious times will appear here.")
                        .font(.shubhBody)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("Notifications")
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
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    HomeView()
}
