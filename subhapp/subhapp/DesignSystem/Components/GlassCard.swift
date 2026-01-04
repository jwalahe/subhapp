//
//  GlassCard.swift
//  subhapp
//
//  Design System - Glass Card Component
//

import SwiftUI

// MARK: - Glass Card Modifier
struct GlassCardStyle: ViewModifier {
    var cornerRadius: CGFloat = Spacing.cardCornerRadius

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.glassBorder, lineWidth: 1)
                    )
            )
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = Spacing.cardCornerRadius) -> some View {
        modifier(GlassCardStyle(cornerRadius: cornerRadius))
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        // Background gradient to show glass effect
        LinearGradient(
            colors: [Color.shubhDeepPurple, Color.surfacePrimary],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        VStack(spacing: Spacing.lg) {
            // Example glass card
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Glass Card Example")
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.textPrimary)

                Text("This card uses the glassmorphism effect")
                    .font(.shubhBody)
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(Spacing.cardPadding)
            .glassCard()
            .padding(.horizontal, Spacing.md)
        }
    }
}
