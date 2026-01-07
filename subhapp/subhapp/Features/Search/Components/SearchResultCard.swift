//
//  SearchResultCard.swift
//  subhapp
//
//  Search - Result card for muhurta search
//

import SwiftUI

struct SearchResultCard: View {
    let result: MuhurtaSearchResult
    let isTopPick: Bool
    var onAddToCalendar: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header with date and score
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if isTopPick {
                        Label("Top Recommendation", systemImage: "star.fill")
                            .font(.shubhCaption)
                            .foregroundStyle(Color.shubhGold)
                    }

                    Text(result.date.formatted(.dateTime.weekday(.wide).month().day()))
                        .font(.shubhTitle3)
                        .foregroundStyle(Color.textPrimary)
                }

                Spacer()

                // Score ring
                ScoreRing(score: result.score)
            }

            // Panchanga summary
            HStack(spacing: Spacing.xs) {
                Text(result.panchanga.tithi.fullName)
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textSecondary)

                Text("•")
                    .foregroundStyle(Color.textTertiary)

                Text(result.panchanga.nakshatra.name)
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textSecondary)
            }

            // Key timing
            if let amritKalam = result.panchanga.amritKalam {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(Color.shubhGold)
                        .font(.system(size: 14))

                    Text("Amrit Kalam: \(amritKalam.formatted)")
                        .font(.shubhSubheadline)
                        .foregroundStyle(Color.textPrimary)
                }
            }

            Divider()
                .background(Color.glassBorder)

            // Reasons
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(result.positiveReasons.prefix(3), id: \.self) { reason in
                    Label(reason, systemImage: "checkmark.circle.fill")
                        .font(.shubhFootnote)
                        .foregroundStyle(Color.muhurtaExcellent)
                }

                ForEach(result.cautionReasons.prefix(1), id: \.self) { reason in
                    Label(reason, systemImage: "exclamationmark.triangle.fill")
                        .font(.shubhFootnote)
                        .foregroundStyle(Color.muhurtaCaution)
                }
            }

            // Action buttons
            HStack(spacing: Spacing.sm) {
                Button {
                    onAddToCalendar?()
                } label: {
                    Label("Add to Calendar", systemImage: "calendar.badge.plus")
                        .font(.shubhSubheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.sm)
                        .background(Color.shubhSaffron)
                        .foregroundStyle(Color.surfacePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                ShareLink(item: result.shareText) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.shubhSubheadline)
                        .padding(Spacing.sm)
                        .background(Color.surfaceSecondary)
                        .foregroundStyle(Color.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(Spacing.cardPadding)
        .glassCard()
    }
}

// MARK: - Score Ring
struct ScoreRing: View {
    let score: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.surfaceSecondary, lineWidth: 4)

            Circle()
                .trim(from: 0, to: score / 10)
                .stroke(scoreColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))

            VStack(spacing: 0) {
                Text(String(format: "%.1f", score))
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.textPrimary)

                Text("/10")
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textTertiary)
            }
        }
        .frame(width: 56, height: 56)
    }

    private var scoreColor: Color {
        switch score {
        case 8...10: return .muhurtaExcellent
        case 6..<8: return .muhurtaGood
        case 4..<6: return .muhurtaNeutral
        default: return .muhurtaCaution
        }
    }
}

#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        ScrollView {
            VStack(spacing: Spacing.md) {
                SearchResultCard(
                    result: MuhurtaSearchResult(
                        date: Date(),
                        panchanga: MockPanchangaService.shared.getPanchanga(for: Date()),
                        score: 9.2,
                        positiveReasons: ["Shukla Panchami is favorable", "Rohini nakshatra is auspicious", "Amrit Kalam available"],
                        cautionReasons: ["Rahu Kalam: 2:00 PM - 3:30 PM"]
                    ),
                    isTopPick: true
                )

                SearchResultCard(
                    result: MuhurtaSearchResult(
                        date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                        panchanga: MockPanchangaService.shared.getPanchanga(for: Date()),
                        score: 7.5,
                        positiveReasons: ["Good yoga", "Thursday is favorable"],
                        cautionReasons: ["Rahu Kalam: 1:30 PM - 3:00 PM"]
                    ),
                    isTopPick: false
                )
            }
            .padding()
        }
    }
}
