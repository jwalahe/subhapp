//
//  ActivitySelectionGrid.swift
//  subhapp
//
//  Search - Activity selection grid
//

import SwiftUI

struct ActivitySelectionGrid: View {
    @Binding var selectedActivity: Activity?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.sm) {
            ForEach(Activity.popular) { activity in
                ActivitySelectionCard(
                    activity: activity,
                    isSelected: selectedActivity?.id == activity.id
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3)) {
                        if selectedActivity?.id == activity.id {
                            selectedActivity = nil
                        } else {
                            selectedActivity = activity
                        }
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
    }
}

// MARK: - Activity Selection Card
struct ActivitySelectionCard: View {
    let activity: Activity
    let isSelected: Bool

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text(activity.emoji)
                .font(.system(size: 24))

            Text(activity.displayName)
                .font(.shubhSubheadline)
                .foregroundStyle(isSelected ? Color.surfacePrimary : Color.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.shubhSaffron : Color.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.shubhSaffron : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        ActivitySelectionGrid(selectedActivity: .constant(nil))
            .padding()
    }
}
