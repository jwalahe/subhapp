//
//  LocationPermissionView.swift
//  subhapp
//
//  Onboarding Page 3 - Location permission with context
//

import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    let onContinue: () -> Void

    @State private var locationStatus: CLAuthorizationStatus = .notDetermined
    @State private var isRequesting = false

    private let locationManager = CLLocationManager()

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Icon with globe
            ZStack {
                Circle()
                    .fill(Color.shubhSaffron.opacity(0.15))
                    .frame(width: 120, height: 120)

                Image(systemName: "location.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.shubhSaffron)
            }

            VStack(spacing: Spacing.md) {
                Text("Accurate Timings\nFor Your Location")
                    .font(.shubhTitle1)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Panchanga calculations depend on your geographical location. Sunrise, sunset, and muhurta timings vary by city.")
                    .font(.shubhBody)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, Spacing.md)
            }

            Spacer()

            // Benefits list
            VStack(alignment: .leading, spacing: Spacing.md) {
                BenefitRow(icon: "sunrise.fill", text: "Precise sunrise & sunset times")
                BenefitRow(icon: "clock.badge.checkmark.fill", text: "Accurate Rahu Kalam calculations")
                BenefitRow(icon: "sparkles", text: "Location-specific muhurta windows")
            }
            .padding(.horizontal, Spacing.xl)

            Spacer()

            // Permission buttons
            VStack(spacing: Spacing.sm) {
                if locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways {
                    // Already granted
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.muhurtaExcellent)
                        Text("Location access granted")
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.muhurtaExcellent)
                    }
                    .padding(.bottom, Spacing.sm)

                    ShubhButton(title: "Continue") {
                        onContinue()
                    }
                } else {
                    ShubhButton(title: "Enable Location Access") {
                        requestLocationPermission()
                    }
                    .disabled(isRequesting)

                    Button {
                        onContinue()
                    } label: {
                        Text("I'll set location manually")
                            .font(.shubhSubheadline)
                            .foregroundStyle(Color.textTertiary)
                    }
                    .padding(.top, Spacing.xs)
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
        .onAppear {
            checkLocationStatus()
        }
    }

    private func checkLocationStatus() {
        locationStatus = locationManager.authorizationStatus
    }

    private func requestLocationPermission() {
        isRequesting = true
        locationManager.requestWhenInUseAuthorization()

        // Check status after a delay (since we can't use delegate easily here)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            checkLocationStatus()
            isRequesting = false

            // Auto-continue if granted
            if locationStatus == .authorizedWhenInUse || locationStatus == .authorizedAlways {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onContinue()
                }
            }
        }
    }
}

// MARK: - Benefit Row Component
struct BenefitRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Color.shubhGold)
                .frame(width: 28)

            Text(text)
                .font(.shubhSubheadline)
                .foregroundStyle(Color.textSecondary)

            Spacer()
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

        LocationPermissionView(onContinue: {})
    }
}
