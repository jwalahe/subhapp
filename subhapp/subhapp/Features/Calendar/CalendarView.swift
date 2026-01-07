//
//  CalendarView.swift
//  subhapp
//
//  Calendar Screen - Month view with heat map overlay
//

import SwiftUI

struct CalendarView: View {
    @State private var viewModel = CalendarViewModel()
    @State private var showDayDetail = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Month Navigation Header
                MonthNavigationHeader(
                    monthYearString: viewModel.monthYearString,
                    onPrevious: { viewModel.goToPreviousMonth() },
                    onNext: { viewModel.goToNextMonth() },
                    onToday: { viewModel.goToToday() }
                )
                .padding(.vertical, Spacing.sm)

                // Calendar Grid
                MonthGridView(
                    days: viewModel.daysInMonth(),
                    selectedDate: viewModel.selectedDate,
                    panchangaData: viewModel.monthPanchangaData,
                    onDateSelected: { date in
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedDate = date
                        }
                    }
                )
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onEnded { value in
                            if value.translation.width < -50 {
                                viewModel.goToNextMonth()
                            } else if value.translation.width > 50 {
                                viewModel.goToPreviousMonth()
                            }
                        }
                )

                Divider()
                    .background(Color.glassBorder)
                    .padding(.vertical, Spacing.md)

                // Selected Day Preview
                DayPreviewCard(
                    date: viewModel.selectedDate,
                    panchanga: viewModel.panchanga(for: viewModel.selectedDate),
                    onViewFullDay: { showDayDetail = true }
                )
                .padding(.horizontal, Spacing.md)

                Spacer()
            }
            .background(Color.surfacePrimary)
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.goToToday()
                    } label: {
                        Text("Today")
                            .font(.shubhSubheadline)
                            .foregroundStyle(viewModel.isSelectedDateToday ? Color.textTertiary : Color.shubhSaffron)
                    }
                    .disabled(viewModel.isSelectedDateToday)
                }
            }
            .sheet(isPresented: $showDayDetail) {
                DayDetailSheet(
                    date: viewModel.selectedDate,
                    panchanga: viewModel.panchanga(for: viewModel.selectedDate)
                )
            }
        }
        .task {
            await viewModel.loadMonth(viewModel.displayedMonth)
        }
    }
}

#Preview {
    CalendarView()
}
