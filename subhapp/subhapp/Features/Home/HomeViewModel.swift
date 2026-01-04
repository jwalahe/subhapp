//
//  HomeViewModel.swift
//  subhapp
//
//  Home Screen View Model - State management
//

import Foundation
import SwiftUI

@Observable
class HomeViewModel {
    var todayPanchanga: Panchanga?
    var currentMuhurta: Muhurta?
    var upcomingFavorableWindows: [MuhurtaWindow] = []
    var isLoading = false
    var errorMessage: String?

    private let panchangaService = MockPanchangaService.shared

    // MARK: - Load Data

    func loadTodayData() async {
        await MainActor.run {
            isLoading = true
        }

        // Simulate network delay for realistic feel
        try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds

        let panchanga = panchangaService.getPanchanga(for: Date())

        await MainActor.run {
            self.todayPanchanga = panchanga
            self.currentMuhurta = panchanga.currentMuhurta(at: Date())
            self.upcomingFavorableWindows = generateUpcomingWindows()
            self.isLoading = false
        }
    }

    // MARK: - Refresh

    func refresh() async {
        await loadTodayData()
    }

    // MARK: - Helper Methods

    private func generateUpcomingWindows() -> [MuhurtaWindow] {
        var windows: [MuhurtaWindow] = []
        let calendar = Calendar.current

        // Get favorable windows for next 7 days
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: Date()) else { continue }

            let panchanga = panchangaService.getPanchanga(for: date)
            let dayWindows = panchanga.favorableWindows()

            // Filter out past windows for today
            if dayOffset == 0 {
                let now = Date()
                windows.append(contentsOf: dayWindows.filter { $0.timeRange.end > now })
            } else {
                windows.append(contentsOf: dayWindows)
            }
        }

        // Limit to first 5 windows
        return Array(windows.prefix(5))
    }

    // MARK: - Computed Properties

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default: return "Namaste"
        }
    }

    var personalizedGreeting: String {
        let userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        if userName.isEmpty {
            return greeting
        }
        return "\(greeting), \(userName)"
    }

    var formattedDate: String {
        Date().formatted(.dateTime.weekday(.wide).month(.wide).day())
    }
}
