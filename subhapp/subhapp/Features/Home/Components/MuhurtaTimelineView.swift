//
//  MuhurtaTimelineView.swift
//  subhapp
//
//  Home Screen - Interactive heat map timeline
//

import SwiftUI

struct MuhurtaTimelineView: View {
    let panchanga: Panchanga?

    @State private var selectedHour: Int?

    var body: some View {
        VStack(spacing: Spacing.sm) {
            // Time labels
            HStack {
                Text("6 AM")
                Spacer()
                Text("12 PM")
                Spacer()
                Text("6 PM")
                Spacer()
                Text("12 AM")
            }
            .font(.shubhCaption)
            .foregroundStyle(Color.textTertiary)

            // Heat map bars
            GeometryReader { geometry in
                HStack(spacing: 2) {
                    ForEach(0..<24, id: \.self) { index in
                        let hour = (index + 6) % 24 // Start from 6 AM

                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorForHour(hour))
                            .frame(width: max(0, (geometry.size.width - 46) / 24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(selectedHour == hour ? Color.white : Color.clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    if selectedHour == hour {
                                        selectedHour = nil
                                    } else {
                                        selectedHour = hour
                                    }
                                }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                    }
                }
            }
            .frame(height: 44)

            // Current time indicator
            if selectedHour == nil {
                CurrentTimeIndicator()
            }

            // Selected hour detail
            if let hour = selectedHour, let muhurta = panchanga?.muhurtaAt(hour: hour) {
                SelectedHourDetail(hour: hour, muhurta: muhurta)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Legend
            HStack(spacing: Spacing.md) {
                LegendItem(color: .muhurtaExcellent, label: "Excellent")
                LegendItem(color: .muhurtaGood, label: "Good")
                LegendItem(color: .muhurtaNeutral, label: "Neutral")
                LegendItem(color: .muhurtaAvoid, label: "Avoid")
            }
            .font(.shubhCaption)
            .padding(.top, Spacing.xs)
        }
        .padding(Spacing.cardPadding)
        .glassCard()
    }

    // MARK: - Color for Hour

    private func colorForHour(_ hour: Int) -> Color {
        guard let muhurta = panchanga?.muhurtaAt(hour: hour) else {
            return Color.muhurtaNeutral.opacity(0.3)
        }

        return muhurta.color
    }
}

// MARK: - Current Time Indicator
struct CurrentTimeIndicator: View {
    var body: some View {
        HStack(spacing: Spacing.xs) {
            Circle()
                .fill(Color.shubhSaffron)
                .frame(width: 8, height: 8)

            Text("Now: \(Date().formatted(date: .omitted, time: .shortened))")
                .font(.shubhCaption)
                .foregroundStyle(Color.textSecondary)

            Text("•")
                .foregroundStyle(Color.textTertiary)

            Text("Tap timeline for details")
                .font(.shubhCaption)
                .foregroundStyle(Color.textTertiary)
        }
    }
}

// MARK: - Selected Hour Detail
struct SelectedHourDetail: View {
    let hour: Int
    let muhurta: Muhurta

    var body: some View {
        HStack {
            Image(systemName: muhurta.type.icon)
                .foregroundStyle(muhurta.color)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(formattedHour): \(muhurta.name)")
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textPrimary)

                Text(muhurta.type.description)
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            // Score badge
            Text(String(format: "%.0f", muhurta.auspiciousnessScore))
                .font(.shubhCaption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.surfacePrimary)
                .padding(.horizontal, Spacing.xs)
                .padding(.vertical, 4)
                .background(muhurta.color)
                .clipShape(Capsule())
        }
        .padding(Spacing.sm)
        .background(Color.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var formattedHour: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"

        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }
}

// MARK: - Legend Item
struct LegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(label)
                .foregroundStyle(Color.textTertiary)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        MuhurtaTimelineView(panchanga: MockPanchangaService.shared.getPanchanga(for: Date()))
            .padding()
    }
}
