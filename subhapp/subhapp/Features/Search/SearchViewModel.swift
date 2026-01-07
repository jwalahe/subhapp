//
//  SearchViewModel.swift
//  subhapp
//
//  Search Screen View Model
//

import Foundation
import SwiftUI

@Observable
class SearchViewModel {
    var searchText = ""
    var selectedActivity: Activity?
    var timeRangeWeeks: Double = 2
    var searchResults: [MuhurtaSearchResult] = []
    var isSearching = false
    var hasSearched = false

    private let panchangaService = MockPanchangaService.shared

    // MARK: - Search

    func search() async {
        guard selectedActivity != nil || !searchText.isEmpty else { return }

        await MainActor.run {
            isSearching = true
        }

        // Simulate search delay
        try? await Task.sleep(nanoseconds: 500_000_000)

        let results = await performSearch()

        await MainActor.run {
            self.searchResults = results
            self.isSearching = false
            self.hasSearched = true
        }
    }

    private func performSearch() async -> [MuhurtaSearchResult] {
        var results: [MuhurtaSearchResult] = []
        let calendar = Calendar.current
        let daysToSearch = Int(timeRangeWeeks * 7)

        // Get conditions from selected activity or use general
        let conditions = selectedActivity?.favorableConditions ?? .general

        for dayOffset in 0..<daysToSearch {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: Date()) else { continue }

            let panchanga = panchangaService.getPanchanga(for: date)
            let score = calculateScore(panchanga: panchanga, conditions: conditions)

            // Only include days with score >= 6
            if score >= 6 {
                let result = MuhurtaSearchResult(
                    date: date,
                    panchanga: panchanga,
                    score: score,
                    positiveReasons: generatePositiveReasons(panchanga: panchanga, conditions: conditions),
                    cautionReasons: generateCautionReasons(panchanga: panchanga)
                )
                results.append(result)
            }
        }

        // Sort by score descending
        return results.sorted { $0.score > $1.score }
    }

    private func calculateScore(panchanga: Panchanga, conditions: MuhurtaConditions) -> Double {
        var score = panchanga.overallAuspiciousnessScore

        // Bonus for preferred tithi
        if conditions.preferredTithis.contains(panchanga.tithi.number) {
            score += 1.0
        }

        // Bonus for preferred nakshatra
        if conditions.preferredNakshatras.contains(panchanga.nakshatra.name) {
            score += 1.0
        }

        // Bonus for preferred vara
        if conditions.preferredVaras.contains(panchanga.vara) {
            score += 0.5
        }

        // Penalty for avoided tithi
        if conditions.avoidTithis.contains(panchanga.tithi.number) {
            score -= 2.0
        }

        // Bonus for amrit kalam
        if conditions.requireAmritKalam && panchanga.amritKalam != nil {
            score += 1.0
        }

        return min(10, max(0, score))
    }

    private func generatePositiveReasons(panchanga: Panchanga, conditions: MuhurtaConditions) -> [String] {
        var reasons: [String] = []

        if conditions.preferredTithis.contains(panchanga.tithi.number) {
            reasons.append("\(panchanga.tithi.name) is favorable for this activity")
        }

        if conditions.preferredNakshatras.contains(panchanga.nakshatra.name) {
            reasons.append("\(panchanga.nakshatra.name) nakshatra is auspicious")
        }

        if panchanga.amritKalam != nil {
            reasons.append("Amrit Kalam available: \(panchanga.amritKalam!.formatted)")
        }

        if panchanga.yoga.isAuspicious {
            reasons.append("\(panchanga.yoga.name) yoga is favorable")
        }

        if conditions.preferredVaras.contains(panchanga.vara) {
            reasons.append("\(panchanga.vara.name) is good for this activity")
        }

        return reasons.isEmpty ? ["Generally favorable day"] : reasons
    }

    private func generateCautionReasons(panchanga: Panchanga) -> [String] {
        var reasons: [String] = []

        reasons.append("Rahu Kalam: \(panchanga.rahuKalam.formatted)")

        if panchanga.karana.isBhadra {
            reasons.append("Bhadra karana - exercise caution")
        }

        return reasons
    }

    // MARK: - Reset

    func clearSearch() {
        searchText = ""
        selectedActivity = nil
        searchResults = []
        hasSearched = false
    }

    // MARK: - Computed

    var topResult: MuhurtaSearchResult? {
        searchResults.first
    }

    var otherResults: [MuhurtaSearchResult] {
        Array(searchResults.dropFirst())
    }

    var searchTitle: String {
        if let activity = selectedActivity {
            return "Best days for \(activity.displayName)"
        } else if !searchText.isEmpty {
            return "Results for \"\(searchText)\""
        }
        return "Search Results"
    }
}

// MARK: - Search Result Model
struct MuhurtaSearchResult: Identifiable {
    let id = UUID()
    let date: Date
    let panchanga: Panchanga
    let score: Double
    let positiveReasons: [String]
    let cautionReasons: [String]

    var shareText: String {
        """
        ✨ Auspicious time found via Shubh

        📅 \(date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
        ⭐ Score: \(String(format: "%.1f", score))/10

        \(panchanga.tithi.fullName) | \(panchanga.nakshatra.name)

        Download Shubh for more: https://shubhapp.com
        """
    }
}
