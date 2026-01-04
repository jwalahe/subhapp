//
//  SectionHeader.swift
//  subhapp
//
//  Design System - Section Header Component
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var action: (() -> Void)? = nil
    var actionLabel: String? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.shubhHeadline)
                .foregroundStyle(Color.textPrimary)

            Spacer()

            if let action = action, let actionLabel = actionLabel {
                Button {
                    action()
                } label: {
                    Text(actionLabel)
                        .font(.shubhSubheadline)
                        .foregroundStyle(Color.shubhSaffron)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        VStack(spacing: Spacing.lg) {
            SectionHeader(title: "Today's Timeline")

            SectionHeader(
                title: "Upcoming Windows",
                action: { print("See all tapped") },
                actionLabel: "See All"
            )
        }
        .padding(Spacing.lg)
    }
}
