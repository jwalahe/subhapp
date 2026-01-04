//
//  TodaySummaryCard.swift
//  subhapp
//
//  Home Screen - Hero card showing today's panchanga summary
//

import SwiftUI

struct TodaySummaryCard: View {
    let panchanga: Panchanga?

    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: Spacing.md) {
            // Overall Energy Indicator
            HStack {
                Circle()
                    .fill(energyColor)
                    .frame(width: 12, height: 12)

                Text(energyText)
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                // Energy icon
                Image(systemName: energyIcon)
                    .font(.system(size: 16))
                    .foregroundStyle(energyColor)
            }

            Divider()
                .background(Color.glassBorder)

            // Panchanga Details Grid
            if let panchanga = panchanga {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: Spacing.sm) {
                    PanchangaDetailRow(
                        label: "Tithi",
                        value: panchanga.tithi.fullName,
                        icon: "moon.fill"
                    )
                    PanchangaDetailRow(
                        label: "Nakshatra",
                        value: panchanga.nakshatra.name,
                        icon: "star.fill"
                    )
                    PanchangaDetailRow(
                        label: "Yoga",
                        value: panchanga.yoga.name,
                        icon: "circle.dotted"
                    )
                    PanchangaDetailRow(
                        label: "Karana",
                        value: panchanga.karana.name,
                        icon: "diamond.fill"
                    )
                }

                // Expandable section
                DisclosureGroup(isExpanded: $isExpanded) {
                    VStack(spacing: Spacing.sm) {
                        Divider()
                            .background(Color.glassBorder)
                            .padding(.top, Spacing.xs)

                        HStack {
                            DetailItem(label: "Telugu Month", value: panchanga.teluguMonth)
                            Spacer()
                            DetailItem(label: "Paksha", value: panchanga.paksha)
                        }

                        HStack {
                            DetailItem(label: "Sunrise", value: panchanga.sunrise.formatted(date: .omitted, time: .shortened))
                            Spacer()
                            DetailItem(label: "Sunset", value: panchanga.sunset.formatted(date: .omitted, time: .shortened))
                        }
                    }
                } label: {
                    Text("View Full Panchanga")
                        .font(.shubhSubheadline)
                        .foregroundStyle(Color.shubhSaffron)
                }
                .tint(Color.shubhSaffron)
            } else {
                // Loading state
                HStack {
                    ProgressView()
                        .tint(Color.shubhSaffron)
                    Text("Loading panchanga...")
                        .font(.shubhSubheadline)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.vertical, Spacing.lg)
            }
        }
        .padding(Spacing.cardPadding)
        .glassCard()
    }

    // MARK: - Computed Properties

    private var energyColor: Color {
        panchanga?.energyLevel.color ?? Color.muhurtaNeutral
    }

    private var energyText: String {
        panchanga?.energyLevel.rawValue ?? "Loading..."
    }

    private var energyIcon: String {
        panchanga?.energyLevel.icon ?? "circle"
    }
}

// MARK: - Panchanga Detail Row
struct PanchangaDetailRow: View {
    let label: String
    let value: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: Spacing.xs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.shubhGold)
                    .frame(width: 16)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textTertiary)

                Text(value)
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
            }

            Spacer()
        }
    }
}

// MARK: - Detail Item
struct DetailItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.shubhCaption)
                .foregroundStyle(Color.textTertiary)

            Text(value)
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textSecondary)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        TodaySummaryCard(panchanga: MockPanchangaService.shared.getPanchanga(for: Date()))
            .padding()
    }
}
