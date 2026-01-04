# Shubh: SwiftUI Implementation Specification

> **Purpose**: This document provides detailed UI/UX specifications for building the Shubh app. It is designed to be consumed by an LLM or developer to generate production-quality SwiftUI code.

---

## Table of Contents
1. [Design System](#design-system)
2. [App Architecture](#app-architecture)
3. [Navigation Structure](#navigation-structure)
4. [Screen Specifications](#screen-specifications)
5. [Component Library](#component-library)
6. [Animations & Haptics](#animations--haptics)
7. [Data Models](#data-models)
8. [Widget Specifications](#widget-specifications)
9. [Notification Templates](#notification-templates)

---

## Design System

### Color Palette

```swift
// Colors.swift
extension Color {
    // Primary Brand Colors
    static let shubhSaffron = Color(hex: "#FF9933")      // Sacred saffron - accent
    static let shubhGold = Color(hex: "#FFD700")         // Auspicious gold - highlights
    static let shubhDeepPurple = Color(hex: "#4A1C6B")   // Spiritual purple - premium feel
    
    // Auspiciousness Gradient (for heat map)
    static let muhurtaExcellent = Color(hex: "#22C55E")  // Green - highly auspicious
    static let muhurtaGood = Color(hex: "#84CC16")       // Lime - good
    static let muhurtaNeutral = Color(hex: "#EAB308")    // Yellow - neutral
    static let muhurtaCaution = Color(hex: "#F97316")    // Orange - less favorable
    static let muhurtaAvoid = Color(hex: "#EF4444")      // Red - inauspicious (Rahu Kalam etc.)
    
    // Semantic Colors
    static let surfacePrimary = Color(hex: "#000000")    // Pure black for OLED
    static let surfaceElevated = Color(hex: "#1C1C1E")   // Elevated cards
    static let surfaceSecondary = Color(hex: "#2C2C2E") // Secondary surfaces
    static let textPrimary = Color(hex: "#FFFFFF")
    static let textSecondary = Color(hex: "#EBEBF5").opacity(0.6)
    static let textTertiary = Color(hex: "#EBEBF5").opacity(0.3)
    
    // Glass Effect Colors
    static let glassBackground = Color.white.opacity(0.15)
    static let glassBorder = Color.white.opacity(0.3)
}
```

### Typography Scale

```swift
// Typography.swift
extension Font {
    // Display - Hero moments
    static let shubhLargeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    
    // Headers
    static let shubhTitle1 = Font.system(size: 28, weight: .bold, design: .rounded)
    static let shubhTitle2 = Font.system(size: 22, weight: .bold, design: .rounded)
    static let shubhTitle3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    
    // Body
    static let shubhHeadline = Font.system(size: 17, weight: .semibold)
    static let shubhBody = Font.system(size: 17, weight: .regular)
    static let shubhCallout = Font.system(size: 16, weight: .regular)
    static let shubhSubheadline = Font.system(size: 15, weight: .regular)
    
    // Small
    static let shubhFootnote = Font.system(size: 13, weight: .regular)
    static let shubhCaption = Font.system(size: 12, weight: .regular)
    
    // Special - Telugu script support
    static let shubhTelugu = Font.custom("NotoSansTelugu-Regular", size: 17)
    static let shubhTeluguBold = Font.custom("NotoSansTelugu-Bold", size: 17)
}
```

### Spacing System

```swift
// Spacing.swift
enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    
    // Component-specific
    static let cardPadding: CGFloat = 20
    static let cardCornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 14
    static let iconSize: CGFloat = 24
    static let largeIconSize: CGFloat = 48
}
```

### Glass Card Style

```swift
// GlassCard.swift - Reusable modifier
struct GlassCardStyle: ViewModifier {
    var cornerRadius: CGFloat = 20
    
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
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassCardStyle(cornerRadius: cornerRadius))
    }
}
```

---

## App Architecture

### Project Structure

```
Shubh/
├── App/
│   ├── ShubhApp.swift              // @main entry point
│   ├── AppDelegate.swift           // Push notifications setup
│   └── ContentView.swift           // Root navigation container
│
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│   │   └── Components/
│   │       ├── TodaySummaryCard.swift
│   │       ├── MuhurtaTimelineView.swift
│   │       └── QuickActionsGrid.swift
│   │
│   ├── Calendar/
│   │   ├── CalendarView.swift
│   │   ├── CalendarViewModel.swift
│   │   ├── MonthGridView.swift
│   │   ├── DayDetailSheet.swift
│   │   └── HeatMapOverlay.swift
│   │
│   ├── Search/
│   │   ├── SearchView.swift
│   │   ├── SearchViewModel.swift
│   │   └── ActivitySuggestionView.swift
│   │
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── LocationSettingsView.swift
│   │   ├── NotificationSettingsView.swift
│   │   └── CalendarIntegrationView.swift
│   │
│   └── Onboarding/
│       ├── OnboardingContainerView.swift
│       ├── WelcomeView.swift
│       ├── LocationPermissionView.swift
│       ├── NotificationPermissionView.swift
│       └── CommitmentView.swift
│
├── Core/
│   ├── Models/
│   │   ├── Panchanga.swift
│   │   ├── Muhurta.swift
│   │   ├── Activity.swift
│   │   └── UserPreferences.swift
│   │
│   ├── Services/
│   │   ├── PanchangaService.swift      // RAG/API integration
│   │   ├── CalendarService.swift       // EventKit wrapper
│   │   ├── NotificationService.swift
│   │   └── LocationService.swift
│   │
│   └── Extensions/
│       ├── Date+Extensions.swift
│       ├── Color+Hex.swift
│       └── View+Extensions.swift
│
├── DesignSystem/
│   ├── Colors.swift
│   ├── Typography.swift
│   ├── Spacing.swift
│   └── Components/
│       ├── GlassCard.swift
│       ├── ShubhButton.swift
│       ├── MuhurtaBadge.swift
│       └── TimeBlockView.swift
│
├── Resources/
│   ├── Assets.xcassets
│   ├── Localizable.strings
│   └── Sounds/
│       ├── bell_gentle.wav
│       └── success_chime.wav
│
└── Widgets/
    ├── ShubhWidget.swift
    ├── TodayMuhurtaWidget.swift
    └── WidgetEntryView.swift
```

### State Management Pattern

```swift
// Use @Observable (iOS 17+) for ViewModels
@Observable
class HomeViewModel {
    var todayPanchanga: Panchanga?
    var currentMuhurta: Muhurta?
    var upcomingFavorableWindows: [MuhurtaWindow] = []
    var isLoading = false
    var errorMessage: String?
    
    private let panchangaService: PanchangaService
    
    init(panchangaService: PanchangaService = .shared) {
        self.panchangaService = panchangaService
    }
    
    func loadTodayData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            todayPanchanga = try await panchangaService.getPanchanga(for: Date())
            currentMuhurta = todayPanchanga?.currentMuhurta(at: Date())
            upcomingFavorableWindows = todayPanchanga?.favorableWindows() ?? []
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

---

## Navigation Structure

### Tab Bar Configuration

```swift
// ContentView.swift
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
```

---

## Screen Specifications

### 1. Home Screen (HomeView.swift)

**Purpose**: Glanceable daily summary - answer "what do I need to know NOW" in 3 seconds

**Layout Structure**:
```
┌─────────────────────────────────────────┐
│  [Greeting + Date]              [Bell]  │  ← Navigation bar
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │     TODAY'S ENERGY SUMMARY      │   │  ← Hero Card (Glass)
│  │                                 │   │
│  │  🟢 Generally Favorable         │   │
│  │                                 │   │
│  │  Tithi: Shukla Panchami        │   │
│  │  Nakshatra: Rohini             │   │
│  │  Yoga: Shubha                  │   │
│  └─────────────────────────────────┘   │
│                                         │
│  TIMELINE                               │
│  ┌─────────────────────────────────┐   │
│  │ 6AM ████████░░░░░░░░░░░ 12PM   │   │  ← Heat map timeline
│  │      ↑ Amrit Kalam              │   │
│  │ 12PM ░░░░████░░░░░░░░░░ 6PM    │   │
│  │          ↑ Rahu Kalam           │   │
│  │ 6PM  ░░░░░░░░████████░░ 12AM   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  UPCOMING FAVORABLE WINDOWS             │
│  ┌──────────┐ ┌──────────┐             │
│  │ Tomorrow │ │ Jan 18   │             │  ← Horizontal scroll
│  │ 6-8 AM   │ │ 2-4 PM   │             │
│  │ Travel ✓ │ │ Purchase │             │
│  └──────────┘ └──────────┘             │
│                                         │
│  QUICK ACTIONS                          │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐          │
│  │🛫 │ │🛒 │ │📝 │ │💼 │          │  ← Activity shortcuts
│  │Travel│ │Buy │ │Sign│ │Meet│          │
│  └────┘ └────┘ └────┘ └────┘          │
│                                         │
└─────────────────────────────────────────┘
```

**SwiftUI Implementation**:

```swift
// HomeView.swift
struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var showNotificationSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Hero Summary Card
                    TodaySummaryCard(panchanga: viewModel.todayPanchanga)
                    
                    // Timeline Section
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "Today's Timeline")
                        MuhurtaTimelineView(panchanga: viewModel.todayPanchanga)
                    }
                    
                    // Upcoming Windows
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "Upcoming Favorable Windows")
                        UpcomingWindowsCarousel(windows: viewModel.upcomingFavorableWindows)
                    }
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "Find Auspicious Time For")
                        QuickActionsGrid()
                    }
                }
                .padding(.horizontal, Spacing.md)
            }
            .background(Color.surfacePrimary)
            .navigationTitle(greeting)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNotificationSheet = true
                    } label: {
                        Image(systemName: "bell.badge")
                            .foregroundStyle(Color.shubhSaffron)
                    }
                }
            }
        }
        .task {
            await viewModel.loadTodayData()
        }
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default: return "Namaste"
        }
    }
}
```

**TodaySummaryCard Component**:

```swift
// TodaySummaryCard.swift
struct TodaySummaryCard: View {
    let panchanga: Panchanga?
    
