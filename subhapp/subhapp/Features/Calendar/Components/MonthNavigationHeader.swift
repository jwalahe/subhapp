//
//  MonthNavigationHeader.swift
//  subhapp
//
//  Calendar - Month navigation with arrows
//

import SwiftUI

struct MonthNavigationHeader: View {
    let monthYearString: String
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onToday: () -> Void

    var body: some View {
        HStack {
            // Previous month button
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onPrevious()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.shubhSaffron)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            // Month/Year title
            Text(monthYearString)
                .font(.shubhTitle2)
                .foregroundStyle(Color.textPrimary)

            Spacer()

            // Next month button
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onNext()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.shubhSaffron)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, Spacing.sm)
    }
}

#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        MonthNavigationHeader(
            monthYearString: "January 2026",
            onPrevious: {},
            onNext: {},
            onToday: {}
        )
    }
}
