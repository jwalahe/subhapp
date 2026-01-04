//
//  OnboardingContainerView.swift
//  subhapp
//
//  Onboarding Flow - Fabulous-inspired emotional journey
//

import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.shubhDeepPurple, Color.surfacePrimary],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: Spacing.xl) {
                Spacer()

                // App icon placeholder
                Image(systemName: "sun.horizon.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color.shubhGold)
                    .shadow(color: Color.shubhGold.opacity(0.5), radius: 20)

                VStack(spacing: Spacing.md) {
                    Text("Welcome to Shubh")
                        .font(.shubhLargeTitle)
                        .foregroundStyle(Color.textPrimary)

                    Text("Your auspicious timing companion")
                        .font(.shubhBody)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Temporary: Skip to main app
                ShubhButton(title: "Get Started") {
                    hasCompletedOnboarding = true
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xxl)
            }
        }
    }
}

#Preview {
    OnboardingContainerView()
}
