//
//  CommitmentView.swift
//  subhapp
//
//  Onboarding Page 5 - Fabulous-inspired commitment
//

import SwiftUI

struct CommitmentView: View {
    let userName: String
    let onComplete: () -> Void

    @State private var commitmentChecked = false
    @State private var showLetter = false

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            // Letter/scroll metaphor
            VStack(spacing: Spacing.lg) {
                // Header with decorative element
                HStack {
                    Rectangle()
                        .fill(Color.shubhGold)
                        .frame(width: 40, height: 2)

                    Image(systemName: "sparkle")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.shubhGold)

                    Rectangle()
                        .fill(Color.shubhGold)
                        .frame(width: 40, height: 2)
                }

                Text("A Note from\nAncient Wisdom")
                    .font(.shubhTitle2)
                    .foregroundStyle(Color.shubhGold)
                    .multilineTextAlignment(.center)

                // Letter content
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Dear \(userName.isEmpty ? "Seeker" : userName),")
                        .font(.shubhHeadline)
                        .foregroundStyle(Color.textPrimary)

                    Text(letterContent)
                        .font(.shubhBody)
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(6)

                    // Signature
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("With blessings,")
                                .font(.shubhSubheadline)
                                .italic()
                            Text("The Shubh Team")
                                .font(.shubhHeadline)
                                .foregroundStyle(Color.shubhSaffron)
                        }
                    }
                    .padding(.top, Spacing.sm)
                }
            }
            .padding(Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: Spacing.cardCornerRadius)
                    .fill(Color.surfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: Spacing.cardCornerRadius)
                            .stroke(Color.shubhGold.opacity(0.3), lineWidth: 1)
                    )
            )
            .padding(.horizontal, Spacing.md)
            .opacity(showLetter ? 1 : 0)
            .offset(y: showLetter ? 0 : 20)

            Spacer()

            // Commitment checkbox
            Button {
                withAnimation(.spring(response: 0.3)) {
                    commitmentChecked.toggle()
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Image(systemName: commitmentChecked ? "checkmark.square.fill" : "square")
                        .font(.title2)
                        .foregroundStyle(commitmentChecked ? Color.shubhSaffron : Color.textTertiary)
                        .animation(.spring(response: 0.2), value: commitmentChecked)

                    Text("I commit to consulting auspicious times before important life decisions")
                        .font(.shubhSubheadline)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, Spacing.lg)

            // Complete button
            ShubhButton(title: "Begin with Blessings", action: {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                onComplete()
            }, isEnabled: commitmentChecked)
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                showLetter = true
            }
        }
    }

    private var letterContent: String {
        """
        For thousands of years, our ancestors looked to the celestial dance of planets and the rhythm of the moon to guide their most important decisions.

        This ancient wisdom—passed down through generations of scholars and sages—is now at your fingertips.

        By consulting auspicious timings before significant moments, you join a timeless tradition that has blessed countless new beginnings, journeys, and ventures.

        May every muhurta bring you closer to your goals.
        """
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

        CommitmentView(userName: "Jwala", onComplete: {})
    }
}
