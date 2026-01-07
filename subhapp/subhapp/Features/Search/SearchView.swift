//
//  SearchView.swift
//  subhapp
//
//  Search Screen - Find auspicious times for activities
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @FocusState private var isSearchFocused: Bool
    @State private var showCalendarAlert = false
    @State private var calendarAlertMessage = ""
    @State private var calendarAlertIsError = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.surfacePrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Spacing.lg) {
                        // Search Bar
                        SearchBar(
                            text: $viewModel.searchText,
                            placeholder: "e.g., \"Best day to buy a car\"",
                            onSubmit: {
                                performSearch()
                            }
                        )
                        .focused($isSearchFocused)

                        if !viewModel.hasSearched {
                            // Activity Selection
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                SectionHeader(title: "Or select an activity")

                                ActivitySelectionGrid(selectedActivity: $viewModel.selectedActivity)
                            }

                            // Time Range
                            VStack(alignment: .leading, spacing: Spacing.sm) {
                                SectionHeader(title: "Time range")

                                TimeRangeSlider(weeks: $viewModel.timeRangeWeeks)
                            }

                            // Search Button
                            ShubhButton(
                                title: "Find Auspicious Days",
                                action: {
                                    performSearch()
                                },
                                isEnabled: viewModel.selectedActivity != nil || !viewModel.searchText.isEmpty
                            )
                            .padding(.top, Spacing.md)
                        } else {
                            // Results View
                            resultsView
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, Spacing.md)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Find Muhurta")
            .toolbar {
                if viewModel.hasSearched {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.clearSearch()
                            }
                        } label: {
                            Text("New Search")
                                .font(.shubhSubheadline)
                                .foregroundStyle(Color.shubhSaffron)
                        }
                    }
                }
            }
            .overlay {
                if viewModel.isSearching {
                    searchingOverlay
                }
            }
            .alert(calendarAlertIsError ? "Error" : "Success", isPresented: $showCalendarAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(calendarAlertMessage)
            }
        }
    }

    // MARK: - Results View

    private var resultsView: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Results Header
            HStack {
                Text(viewModel.searchTitle)
                    .font(.shubhTitle3)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Text("\(viewModel.searchResults.count) found")
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textSecondary)
            }

            if viewModel.searchResults.isEmpty {
                noResultsView
            } else {
                // Top Pick
                if let topResult = viewModel.topResult {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Label("Top Pick", systemImage: "crown.fill")
                            .font(.shubhCaption)
                            .foregroundStyle(Color.shubhGold)

                        SearchResultCard(
                            result: topResult,
                            isTopPick: true,
                            onAddToCalendar: {
                                addToCalendar(result: topResult)
                            }
                        )
                    }
                }

                // Other Results
                if !viewModel.otherResults.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Other Options")
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.textSecondary)

                        ForEach(viewModel.otherResults) { result in
                            SearchResultCard(
                                result: result,
                                isTopPick: false,
                                onAddToCalendar: {
                                    addToCalendar(result: result)
                                }
                            )
                        }
                    }
                }
            }
        }
    }

    // MARK: - No Results View

    private var noResultsView: some View {
        VStack(spacing: Spacing.lg) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 48))
                .foregroundStyle(Color.textTertiary)

            Text("No auspicious days found")
                .font(.shubhTitle3)
                .foregroundStyle(Color.textPrimary)

            Text("Try expanding your search range or selecting a different activity")
                .font(.shubhBody)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.xxl)
    }

    // MARK: - Searching Overlay

    private var searchingOverlay: some View {
        ZStack {
            Color.surfacePrimary.opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(Color.shubhSaffron)

                Text("Finding auspicious days...")
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.textPrimary)

                Text("Analyzing panchanga data")
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(Spacing.xl)
            .glassCard()
        }
    }

    // MARK: - Actions

    private func performSearch() {
        isSearchFocused = false
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        Task {
            await viewModel.search()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }

    private func addToCalendar(result: MuhurtaSearchResult) {
        Task {
            do {
                let success = try await CalendarService.shared.addMuhurtaToCalendar(
                    date: result.date,
                    activity: viewModel.selectedActivity,
                    panchanga: result.panchanga,
                    score: result.score
                )
                await MainActor.run {
                    if success {
                        calendarAlertIsError = false
                        calendarAlertMessage = "Event added to your calendar!"
                        showCalendarAlert = true
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
            } catch {
                await MainActor.run {
                    calendarAlertIsError = true
                    calendarAlertMessage = error.localizedDescription
                    showCalendarAlert = true
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
