//
//  DayDetailSheet.swift
//  subhapp
//
//  Calendar - Full day detail sheet
//

import SwiftUI

struct DayDetailSheet: View {
    let date: Date
    let panchanga: Panchanga?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    if let panchanga = panchanga {
                        // Energy header
                        EnergyHeader(panchanga: panchanga)

                        // Panchanga details
                        PanchangaDetailsSection(panchanga: panchanga)

                        // Time periods
                        TimePeriodsSection(panchanga: panchanga)

                        // Favorable activities
                        FavorableActivitiesSection(panchanga: panchanga)

                    } else {
                        ProgressView()
                            .padding(.top, Spacing.xxl)
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.xl)
            }
            .background(Color.surfacePrimary)
            .navigationTitle(date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))
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
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Energy Header
struct EnergyHeader: View {
    let panchanga: Panchanga

    var body: some View {
        VStack(spacing: Spacing.sm) {
            // Large energy indicator
            ZStack {
                Circle()
                    .fill(panchanga.energyLevel.color.opacity(0.2))
                    .frame(width: 80, height: 80)

                Image(systemName: panchanga.energyLevel.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(panchanga.energyLevel.color)
            }

            Text(panchanga.energyLevel.rawValue)
                .font(.shubhTitle3)
                .foregroundStyle(Color.textPrimary)

            Text("Overall Score: \(String(format: "%.1f", panchanga.overallAuspiciousnessScore))/10")
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.lg)
        .glassCard()
    }
}

// MARK: - Panchanga Details Section
struct PanchangaDetailsSection: View {
    let panchanga: Panchanga

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Panchanga")
                .font(.shubhHeadline)
                .foregroundStyle(Color.textPrimary)

            VStack(spacing: Spacing.sm) {
                DetailRow(label: "Tithi", value: panchanga.tithi.fullName, teluguValue: panchanga.tithi.teluguName)
                DetailRow(label: "Nakshatra", value: panchanga.nakshatra.name, teluguValue: panchanga.nakshatra.teluguName)
                DetailRow(label: "Yoga", value: panchanga.yoga.name, teluguValue: panchanga.yoga.teluguName)
                DetailRow(label: "Karana", value: panchanga.karana.name, teluguValue: panchanga.karana.teluguName)
                DetailRow(label: "Vara", value: panchanga.vara.name, teluguValue: panchanga.vara.teluguName)

                Divider()
                    .background(Color.glassBorder)

                DetailRow(label: "Telugu Month", value: panchanga.teluguMonth, teluguValue: nil)
                DetailRow(label: "Paksha", value: panchanga.paksha, teluguValue: nil)
            }
            .padding(Spacing.cardPadding)
            .glassCard()
        }
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let label: String
    let value: String
    let teluguValue: String?

    var body: some View {
        HStack {
            Text(label)
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textSecondary)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(value)
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textPrimary)

                if let telugu = teluguValue {
                    Text(telugu)
                        .font(.shubhCaption)
                        .foregroundStyle(Color.textTertiary)
                }
            }
        }
    }
}

// MARK: - Time Periods Section
struct TimePeriodsSection: View {
    let panchanga: Panchanga

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Important Timings")
                .font(.shubhHeadline)
                .foregroundStyle(Color.textPrimary)

            VStack(spacing: Spacing.sm) {
                // Sunrise/Sunset
                TimePeriodRow(
                    icon: "sunrise.fill",
                    label: "Sunrise",
                    time: panchanga.sunrise.formatted(date: .omitted, time: .shortened),
                    color: .shubhGold,
                    isAuspicious: true
                )

                TimePeriodRow(
                    icon: "sunset.fill",
                    label: "Sunset",
                    time: panchanga.sunset.formatted(date: .omitted, time: .shortened),
                    color: .shubhSaffron,
                    isAuspicious: true
                )

                Divider()
                    .background(Color.glassBorder)

                // Auspicious periods
                if let amrit = panchanga.amritKalam {
                    TimePeriodRow(
                        icon: "sparkles",
                        label: "Amrit Kalam",
                        time: amrit.formatted,
                        color: .muhurtaExcellent,
                        isAuspicious: true
                    )
                }

                if let abhijit = panchanga.abhijitMuhurta {
                    TimePeriodRow(
                        icon: "star.fill",
                        label: "Abhijit Muhurta",
                        time: abhijit.formatted,
                        color: .muhurtaExcellent,
                        isAuspicious: true
                    )
                }

                Divider()
                    .background(Color.glassBorder)

                // Inauspicious periods
                TimePeriodRow(
                    icon: "exclamationmark.triangle.fill",
                    label: "Rahu Kalam",
                    time: panchanga.rahuKalam.formatted,
                    color: .muhurtaAvoid,
                    isAuspicious: false
                )

                TimePeriodRow(
                    icon: "xmark.circle.fill",
                    label: "Yamaganda",
                    time: panchanga.yamaganda.formatted,
                    color: .muhurtaCaution,
                    isAuspicious: false
                )

                TimePeriodRow(
                    icon: "moon.fill",
                    label: "Gulika Kalam",
                    time: panchanga.gulikaKalam.formatted,
                    color: .muhurtaCaution,
                    isAuspicious: false
                )
            }
            .padding(Spacing.cardPadding)
            .glassCard()
        }
    }
}

// MARK: - Time Period Row
struct TimePeriodRow: View {
    let icon: String
    let label: String
    let time: String
    let color: Color
    let isAuspicious: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
                .frame(width: 24)

            Text(label)
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text(time)
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textSecondary)
        }
    }
}

// MARK: - Favorable Activities Section
struct FavorableActivitiesSection: View {
    let panchanga: Panchanga

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Today's Guidance")
                .font(.shubhHeadline)
                .foregroundStyle(Color.textPrimary)

            VStack(alignment: .leading, spacing: Spacing.sm) {
                // Based on vara
                Text("Favorable for \(panchanga.vara.name):")
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textSecondary)

                ForEach(panchanga.vara.favorableFor.prefix(3), id: \.self) { activity in
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.muhurtaGood)

                        Text(activity)
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.textPrimary)
                    }
                }

                // Nakshatra info
                if panchanga.nakshatra.isFavorable {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.shubhGold)

                        Text("\(panchanga.nakshatra.name) nakshatra is generally auspicious")
                            .font(.shubhCaption)
                            .foregroundStyle(Color.textSecondary)
                    }
                    .padding(.top, Spacing.xs)
                }
            }
            .padding(Spacing.cardPadding)
            .glassCard()
        }
    }
}

#Preview {
    DayDetailSheet(
        date: Date(),
        panchanga: MockPanchangaService.shared.getPanchanga(for: Date())
    )
}
