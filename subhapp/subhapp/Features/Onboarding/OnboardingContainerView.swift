//
//  OnboardingContainerView.swift
//  subhapp
//
//  Onboarding Flow - Fabulous-inspired 5-page emotional journey
//

import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("userName") private var userName = ""

    @State private var currentPage = 0
    @State private var localUserName = ""

    private let totalPages = 5

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.shubhDeepPurple, Color.surfacePrimary],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Page content
            TabView(selection: $currentPage) {
                // Page 1: Welcome
                WelcomeView {
                    goToNextPage()
                }
                .tag(0)

                // Page 2: Name Collection
                NameCollectionView(name: $localUserName) {
                    userName = localUserName
                    goToNextPage()
                }
                .tag(1)

                // Page 3: Location Permission
                LocationPermissionView {
                    goToNextPage()
                }
                .tag(2)

                // Page 4: Notification Permission
                NotificationPermissionView {
                    goToNextPage()
                }
                .tag(3)

                // Page 5: Commitment
                CommitmentView(userName: localUserName) {
                    completeOnboarding()
                }
                .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: currentPage)

            // Progress indicator
            VStack {
                Spacer()

                // Progress dots
                HStack(spacing: Spacing.xs) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.shubhSaffron : Color.white.opacity(0.3))
                            .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 120) // Above the button area
            }
        }
    }

    private func goToNextPage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentPage < totalPages - 1 {
                currentPage += 1
            }
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}

#Preview {
    OnboardingContainerView()
}
