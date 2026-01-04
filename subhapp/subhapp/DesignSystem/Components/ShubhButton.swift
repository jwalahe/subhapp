//
//  ShubhButton.swift
//  subhapp
//
//  Design System - Primary Button Component
//

import SwiftUI

struct ShubhButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var style: ButtonStyle = .primary

    enum ButtonStyle {
        case primary
        case secondary
        case ghost
    }

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        } label: {
            Text(title)
                .font(.shubhHeadline)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Spacing.buttonCornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.buttonCornerRadius)
                        .stroke(borderColor, lineWidth: style == .ghost ? 1 : 0)
                )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.5)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return Color.surfacePrimary
        case .secondary:
            return Color.textPrimary
        case .ghost:
            return Color.shubhSaffron
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return Color.shubhSaffron
        case .secondary:
            return Color.surfaceElevated
        case .ghost:
            return Color.clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .ghost:
            return Color.shubhSaffron
        default:
            return Color.clear
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        VStack(spacing: Spacing.lg) {
            ShubhButton(title: "Primary Button", action: {})

            ShubhButton(title: "Secondary Button", action: {}, style: .secondary)

            ShubhButton(title: "Ghost Button", action: {}, style: .ghost)

            ShubhButton(title: "Disabled Button", action: {}, isEnabled: false)
        }
        .padding(Spacing.lg)
    }
}
