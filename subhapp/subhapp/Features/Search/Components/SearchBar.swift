//
//  SearchBar.swift
//  subhapp
//
//  Search - Custom search bar component
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    var onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(Color.textTertiary)

            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Color.textTertiary))
                .font(.shubhBody)
                .foregroundStyle(Color.textPrimary)
                .focused($isFocused)
                .submitLabel(.search)
                .onSubmit {
                    onSubmit?()
                }

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.textTertiary)
                }
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.surfaceElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color.shubhSaffron : Color.clear, lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        SearchBar(
            text: .constant(""),
            placeholder: "e.g., \"Best day to buy a car\""
        )
        .padding()
    }
}
