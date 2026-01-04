//
//  subhappApp.swift
//  subhapp
//
//  Main App Entry Point
//

import SwiftUI

@main
struct subhappApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingContainerView()
            }
        }
    }
}