    var body: some View {
        VStack(spacing: Spacing.md) {
            // Overall Energy Indicator
            HStack {
                Circle()
                    .fill(energyColor)
                    .frame(width: 12, height: 12)
                Text(energyText)
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
            }
            
            // Panchanga Details Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.sm) {
                PanchangaDetailRow(label: "Tithi", value: panchanga?.tithi.name ?? "—")
                PanchangaDetailRow(label: "Nakshatra", value: panchanga?.nakshatra.name ?? "—")
                PanchangaDetailRow(label: "Yoga", value: panchanga?.yoga.name ?? "—")
                PanchangaDetailRow(label: "Karana", value: panchanga?.karana.name ?? "—")
            }
            
            // Expandable for more details
            DisclosureGroup("View Full Panchanga") {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    PanchangaDetailRow(label: "Telugu Month", value: panchanga?.teluguMonth ?? "—")
                    PanchangaDetailRow(label: "Paksha", value: panchanga?.paksha ?? "—")
                    PanchangaDetailRow(label: "Vara", value: panchanga?.vara ?? "—")
                }
            }
            .font(.shubhSubheadline)
            .foregroundStyle(Color.textSecondary)
        }
        .padding(Spacing.cardPadding)
        .glassCard()
    }
    
    private var energyColor: Color {
        guard let score = panchanga?.overallAuspiciousnessScore else {
            return Color.muhurtaNeutral
        }
        switch score {
        case 8...10: return .muhurtaExcellent
        case 6..<8: return .muhurtaGood
        case 4..<6: return .muhurtaNeutral
        case 2..<4: return .muhurtaCaution
        default: return .muhurtaAvoid
        }
    }
    
    private var energyText: String {
        guard let score = panchanga?.overallAuspiciousnessScore else {
            return "Loading..."
        }
        switch score {
        case 8...10: return "Highly Auspicious Day"
        case 6..<8: return "Generally Favorable"
        case 4..<6: return "Mixed Energy"
        case 2..<4: return "Exercise Caution"
        default: return "Less Favorable"
        }
    }
}
```

**MuhurtaTimelineView Component** (Heat Map):

```swift
// MuhurtaTimelineView.swift
struct MuhurtaTimelineView: View {
    let panchanga: Panchanga?
    @State private var selectedHour: Int?
    
