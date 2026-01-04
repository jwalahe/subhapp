//
//  View+Extensions.swift
//  subhapp
//
//  SwiftUI View utility extensions
//

import SwiftUI

extension View {
    /// Hide view conditionally
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide {
            self.hidden()
        } else {
            self
        }
    }

    /// Apply modifier conditionally
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Standard screen background with pure black for OLED
    func screenBackground() -> some View {
        self.background(Color.surfacePrimary.ignoresSafeArea())
    }
}
