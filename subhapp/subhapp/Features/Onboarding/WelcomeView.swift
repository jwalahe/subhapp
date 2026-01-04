//
//  WelcomeView.swift
//  subhapp
//
//  Onboarding Page 1 - Welcome screen
//

import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Animated sun icon
            ZStack {
                // Glow effect
                Circle()
                    .fill(Color.shubhGold.opacity(0.2))
                    .frame(width: 160, height: 160)
                    .blur(radius: 30)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)

                Image(systemName: "sun.horizon.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.shubhGold, Color.shubhSaffron],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color.shubhGold.opacity(0.5), radius: 20)
            }

            VStack(spacing: Spacing.md) {
                Text("Welcome to Shubh")
                    .font(.shubhLargeTitle)
                    .foregroundStyle(Color.textPrimary)

                Text("Align your important moments\nwith auspicious times")
                    .font(.shubhBody)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            Spacer()

            // Feature highlights
            VStack(spacing: Spacing.md) {
                FeatureRow(icon: "calendar.badge.clock", text: "Daily panchanga at a glance")
                FeatureRow(icon: "sparkle.magnifyingglass", text: "Find auspicious times for any activity")
                FeatureRow(icon: "bell.badge", text: "Never miss a favorable muhurta")
            }
            .padding(.horizontal, Spacing.xl)

            Spacer()

            // Continue button
            ShubhButton(title: "Begin Your Journey") {
                onContinue()
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(Color.shubhSaffron)
                .frame(width: 32)

            Text(text)
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textSecondary)

            Spacer()
        }
        .padding(.vertical, Spacing.xs)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.shubhDeepPurple, Color.surfacePrimary],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        WelcomeView(onContinue: {})
    }
}