    var body: some View {
        VStack(spacing: Spacing.sm) {
            // Time labels
            HStack {
                Text("6 AM")
                Spacer()
                Text("12 PM")
                Spacer()
                Text("6 PM")
                Spacer()
                Text("12 AM")
            }
            .font(.shubhCaption)
            .foregroundStyle(Color.textTertiary)
            
            // Heat map bars
            GeometryReader { geometry in
                HStack(spacing: 2) {
                    ForEach(0..<24, id: \.self) { hour in
                        let adjustedHour = (hour + 6) % 24 // Start from 6 AM
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorForHour(adjustedHour))
                            .frame(width: (geometry.size.width - 46) / 24)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedHour = adjustedHour
                                }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                    }
                }
            }
            .frame(height: 40)
            
            // Selected hour detail
            if let hour = selectedHour, let muhurta = panchanga?.muhurtaAt(hour: hour) {
                HStack {
                    Image(systemName: muhurta.isAuspicious ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(muhurta.isAuspicious ? Color.muhurtaExcellent : Color.muhurtaAvoid)
                    Text("\(formattedHour(hour)): \(muhurta.name)")
                        .font(.shubhSubheadline)
                    Spacer()
                }
                .padding(Spacing.sm)
                .background(Color.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Legend
            HStack(spacing: Spacing.md) {
                LegendItem(color: .muhurtaExcellent, label: "Excellent")
                LegendItem(color: .muhurtaGood, label: "Good")
                LegendItem(color: .muhurtaNeutral, label: "Neutral")
                LegendItem(color: .muhurtaAvoid, label: "Avoid")
            }
            .font(.shubhCaption)
        }
        .padding(Spacing.cardPadding)
        .glassCard()
    }
    
    private func colorForHour(_ hour: Int) -> Color {
        guard let muhurta = panchanga?.muhurtaAt(hour: hour) else {
            return Color.muhurtaNeutral.opacity(0.3)
        }
        
        // Check for inauspicious periods first
        if muhurta.isRahuKalam || muhurta.isYamaganda || muhurta.isGulikaKalam {
            return Color.muhurtaAvoid
        }
        
        // Check for auspicious periods
        if muhurta.isAmritKalam || muhurta.isAbhijitMuhurta {
            return Color.muhurtaExcellent
        }
        
        // Score-based coloring
        switch muhurta.auspiciousnessScore {
        case 8...10: return .muhurtaExcellent
        case 6..<8: return .muhurtaGood
        case 4..<6: return .muhurtaNeutral
        case 2..<4: return .muhurtaCaution
        default: return .muhurtaAvoid
        }
    }
}
```

---

### 2. Calendar Screen (CalendarView.swift)

**Purpose**: Month view with heat map overlay showing auspiciousness at a glance

**Layout Structure**:
```
┌─────────────────────────────────────────┐
│  ←  January 2026  →            [Today]  │  ← Month navigation
├─────────────────────────────────────────┤
│                                         │
│  Sun Mon Tue Wed Thu Fri Sat            │
│  ┌───┬───┬───┬───┬───┬───┬───┐         │
│  │   │   │   │ 1 │ 2 │ 3 │ 4 │         │
│  │   │   │   │ 🟢│ 🟡│ 🟢│ 🔴│         │  ← Color dots = auspiciousness
│  ├───┼───┼───┼───┼───┼───┼───┤         │
│  │ 5 │ 6 │ 7 │ 8 │ 9 │10 │11 │         │
│  │ 🟡│ 🟢│ 🟢│ 🔴│ 🟡│ 🟢│ 🟢│         │
│  └───┴───┴───┴───┴───┴───┴───┘         │
│           ... more weeks ...            │
│                                         │
├─────────────────────────────────────────┤
│  SELECTED: January 15, 2026             │
│  ┌─────────────────────────────────┐   │
│  │  Shukla Panchami | Rohini       │   │  ← Day detail card
│  │                                 │   │
│  │  ✓ Good for: Travel, Purchases │   │
│  │  ✗ Avoid: Surgery (Rahu 2-3PM) │   │
│  │                                 │   │
│  │  [View Full Day] [Add to Cal]  │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

**SwiftUI Implementation**:

```swift
// CalendarView.swift
struct CalendarView: View {
    @State private var viewModel = CalendarViewModel()
    @State private var selectedDate: Date = Date()
    @State private var displayedMonth: Date = Date()
    @State private var showDayDetail = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Month Navigation Header
                MonthNavigationHeader(
                    displayedMonth: $displayedMonth,
                    onTodayTap: { 
                        withAnimation { selectedDate = Date() }
                    }
                )
                
                // Calendar Grid with Heat Map
                MonthGridView(
                    month: displayedMonth,
                    selectedDate: $selectedDate,
                    panchangaData: viewModel.monthData
                )
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {
                                withAnimation { displayedMonth = displayedMonth.nextMonth }
                            } else if value.translation.width > 50 {
                                withAnimation { displayedMonth = displayedMonth.previousMonth }
                            }
                        }
                )
                
                Divider()
                    .padding(.vertical, Spacing.sm)
                
                // Selected Day Summary
                DayPreviewCard(
                    date: selectedDate,
                    panchanga: viewModel.panchanga(for: selectedDate),
                    onViewFullDay: { showDayDetail = true }
                )
                .padding(.horizontal, Spacing.md)
                
                Spacer()
            }
            .background(Color.surfacePrimary)
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showDayDetail) {
                DayDetailSheet(
                    date: selectedDate,
                    panchanga: viewModel.panchanga(for: selectedDate)
                )
            }
        }
        .task {
            await viewModel.loadMonth(displayedMonth)
        }
        .onChange(of: displayedMonth) { _, newMonth in
            Task { await viewModel.loadMonth(newMonth) }
        }
    }
}

// MonthGridView.swift
struct MonthGridView: View {
    let month: Date
    @Binding var selectedDate: Date
    let panchangaData: [Date: Panchanga]
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: Spacing.xs) {
            // Weekday headers
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.shubhCaption)
                        .foregroundStyle(Color.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Days grid
            LazyVGrid(columns: columns, spacing: Spacing.xs) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            isToday: Calendar.current.isDateInToday(date),
                            panchanga: panchangaData[date.startOfDay]
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDate = date
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    } else {
                        Color.clear
                            .frame(height: 50)
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.md)
    }
}

// DayCell.swift
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let panchanga: Panchanga?
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.shubhBody)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundStyle(isSelected ? Color.surfacePrimary : Color.textPrimary)
            
            // Auspiciousness indicator dot
            Circle()
                .fill(auspiciousnessColor)
                .frame(width: 6, height: 6)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.shubhSaffron : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isToday ? Color.shubhSaffron : Color.clear, lineWidth: 2)
        )
    }
    
    private var auspiciousnessColor: Color {
        guard let score = panchanga?.overallAuspiciousnessScore else {
            return Color.textTertiary
        }
        switch score {
        case 7...10: return .muhurtaExcellent
        case 5..<7: return .muhurtaGood
        case 3..<5: return .muhurtaNeutral
        default: return .muhurtaCaution
        }
    }
}
```

---

### 3. Search/Find Screen (SearchView.swift)

**Purpose**: Natural language query for finding auspicious times for specific activities

**Layout Structure**:
```
┌─────────────────────────────────────────┐
│  Find Auspicious Time                   │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🔍 "Best day for car purchase"  │   │  ← Search bar
│  └─────────────────────────────────┘   │
│                                         │
│  POPULAR ACTIVITIES                     │
│  ┌────────────────┐ ┌────────────────┐ │
│  │ 🛫 Travel      │ │ 🏠 Moving      │ │
│  └────────────────┘ └────────────────┘ │
│  ┌────────────────┐ ┌────────────────┐ │
│  │ 🛒 Major       │ │ 📝 Sign        │ │
│  │    Purchase    │ │    Documents   │ │
│  └────────────────┘ └────────────────┘ │
│  ┌────────────────┐ ┌────────────────┐ │
│  │ 💼 Important   │ │ 🚗 Vehicle     │ │
│  │    Meeting     │ │    Purchase    │ │
│  └────────────────┘ └────────────────┘ │
│                                         │
│  TIME RANGE                             │
│  ┌─────────────────────────────────┐   │
│  │  Next 2 weeks  ←──●──────────→  │   │  ← Slider (1 week to 2 months)
│  └─────────────────────────────────┘   │
│                                         │
│  [Search]                               │
│                                         │
└─────────────────────────────────────────┘

// After search:
┌─────────────────────────────────────────┐
│  Best days for Car Purchase             │
│  Next 2 weeks                           │
├─────────────────────────────────────────┤
│                                         │
│  ⭐ TOP RECOMMENDATION                  │
│  ┌─────────────────────────────────┐   │
│  │  Saturday, Jan 18               │   │
│  │  ━━━━━━━━━━━━━━━━━━━━━ 9.2/10   │   │
│  │                                 │   │
│  │  Shukla Saptami | Rohini       │   │
│  │  Amrit Kalam: 10:30 AM - 12 PM │   │
│  │                                 │   │
│  │  ✓ Excellent for purchases     │   │
│  │  ✓ No Rahu Kalam conflict      │   │
│  │  ✓ Venus well-positioned       │   │
│  │                                 │   │
│  │  [Add to Calendar] [Share]     │   │
│  └─────────────────────────────────┘   │
│                                         │
│  OTHER GOOD OPTIONS                     │
│  ┌──────────────┐ ┌──────────────┐     │
│  │ Thu, Jan 16  │ │ Sun, Jan 19  │     │
│  │ 8.4/10       │ │ 7.8/10       │     │
│  └──────────────┘ └──────────────┘     │
│                                         │
└─────────────────────────────────────────┘
```

**SwiftUI Implementation**:

```swift
// SearchView.swift
struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var selectedActivity: Activity?
    @State private var timeRangeWeeks: Double = 2
    @State private var showResults = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    // Search Bar
                    SearchBar(text: $searchText, placeholder: "e.g., \"Best day to buy a car\"")
                    
                    if !showResults {
                        // Activity Selection
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            SectionHeader(title: "Popular Activities")
                            ActivityGrid(
                                selectedActivity: $selectedActivity,
                                activities: Activity.popular
                            )
                        }
                        
                        // Time Range Slider
                        VStack(alignment: .leading, spacing: Spacing.sm) {
                            SectionHeader(title: "Time Range")
                            TimeRangeSlider(weeks: $timeRangeWeeks)
                        }
                        
                        // Search Button
                        Button {
                            Task {
                                await performSearch()
                            }
                        } label: {
                            Text("Find Auspicious Times")
                                .font(.shubhHeadline)
                                .foregroundStyle(Color.surfacePrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Spacing.md)
                                .background(Color.shubhSaffron)
                                .clipShape(RoundedRectangle(cornerRadius: Spacing.buttonCornerRadius))
                        }
                        .disabled(selectedActivity == nil && searchText.isEmpty)
                        .opacity((selectedActivity == nil && searchText.isEmpty) ? 0.5 : 1)
                        
                    } else {
                        // Results View
                        SearchResultsView(
                            results: viewModel.searchResults,
                            activity: selectedActivity,
                            onAddToCalendar: { result in
                                await viewModel.addToCalendar(result)
                            },
                            onDismiss: {
                                withAnimation { showResults = false }
                            }
                        )
                    }
                }
                .padding(.horizontal, Spacing.md)
            }
            .background(Color.surfacePrimary)
            .navigationTitle("Find Muhurta")
        }
    }
    
    private func performSearch() async {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        await viewModel.search(
            activity: selectedActivity,
            query: searchText,
            weeks: Int(timeRangeWeeks)
        )
        withAnimation(.spring(response: 0.4)) {
            showResults = true
        }
    }
}

// ActivityGrid.swift
struct ActivityGrid: View {
    @Binding var selectedActivity: Activity?
    let activities: [Activity]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.sm) {
            ForEach(activities) { activity in
                ActivityCard(
                    activity: activity,
                    isSelected: selectedActivity == activity
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3)) {
                        if selectedActivity == activity {
                            selectedActivity = nil
                        } else {
                            selectedActivity = activity
                        }
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
        }
    }
}

// ActivityCard.swift
struct ActivityCard: View {
    let activity: Activity
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text(activity.emoji)
                .font(.system(size: 24))
            
            Text(activity.displayName)
                .font(.shubhSubheadline)
                .foregroundStyle(isSelected ? Color.surfacePrimary : Color.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.shubhSaffron : Color.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.shubhSaffron : Color.clear, lineWidth: 2)
        )
    }
}

// SearchResultCard.swift (Top Recommendation)
struct SearchResultCard: View {
    let result: MuhurtaSearchResult
    let isTopPick: Bool
    let onAddToCalendar: () async -> Void
    
    @State private var isAddingToCalendar = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header with date and score
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if isTopPick {
                        Label("Top Recommendation", systemImage: "star.fill")
                            .font(.shubhCaption)
                            .foregroundStyle(Color.shubhGold)
                    }
                    Text(result.date.formatted(.dateTime.weekday(.wide).month().day()))
                        .font(.shubhTitle3)
                        .foregroundStyle(Color.textPrimary)
                }
                
                Spacer()
                
                // Auspiciousness Score Ring
                ScoreRing(score: result.score)
            }
            
            // Panchanga summary
            HStack {
                Text(result.panchanga.tithi.name)
                Text("|")
                    .foregroundStyle(Color.textTertiary)
                Text(result.panchanga.nakshatra.name)
            }
            .font(.shubhSubheadline)
            .foregroundStyle(Color.textSecondary)
            
            // Key timing
            if let amritKalam = result.panchanga.amritKalam {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(Color.shubhGold)
                    Text("Amrit Kalam: \(amritKalam.formatted)")
                        .font(.shubhSubheadline)
                }
            }
            
            Divider()
            
            // Reasons
            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(result.positiveReasons, id: \.self) { reason in
                    Label(reason, systemImage: "checkmark.circle.fill")
                        .font(.shubhFootnote)
                        .foregroundStyle(Color.muhurtaExcellent)
                }
                ForEach(result.cautionReasons, id: \.self) { reason in
                    Label(reason, systemImage: "exclamationmark.triangle.fill")
                        .font(.shubhFootnote)
                        .foregroundStyle(Color.muhurtaCaution)
                }
            }
            
            // Action buttons
            HStack(spacing: Spacing.sm) {
                Button {
                    Task {
                        isAddingToCalendar = true
                        await onAddToCalendar()
                        isAddingToCalendar = false
                    }
                } label: {
                    Label("Add to Calendar", systemImage: "calendar.badge.plus")
                        .font(.shubhSubheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.sm)
                        .background(Color.shubhSaffron)
                        .foregroundStyle(Color.surfacePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(isAddingToCalendar)
                
                ShareLink(item: result.shareText) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.shubhSubheadline)
                        .padding(Spacing.sm)
                        .background(Color.surfaceSecondary)
                        .foregroundStyle(Color.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(Spacing.cardPadding)
        .glassCard()
    }
}

// ScoreRing.swift
struct ScoreRing: View {
    let score: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.surfaceSecondary, lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: score / 10)
                .stroke(scoreColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 0) {
                Text(String(format: "%.1f", score))
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.textPrimary)
                Text("/10")
                    .font(.shubhCaption)
                    .foregroundStyle(Color.textTertiary)
            }
        }
        .frame(width: 56, height: 56)
    }
    
    private var scoreColor: Color {
        switch score {
        case 8...10: return .muhurtaExcellent
        case 6..<8: return .muhurtaGood
        case 4..<6: return .muhurtaNeutral
        default: return .muhurtaCaution
        }
    }
}
```

---

### 4. Settings Screen (SettingsView.swift)

```swift
// SettingsView.swift
struct SettingsView: View {
    @AppStorage("locationName") private var locationName = "Milwaukee, WI"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("morningNotificationTime") private var morningNotificationHour = 7
    
    var body: some View {
        NavigationStack {
            List {
                // Location Section
                Section {
                    NavigationLink {
                        LocationSettingsView()
                    } label: {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundStyle(Color.shubhSaffron)
                            VStack(alignment: .leading) {
                                Text("Location")
                                Text(locationName)
                                    .font(.shubhCaption)
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                } header: {
                    Text("Panchanga Calculation")
                }
                
                // Notifications Section
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(Color.shubhSaffron)
                            Text("Daily Summary")
                        }
                    }
                    .tint(Color.shubhSaffron)
                    
                    if notificationsEnabled {
                        Stepper(value: $morningNotificationHour, in: 5...10) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(Color.shubhSaffron)
                                Text("Notify at \(morningNotificationHour):00 AM")
                            }
                        }
                    }
                } header: {
                    Text("Notifications")
                }
                
                // Calendar Integration
                Section {
                    NavigationLink {
                        CalendarIntegrationView()
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(Color.shubhSaffron)
                            Text("Apple Calendar")
                        }
                    }
                } header: {
                    Text("Integrations")
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Link(destination: URL(string: "https://shubhapp.com/privacy")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(Color.textTertiary)
                        }
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
```

---

### 5. Onboarding Flow (OnboardingContainerView.swift)

**Design Philosophy**: Fabulous-inspired emotional journey, not just permission collection

```swift
// OnboardingContainerView.swift
struct OnboardingContainerView: View {
    @State private var currentPage = 0
    @State private var userName = ""
    @State private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.shubhDeepPurple, Color.surfacePrimary],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                // Page 1: Welcome
                WelcomeView(onContinue: { currentPage = 1 })
                    .tag(0)
                
                // Page 2: Name Collection (Personalization)
                NameCollectionView(
                    name: $userName,
                    onContinue: { currentPage = 2 }
                )
                .tag(1)
                
                // Page 3: Location Permission (with context)
                LocationPermissionView(onContinue: { currentPage = 3 })
                    .tag(2)
                
                // Page 4: Notification Permission (with value prop)
                NotificationPermissionView(onContinue: { currentPage = 4 })
                    .tag(3)
                
                // Page 5: Commitment (Fabulous-style)
                CommitmentView(
                    userName: userName,
                    onComplete: { hasCompletedOnboarding = true }
                )
                .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            
            // Progress dots
            VStack {
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(index == currentPage ? Color.shubhSaffron : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .fullScreenCover(isPresented: $hasCompletedOnboarding) {
            ContentView()
        }
    }
}

// WelcomeView.swift
struct WelcomeView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            // App icon or illustration
            Image(systemName: "sun.horizon.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.shubhGold)
                .shadow(color: Color.shubhGold.opacity(0.5), radius: 20)
            
            VStack(spacing: Spacing.md) {
                Text("Welcome to Shubh")
                    .font(.shubhLargeTitle)
                    .foregroundStyle(Color.textPrimary)
                
                Text("Align your important moments\nwith auspicious times")
                    .font(.shubhBody)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // Continue button
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onContinue()
            } label: {
                Text("Begin Your Journey")
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.surfacePrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(Color.shubhSaffron)
                    .clipShape(RoundedRectangle(cornerRadius: Spacing.buttonCornerRadius))
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
    }
}

// CommitmentView.swift (Fabulous-inspired)
struct CommitmentView: View {
    let userName: String
    let onComplete: () -> Void
    
    @State private var commitmentChecked = false
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()
            
            // Letter metaphor
            VStack(spacing: Spacing.lg) {
                Text("A Note from Ancient Wisdom")
                    .font(.shubhTitle2)
                    .foregroundStyle(Color.shubhGold)
                
                Text("Dear \(userName.isEmpty ? "Seeker" : userName),\n\nFor thousands of years, our ancestors looked to the stars and the movement of time to guide their important decisions.\n\nThis wisdom is now at your fingertips. By checking auspicious timings before important moments, you connect with a tradition that has blessed countless beginnings.\n\nMay your journey be filled with shubh muhurtas.")
                    .font(.shubhBody)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
            }
            .padding(Spacing.lg)
            .glassCard()
            .padding(.horizontal, Spacing.md)
            
            // Commitment checkbox
            Button {
                withAnimation(.spring(response: 0.3)) {
                    commitmentChecked.toggle()
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: commitmentChecked ? "checkmark.square.fill" : "square")
                        .font(.title2)
                        .foregroundStyle(commitmentChecked ? Color.shubhSaffron : Color.textSecondary)
                    
                    Text("I commit to consulting auspicious times before important decisions")
                        .font(.shubhSubheadline)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.horizontal, Spacing.lg)
            
            Spacer()
            
            // Complete button
            Button {
                guard commitmentChecked else { return }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                onComplete()
            } label: {
                Text("Begin with Blessings")
                    .font(.shubhHeadline)
                    .foregroundStyle(Color.surfacePrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(commitmentChecked ? Color.shubhSaffron : Color.textTertiary)
                    .clipShape(RoundedRectangle(cornerRadius: Spacing.buttonCornerRadius))
            }
            .disabled(!commitmentChecked)
            .padding(.horizontal, Spacing.xl)
            .padding(.bottom, Spacing.xxl)
        }
    }
}
```

---

## Component Library

### Reusable Components Summary

| Component | File | Purpose |
|-----------|------|---------|
| `GlassCard` | `GlassCard.swift` | Frosted glass container |
| `SectionHeader` | `SectionHeader.swift` | Consistent section titles |
| `MuhurtaBadge` | `MuhurtaBadge.swift` | Small status pill (Amrit/Rahu) |
| `TimeBlockView` | `TimeBlockView.swift` | Time range visualization |
| `ScoreRing` | `ScoreRing.swift` | Circular progress score |
| `SearchBar` | `SearchBar.swift` | Styled search input |
| `ShubhButton` | `ShubhButton.swift` | Primary action button |
| `PanchangaDetailRow` | `PanchangaDetailRow.swift` | Label-value pair |

---

## Animations & Haptics

### Animation Standards

```swift
// Animations.swift
extension Animation {
    static let shubhSpring = Animation.spring(response: 0.35, dampingFraction: 0.7)
    static let shubhQuick = Animation.easeOut(duration: 0.2)
    static let shubhSmooth = Animation.easeInOut(duration: 0.3)
}
```

### Haptic Feedback Guide

| Action | Haptic Type | Code |
|--------|-------------|------|
| Tap button | Light impact | `UIImpactFeedbackGenerator(style: .light).impactOccurred()` |
| Select item | Light impact | `UIImpactFeedbackGenerator(style: .light).impactOccurred()` |
| Confirm action | Medium impact | `UIImpactFeedbackGenerator(style: .medium).impactOccurred()` |
| Success (add to cal) | Success notification | `UINotificationFeedbackGenerator().notificationOccurred(.success)` |
| Error | Error notification | `UINotificationFeedbackGenerator().notificationOccurred(.error)` |
| Scroll snap | Selection changed | `UISelectionFeedbackGenerator().selectionChanged()` |

---

## Data Models

```swift
// Models/Panchanga.swift
struct Panchanga: Codable, Identifiable {
    let id: UUID
    let date: Date
    let teluguMonth: String
    let tithi: Tithi
    let nakshatra: Nakshatra
    let yoga: Yoga
    let karana: Karana
    let paksha: String
    let vara: String
    
    let sunrise: Date
    let sunset: Date
    
    let rahuKalam: TimeRange
    let yamaganda: TimeRange
    let gulikaKalam: TimeRange
    let amritKalam: TimeRange?
    let abhijitMuhurta: TimeRange?
    let varjyam: [TimeRange]
    let durMuhurtam: [TimeRange]
    
    var overallAuspiciousnessScore: Double
    
    func muhurtaAt(hour: Int) -> Muhurta? {
        // Implementation
    }
    
    func favorableWindows() -> [MuhurtaWindow] {
        // Implementation
    }
}

struct Tithi: Codable {
    let name: String
    let number: Int
    let endTime: Date
}

struct Nakshatra: Codable {
    let name: String
    let number: Int
    let endTime: Date
    let deity: String
}

struct Yoga: Codable {
    let name: String
    let isAuspicious: Bool
}

struct Karana: Codable {
    let name: String
}

struct TimeRange: Codable {
    let start: Date
    let end: Date
    
    var formatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }
    
    func contains(_ date: Date) -> Bool {
        return date >= start && date <= end
    }
}

// Models/Activity.swift
struct Activity: Identifiable, Equatable {
    let id: String
    let displayName: String
    let emoji: String
    let keywords: [String]
    let favorableConditions: MuhurtaConditions
    
    static let popular: [Activity] = [
        Activity(
            id: "travel",
            displayName: "Travel",
            emoji: "🛫",
            keywords: ["journey", "trip", "flight"],
            favorableConditions: .forTravel
        ),
        Activity(
            id: "purchase_vehicle",
            displayName: "Vehicle Purchase",
            emoji: "🚗",
            keywords: ["car", "bike", "vehicle"],
            favorableConditions: .forVehicle
        ),
        Activity(
            id: "major_purchase",
            displayName: "Major Purchase",
            emoji: "🛒",
            keywords: ["buy", "purchase", "shopping"],
            favorableConditions: .forPurchase
        ),
        Activity(
            id: "meeting",
            displayName: "Important Meeting",
            emoji: "💼",
            keywords: ["meeting", "interview", "presentation"],
            favorableConditions: .forMeeting
        ),
        Activity(
            id: "signing",
            displayName: "Sign Documents",
            emoji: "📝",
            keywords: ["contract", "agreement", "signing"],
            favorableConditions: .forSigning
        ),
        Activity(
            id: "moving",
            displayName: "Moving / Griha Pravesh",
            emoji: "🏠",
            keywords: ["house", "moving", "griha pravesh"],
            favorableConditions: .forGrihaPravesh
        )
    ]
}

struct MuhurtaConditions {
    let avoidRahuKalam: Bool
    let requireAmritKalam: Bool
    let preferredTithis: [Int]
    let preferredNakshatras: [String]
    let avoidTithis: [Int]  // e.g., Amavasya, Rikta tithis
    
    static let forTravel = MuhurtaConditions(
        avoidRahuKalam: true,
        requireAmritKalam: false,
        preferredTithis: [2, 3, 5, 7, 10, 11, 13],
        preferredNakshatras: ["Ashwini", "Mrigashira", "Pushya", "Hasta", "Anuradha", "Revati"],
        avoidTithis: [4, 9, 14, 30]
    )
    
    // ... more presets
}

// Models/MuhurtaSearchResult.swift
struct MuhurtaSearchResult: Identifiable {
    let id = UUID()
    let date: Date
    let panchanga: Panchanga
    let score: Double
    let positiveReasons: [String]
    let cautionReasons: [String]
    
    var shareText: String {
        """
        🌟 Auspicious time found via Shubh
        
        📅 \(date.formatted(.dateTime.weekday(.wide).month().day().year()))
        ⭐ Score: \(String(format: "%.1f", score))/10
        
        \(panchanga.tithi.name) | \(panchanga.nakshatra.name)
        """
    }
}
```

---

## Widget Specifications

### Today Summary Widget (Small)

```swift
// Widgets/TodayMuhurtaWidget.swift
struct TodayMuhurtaWidget: Widget {
    let kind: String = "TodayMuhurtaWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayMuhurtaProvider()) { entry in
            TodayMuhurtaWidgetView(entry: entry)
                .containerBackground(Color.surfacePrimary, for: .widget)
        }
        .configurationDisplayName("Today's Muhurta")
        .description("See today's auspiciousness at a glance")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TodayMuhurtaWidgetView: View {
    let entry: TodayMuhurtaEntry
    
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: TodayMuhurtaEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Circle()
                    .fill(entry.energyColor)
                    .frame(width: 10, height: 10)
                Text(entry.energySummary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Main info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.tithi)
                    .font(.headline)
                Text(entry.nakshatra)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Next notable time
            if let nextTime = entry.nextNotableTime {
                HStack {
                    Image(systemName: nextTime.isAuspicious ? "sparkles" : "exclamationmark.triangle.fill")
                        .foregroundStyle(nextTime.isAuspicious ? Color.shubhGold : Color.muhurtaAvoid)
                    Text(nextTime.label)
                        .font(.caption2)
                }
            }
        }
        .padding()
    }
}
```

---

## Notification Templates

### Morning Summary Notification

```swift
// Services/NotificationService.swift
func scheduleMorningNotification(for panchanga: Panchanga, at hour: Int) {
    let content = UNMutableNotificationContent()
    content.title = "🌅 Today's Outlook"
    content.body = "\(panchanga.tithi.name) • \(panchanga.nakshatra.name)\n\(panchanga.overallAuspiciousnessScore >= 7 ? "Favorable energy for new beginnings" : "Check app for best timing today")"
    content.sound = UNNotificationSound(named: UNNotificationSoundName("bell_gentle.wav"))
    content.categoryIdentifier = "DAILY_SUMMARY"
    
    var dateComponents = DateComponents()
    dateComponents.hour = hour
    dateComponents.minute = 0
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: "morning_summary", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}
```

### Upcoming Favorable Window

```swift
func scheduleFavorableWindowNotification(window: MuhurtaWindow, activity: Activity?) {
    let content = UNMutableNotificationContent()
    content.title = "✨ Favorable window tomorrow"
    content.body = "\(window.start.formatted(date: .omitted, time: .shortened)) - \(window.end.formatted(date: .omitted, time: .shortened))\(activity != nil ? " • Great for \(activity!.displayName.lowercased())" : "")"
    content.sound = .default
    content.userInfo = ["windowId": window.id.uuidString]
    
    // Notify 12-24 hours before
    let triggerDate = window.start.addingTimeInterval(-12 * 60 * 60)
    let trigger = UNTimeIntervalNotificationTrigger(
        timeInterval: triggerDate.timeIntervalSinceNow,
        repeats: false
    )
    
    let request = UNNotificationRequest(
        identifier: "favorable_\(window.id)",
        content: content,
        trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request)
}
```

---

## Implementation Priority

### MVP (Week 1-2)
1. ✅ Design system (colors, typography, spacing)
2. ✅ Home screen with Today Summary Card
3. ✅ Basic heat map timeline
4. ✅ Settings (location, basic prefs)
5. ✅ Onboarding flow

### V1.0 (Week 3-4)
1. Calendar view with month grid
2. Day detail sheet
3. Search/Find feature with activity cards
4. Apple Calendar integration
5. Small widget
6. Notifications (morning + upcoming)

### V1.1 (Week 5-6)
1. Medium/Large widgets
2. Apple Watch app with Hora complication
3. Streak tracking
4. Telugu language support
5. Share functionality refinement

---

## Testing Checklist

- [ ] All colors pass WCAG AA contrast in both light/dark mode
- [ ] VoiceOver reads all elements correctly
- [ ] Dynamic Type scales all text appropriately
- [ ] Haptics fire on all interactive elements
- [ ] Animations respect "Reduce Motion" setting
- [ ] Widget updates at midnight correctly
- [ ] Calendar sync handles edge cases (deleted events, permission revoked)
- [ ] Notifications don't fire during DND
- [ ] App handles no network gracefully

---

*This specification is designed to be parsed by an LLM. When implementing, refer to specific sections for component-level detail. All SwiftUI code is iOS 17+ compatible using @Observable.*