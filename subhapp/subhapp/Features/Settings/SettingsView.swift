//
//  SettingsView.swift
//  subhapp
//
//  Settings Screen - App preferences and configuration
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.surfacePrimary.ignoresSafeArea()

                VStack(spacing: Spacing.lg) {
                    Spacer()

                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.shubhSaffron)

                    Text("Settings")
                        .font(.shubhTitle1)
                        .foregroundStyle(Color.textPrimary)

                    Text("Coming in Phase 6")
                        .font(.shubhBody)
                        .foregroundStyle(Color.textSecondary)

                    Spacer()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
