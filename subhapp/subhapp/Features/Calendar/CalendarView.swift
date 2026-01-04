//
//  CalendarView.swift
//  subhapp
//
//  Calendar Screen - Month view with heat map overlay
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.surfacePrimary.ignoresSafeArea()

                VStack(spacing: Spacing.lg) {
                    Spacer()

                    Image(systemName: "calendar")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.shubhSaffron)

                    Text("Calendar")
                        .font(.shubhTitle1)
                        .foregroundStyle(Color.textPrimary)

                    Text("Coming in V1.0")
                        .font(.shubhBody)
                        .foregroundStyle(Color.textSecondary)

                    Spacer()
                }
            }
            .navigationTitle("Calendar")
        }
    }
}

#Preview {
    CalendarView()
}
