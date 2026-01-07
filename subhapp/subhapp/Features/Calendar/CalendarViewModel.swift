//
//  CalendarViewModel.swift
//  subhapp
//
//  Calendar Screen View Model
//

import Foundation
import SwiftUI

@Observable
class CalendarViewModel {
    var displayedMonth: Date = Date()
    var selectedDate: Date = Date()
    var monthPanchangaData: [Date: Panchanga] = [:]
    var isLoading = false

    private let panchangaService = MockPanchangaService.shared

    // MARK: - Load Month Data

    func loadMonth(_ date: Date) async {
        await MainActor.run {
            isLoading = true
        }

        let data = panchangaService.getPanchangaForMonth(date)

        await MainActor.run {
            self.monthPanchangaData = data
            self.isLoading = false
        }
    }

    // MARK: - Navigation

    func goToNextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            displayedMonth = displayedMonth.nextMonth
        }
        Task {
            await loadMonth(displayedMonth)
        }
    }

    func goToPreviousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            displayedMonth = displayedMonth.previousMonth
        }
        Task {
            await loadMonth(displayedMonth)
        }
    }

    func goToToday() {
        withAnimation(.easeInOut(duration: 0.3)) {
            displayedMonth = Date()
            selectedDate = Date()
        }
        Task {
            await loadMonth(displayedMonth)
        }
    }

    // MARK: - Data Access

    func panchanga(for date: Date) -> Panchanga? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return monthPanchangaData[startOfDay]
    }

    // MARK: - Calendar Helpers

    var monthYearString: String {
        displayedMonth.formatted(.dateTime.month(.wide).year())
    }

    func daysInMonth() -> [Date?] {
        let calendar = Calendar.current

        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth)
        else {
            return []
        }

        var days: [Date?] = []

        // Add nil for days before the month starts
        let firstWeekday = calendar.component(.weekday, from: monthInterval.start)
        for _ in 1..<firstWeekday {
            days.append(nil)
        }

        // Add all days in the month
        var currentDate = monthInterval.start
        while currentDate < monthInterval.end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return days
    }

    var isSelectedDateToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
}
