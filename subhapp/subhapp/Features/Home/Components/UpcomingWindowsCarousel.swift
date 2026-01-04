//
//  UpcomingWindowsCarousel.swift
//  subhapp
//
//  Home Screen - Horizontal scroll of upcoming favorable windows
//

import SwiftUI

struct UpcomingWindowsCarousel: View {
    let windows: [MuhurtaWindow]

    var body: some View {
        if windows.isEmpty {
            EmptyWindowsView()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.sm) {
                    ForEach(windows) { window in
                        UpcomingWindowCard(window: window)
                    }
                }
            }
        }
    }
}

// MARK: - Upcoming Window Card
struct UpcomingWindowCard: View {
    let window: MuhurtaWindow

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Date label
            HStack {
                Text(window.dateLabel)
                    .font(.shubhCaption)
                    .fontWeight(.semibold)
                    .foregroundStyle(window.isToday ? Color.shubhSaffron : Color.textSecondary)

                Spacer()

                // Score
                ScoreBadge(score: window.score)
            }

            // Time range
            Text(window.timeRange.formatted)
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textPrimary)

            // Reasons
            if let firstReason = window.reasons.first {
                Text(firstReason)
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(2)
            }
        }
        .padding(Spacing.md)
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.surfaceElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(window.isToday ? Color.shubhSaffron.opacity(0.5) : Color.clear, lineWidth: 1)
                )
        )
    }
}

// MARK: - Score Badge
struct ScoreBadge: View {
    let score: Double

    var body: some View {
        Text(String(format: "%.0f", score))
            .font(.shubhCaption)
            .fontWeight(.bold)
            .foregroundStyle(Color.surfacePrimary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(scoreColor)
            .clipShape(Capsule())
    }

    private var scoreColor: Color {
        switch score {
        case 9...10: return .muhurtaExcellent
        case 7..<9: return .muhurtaGood
        case 5..<7: return .muhurtaNeutral
        default: return .muhurtaCaution
        }
    }
}

// MARK: - Empty Windows View
struct EmptyWindowsView: View {
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "sparkles")
                .font(.system(size: 20))
                .foregroundStyle(Color.shubhGold)

            Text("No upcoming windows found. Check back tomorrow!")
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.surfaceElevated)
        )
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        VStack {
            SectionHeader(title: "Upcoming Favorable Windows")

            UpcomingWindowsCarousel(windows: [
                MuhurtaWindow(
                    id: UUID(),
                    date: Date(),
                    timeRange: TimeRange.today(startHour: 10, startMinute: 30, endHour: 12, endMinute: 0),
                    score: 10,
                    reasons: ["Amrit Kalam - highly auspicious"]
                ),
                MuhurtaWindow(
                    id: UUID(),
                    date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                    timeRange: TimeRange.today(startHour: 11, startMinute: 48, endHour: 12, endMinute: 36),
                    score: 9,
                    reasons: ["Abhijit Muhurta - victory time"]
                )
            ])
        }
        .padding()
    }
}
