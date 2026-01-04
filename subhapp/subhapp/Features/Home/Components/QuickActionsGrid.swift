//
//  QuickActionsGrid.swift
//  subhapp
//
//  Home Screen - Quick action shortcuts for activities
//

import SwiftUI

struct QuickActionsGrid: View {
    var onActivitySelected: ((Activity) -> Void)?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.sm) {
            ForEach(Activity.popular) { activity in
                QuickActionButton(activity: activity) {
                    onActivitySelected?(activity)
                }
            }
        }
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let activity: Activity
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        } label: {
            VStack(spacing: Spacing.xs) {
                // Emoji
                Text(activity.emoji)
                    .font(.system(size: 28))

                // Label
                Text(activity.displayName)
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.sm)
            .padding(.horizontal, Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.surfaceElevated)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        VStack {
            SectionHeader(title: "Find Auspicious Time For")

            QuickActionsGrid { activity in
                print("Selected: \(activity.displayName)")
            }
        }
        .padding()
    }
}
