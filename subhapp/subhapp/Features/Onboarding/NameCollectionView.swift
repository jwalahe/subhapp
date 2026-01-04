//
//  NameCollectionView.swift
//  subhapp
//
//  Onboarding Page 2 - Personalization with name
//

import SwiftUI

struct NameCollectionView: View {
    @Binding var name: String
    let onContinue: () -> Void

    @FocusState private var isNameFocused: Bool

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Icon
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 60))
                .foregroundStyle(Color.shubhSaffron)

            VStack(spacing: Spacing.md) {
                Text("Let's personalize\nyour experience")
                    .font(.shubhTitle1)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                Text("What should we call you?")
                    .font(.shubhBody)
                    .foregroundStyle(Color.textSecondary)
            }

            // Name input
            VStack(spacing: Spacing.sm) {
                TextField("", text: $name, prompt: Text("Enter your name").foregroundColor(Color.textTertiary))
                    .font(.shubhTitle2)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, Spacing.md)
                    .padding(.horizontal, Spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: Spacing.buttonCornerRadius)
                            .fill(Color.surfaceElevated)
                            .overlay(
                                RoundedRectangle(cornerRadius: Spacing.buttonCornerRadius)
                                    .stroke(isNameFocused ? Color.shubhSaffron : Color.clear, lineWidth: 2)
                            )
                    )
                    .focused($isNameFocused)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()

                Text("This helps us greet you personally")
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.horizontal, Spacing.xl)

            Spacer()
            Spacer()

            // Continue button
            VStack(spacing: Spacing.sm) {
                ShubhButton(title: "Continue") {
                    isNameFocused = false
                    onContinue()
                }

                Button {
                    isNameFocused = false
                    onContinue()
                } label: {
                    Text("Skip for now")
                        .font(.shubhSubheadline)
                        .foregroundStyle(Color.textTertiary)
                }
                .padding(.top, Spacing.xs)
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isNameFocused = true
            }
        }
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

        NameCollectionView(name: .constant(""), onContinue: {})
    }
}
