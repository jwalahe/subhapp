//
//  HomeView.swift
//  subhapp
//
//  Home Screen - Daily summary at a glance
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.surfacePrimary.ignoresSafeArea()

                VStack(spacing: Spacing.lg) {
                    Spacer()

                    Image(systemName: "sun.horizon.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.shubhGold)

                    Text("Home")
                        .font(.shubhTitle1)
                        .foregroundStyle(Color.textPrimary)

                    Text("Coming in Phase 5")
                        .font(.shubhBody)
                        .foregroundStyle(Color.textSecondary)

                    Spacer()
                }
            }
            .navigationTitle(greeting)
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default: return "Namaste"
        }
    }
}

#Preview {
    HomeView()
}
