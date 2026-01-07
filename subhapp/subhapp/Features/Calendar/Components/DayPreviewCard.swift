//
//  DayPreviewCard.swift
//  subhapp
//
//  Calendar - Preview card for selected day
//

import SwiftUI

struct DayPreviewCard: View {
    let date: Date
    let panchanga: Panchanga?
    let onViewFullDay: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                        .font(.shubhHeadline)
                        .foregroundStyle(Color.textPrimary)

                    if let panchanga = panchanga {
                        Text("\(panchanga.tithi.fullName) • \(panchanga.nakshatra.name)")
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                Spacer()

                // Energy indicator
                if let panchanga = panchanga {
                    EnergyBadge(energyLevel: panchanga.energyLevel)
                }
            }

            if let panchanga = panchanga {
                Divider()
                    .background(Color.glassBorder)

                // Good for / Avoid summary
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    // Favorable indicators
                    if panchanga.amritKalam != nil {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.muhurtaExcellent)
                                .font(.system(size: 14))

                            Text("Amrit Kalam: \(panchanga.amritKalam!.formatted)")
                                .font(.shubhCaption)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }

                    if panchanga.abhijitMuhurta != nil {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.muhurtaExcellent)
                                .font(.system(size: 14))

                            Text("Abhijit Muhurta: \(panchanga.abhijitMuhurta!.formatted)")
                                .font(.shubhCaption)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }

                    // Inauspicious periods
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(Color.muhurtaAvoid)
                            .font(.system(size: 14))

                        Text("Rahu Kalam: \(panchanga.rahuKalam.formatted)")
                            .font(.shubhCaption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                // View full day button
                Button {
                    onViewFullDay()
                } label: {
                    HStack {
                        Text("View Full Day Details")
                            .font(.shubhSubheadline)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(Color.shubhSaffron)
                }
                .padding(.top, Spacing.xs)
            } else {
                // Loading state
                HStack {
                    ProgressView()
                        .tint(Color.shubhSaffron)
                    Text("Loading...")
                        .font(.shubhSubheadline)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.vertical, Spacing.sm)
            }
        }
        .padding(Spacing.cardPadding)
        .glassCard()
    }
}

// MARK: - Energy Badge
struct EnergyBadge: View {
    let energyLevel: Panchanga.EnergyLevel

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(energyLevel.color)
                .frame(width: 8, height: 8)

            Text(shortLabel)
                .font(.shubhCaption)
                .fontWeight(.medium)
                .foregroundStyle(energyLevel.color)
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, 6)
        .background(energyLevel.color.opacity(0.15))
        .clipShape(Capsule())
    }

    private var shortLabel: String {
        switch energyLevel {
        case .excellent: return "Excellent"
        case .good: return "Good"
        case .neutral: return "Mixed"
        case .caution: return "Caution"
        case .avoid: return "Avoid"
        }
    }
}

#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        DayPreviewCard(
            date: Date(),
            panchanga: MockPanchangaService.shared.getPanchanga(for: Date()),
            onViewFullDay: {}
        )
        .padding()
    }
}
