//
//  SearchView.swift
//  subhapp
//
//  Search Screen - Find auspicious times for activities
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.surfacePrimary.ignoresSafeArea()

                VStack(spacing: Spacing.lg) {
                    Spacer()

                    Image(systemName: "sparkle.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.shubhSaffron)

                    Text("Find Muhurta")
                        .font(.shubhTitle1)
                        .foregroundStyle(Color.textPrimary)

                    Text("Coming in V1.0")
                        .font(.shubhBody)
                        .foregroundStyle(Color.textSecondary)

                    Spacer()
                }
            }
            .navigationTitle("Find Muhurta")
        }
    }
}

#Preview {
    SearchView()
}
