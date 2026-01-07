//
//  TimeRangeSlider.swift
//  subhapp
//
//  Search - Time range selection slider
//

import SwiftUI

struct TimeRangeSlider: View {
    @Binding var weeks: Double

    var body: some View {
        VStack(spacing: Spacing.sm) {
            HStack {
                Text("Search range:")
                    .font(.shubhSubheadline)
                    .foregroundStyle(Color.textSecondary)

                Spacer()

                Text(rangeLabel)
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.shubhSaffron)
            }

            Slider(value: $weeks, in: 1...8, step: 1)
                .tint(Color.shubhSaffron)

            HStack {
                Text("1 week")
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textTertiary)

                Spacer()

                Text("2 months")
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textTertiary)
            }
        }
        .padding(Spacing.cardPadding)
        .glassCard()
    }

    private var rangeLabel: String {
        let weeksInt = Int(weeks)
        if weeksInt == 1 {
            return "1 week"
        } else if weeksInt < 4 {
            return "\(weeksInt) weeks"
        } else {
            let months = weeksInt / 4
            let remainingWeeks = weeksInt % 4
            if remainingWeeks == 0 {
                return months == 1 ? "1 month" : "\(months) months"
            } else {
                return "\(months) month\(months > 1 ? "s" : "") \(remainingWeeks) week\(remainingWeeks > 1 ? "s" : "")"
            }
        }
    }
}

#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        TimeRangeSlider(weeks: .constant(2))
            .padding()
    }
}
