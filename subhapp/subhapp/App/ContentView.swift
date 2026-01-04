//
//  ContentView.swift
//  subhapp
//
//  Root Navigation Container - Tab-based navigation
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable {
        case home = "Home"
        case calendar = "Calendar"
        case search = "Find"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .home: return "sun.horizon.fill"
            case .calendar: return "calendar"
            case .search: return "sparkle.magnifyingglass"
            case .settings: return "gearshape.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.rawValue, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)

            CalendarView()
                .tabItem {
                    Label(Tab.calendar.rawValue, systemImage: Tab.calendar.icon)
                }
                .tag(Tab.calendar)

            SearchView()
                .tabItem {
                    Label(Tab.search.rawValue, systemImage: Tab.search.icon)
                }
                .tag(Tab.search)

            SettingsView()
                .tabItem {
                    Label(Tab.settings.rawValue, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
        .tint(Color.shubhSaffron)
    }
}

#Preview {
    ContentView()
}
