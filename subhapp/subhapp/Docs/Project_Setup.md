# Shubh: Xcode Project Setup Guide

> **For**: iOS development beginners setting up their first SwiftUI project  
> **Target**: iOS 17.0+ | Swift 5.9+ | Xcode 15+

---

## 1. Create New Project

### Step-by-Step in Xcode

1. **Open Xcode** → File → New → Project (⌘⇧N)

2. **Choose Template**:
   - Platform: **iOS**
   - Application: **App**
   - Click **Next**

3. **Configure Project Options**:

   | Field | Value | Notes |
   |-------|-------|-------|
   | **Product Name** | `Shubh` | App name on device |
   | **Team** | Your Apple Developer account | Free account works for testing |
   | **Organization Identifier** | `com.yourname` | e.g., `com.jwala` |
   | **Bundle Identifier** | Auto-generated | Will be `com.jwala.Shubh` |
   | **Interface** | **SwiftUI** | ✅ Critical |
   | **Language** | **Swift** | ✅ Critical |
   | **Storage** | **None** | We'll add Core Data later if needed |
   | **Include Tests** | ✅ Checked | Good practice |

4. **Click Next** → Choose location → **Create**

---

## 2. Configure Project Settings

### Deployment Target

1. Click on **Shubh** (blue icon) in the Project Navigator
2. Select the **Shubh** target (not project)
3. Go to **General** tab
4. Set **Minimum Deployments**:
   - iOS: **17.0** (required for @Observable, new SwiftUI features)

### Device Orientation

Still in **General** → **Deployment Info**:
- ✅ Portrait
- ☐ Upside Down
- ☐ Landscape Left  
- ☐ Landscape Right

*(Calendar apps work best in portrait only)*

### App Icons

1. In Project Navigator, open **Assets.xcassets**
2. Click on **AppIcon**
3. You'll need to add your app icon (1024x1024 recommended)
4. For now, leave blank (you can add later)

---

## 3. Add Required Capabilities

Go to **Signing & Capabilities** tab:

### Add These Capabilities (click "+ Capability"):

1. **Background Modes** (for notifications)
   - ✅ Background fetch
   - ✅ Remote notifications

2. **Push Notifications**
   - Required for proactive muhurta alerts

3. *(Later for V1)* **App Groups**
   - Required for widget data sharing
   - Name: `group.com.yourname.Shubh`

### Calendar Access (Info.plist)

1. Open `Info.plist` (or in Project → Info tab)
2. Add these keys (right-click → Add Row):

```xml
<key>NSCalendarsUsageDescription</key>
<string>Shubh needs calendar access to add auspicious times to your schedule</string>

<key>NSCalendarsFullAccessUsageDescription</key>
<string>Shubh needs calendar access to add auspicious times to your schedule</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Shubh uses your location to calculate accurate panchanga timings for your area</string>

<key>NSUserTrackingUsageDescription</key>
<string>This helps us improve the app experience</string>
```

---

## 4. Create Folder Structure

In Project Navigator, create this folder structure:

```
Shubh/
├── App/
├── Features/
│   ├── Home/
│   │   └── Components/
│   ├── Calendar/
│   ├── Search/
│   ├── Settings/
│   └── Onboarding/
├── Core/
│   ├── Models/
│   ├── Services/
│   └── Extensions/
├── DesignSystem/
│   └── Components/
├── Resources/
│   └── Sounds/
└── Widgets/ (add later)
```

**How to create folders**:
1. Right-click on `Shubh` folder → New Group
2. Name it appropriately
3. Repeat for subfolders

**Important**: These are "Groups" in Xcode, not actual filesystem folders. They help organize your code.

---

## 5. Set Up Design System Files

Create these files first (they're used everywhere):

### Colors.swift
Location: `DesignSystem/Colors.swift`

```swift
import SwiftUI

extension Color {
    // Primary Brand Colors
    static let shubhSaffron = Color(hex: "#FF9933")
    static let shubhGold = Color(hex: "#FFD700")
    static let shubhDeepPurple = Color(hex: "#4A1C6B")
    
    // Auspiciousness Gradient
    static let muhurtaExcellent = Color(hex: "#22C55E")
    static let muhurtaGood = Color(hex: "#84CC16")
    static let muhurtaNeutral = Color(hex: "#EAB308")
    static let muhurtaCaution = Color(hex: "#F97316")
    static let muhurtaAvoid = Color(hex: "#EF4444")
    
    // Surfaces
    static let surfacePrimary = Color(hex: "#000000")
    static let surfaceElevated = Color(hex: "#1C1C1E")
    static let surfaceSecondary = Color(hex: "#2C2C2E")
    
    // Text
    static let textPrimary = Color(hex: "#FFFFFF")
    static let textSecondary = Color(hex: "#EBEBF5").opacity(0.6)
    static let textTertiary = Color(hex: "#EBEBF5").opacity(0.3)
    
    // Glass
    static let glassBackground = Color.white.opacity(0.15)
    static let glassBorder = Color.white.opacity(0.3)
}

// Hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

### Typography.swift
Location: `DesignSystem/Typography.swift`

```swift
import SwiftUI

extension Font {
    // Display
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
}
```

### Spacing.swift
Location: `DesignSystem/Spacing.swift`

```swift
import Foundation

enum Spacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    
    static let cardPadding: CGFloat = 20
    static let cardCornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 14
}
```

---

## 6. Add Required Packages (SPM)

### Using Swift Package Manager

1. File → Add Package Dependencies (⌘⇧A)
2. Add these packages:

| Package | URL | Purpose |
|---------|-----|---------|
| None required for MVP | — | SwiftUI has everything built-in |

**Optional packages for later**:
- `swift-collections` - Better data structures
- `swift-algorithms` - Array operations

*For MVP, we don't need any external packages. SwiftUI + Foundation handle everything.*

---

## 7. Widget Target Setup (For V1)

### Add Widget Extension

1. File → New → Target
2. Choose **Widget Extension**
3. Configure:
   - Product Name: `ShubhWidget`
   - ☐ Include Configuration App Intent (uncheck for simple widget)
   - ☑ Include Live Activity (optional, for iOS 16.1+)

4. When prompted "Activate ShubhWidget scheme?", click **Activate**

### Enable App Groups (for Widget data sharing)

1. Select **Shubh** target → Signing & Capabilities
2. Add **App Groups** capability
3. Click **+** and add: `group.com.yourname.Shubh`
4. Repeat for **ShubhWidget** target

---

## 8. Run Configuration

### Simulator vs Device

**For Development (Simulator)**:
- Choose any iPhone simulator (iPhone 15 Pro recommended)
- ⌘R to build and run

**For Real Device**:
1. Connect iPhone via USB
2. Trust the computer on iPhone
3. Select your device in the scheme dropdown
4. First time: Xcode will provision your device

### Troubleshooting Common Issues

| Issue | Solution |
|-------|----------|
| "Signing requires a development team" | Add your Apple ID in Xcode → Settings → Accounts |
| "Unable to install" on device | On iPhone: Settings → General → VPN & Device Management → Trust |
| "Module not found" | Clean Build (⌘⇧K) then Build (⌘B) |
| Simulator stuck | Device → Erase All Content and Settings |

---

## 9. Initial File Setup

### Move ShubhApp.swift
Location: `App/ShubhApp.swift`

```swift
import SwiftUI

@main
struct ShubhApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingContainerView()
            }
        }
    }
}
```

### Create ContentView.swift
Location: `App/ContentView.swift`

```swift
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
```

### Create Placeholder Views

Create these placeholder files so the app compiles:

**Features/Home/HomeView.swift**:
```swift
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home - Coming Soon")
                .navigationTitle("Good Morning")
        }
    }
}
```

**Features/Calendar/CalendarView.swift**:
```swift
import SwiftUI

struct CalendarView: View {
    var body: some View {
        NavigationStack {
            Text("Calendar - Coming Soon")
                .navigationTitle("Calendar")
        }
    }
}
```

**Features/Search/SearchView.swift**:
```swift
import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationStack {
            Text("Search - Coming Soon")
                .navigationTitle("Find Muhurta")
        }
    }
}
```

**Features/Settings/SettingsView.swift**:
```swift
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Text("Settings - Coming Soon")
                .navigationTitle("Settings")
        }
    }
}
```

**Features/Onboarding/OnboardingContainerView.swift**:
```swift
import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Shubh")
                .font(.shubhLargeTitle)
            
            Text("Your auspicious timing companion")
                .font(.shubhBody)
                .foregroundStyle(.secondary)
            
            Button("Get Started") {
                hasCompletedOnboarding = true
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.shubhSaffron)
        }
    }
}
```

---

## 10. Build and Run

1. Select simulator: **iPhone 15 Pro**
2. Press **⌘R** (or click Play button)
3. App should launch with tab bar navigation

### Expected Result
- Four tabs visible (Home, Calendar, Find, Settings)
- Each shows placeholder text
- Tab bar tint is saffron orange
- No errors in console

---

## 11. Git Setup (Recommended)

### Initialize Repository

In Terminal, navigate to project folder:

```bash
cd ~/path/to/Shubh
git init
git add .
git commit -m "Initial project setup with folder structure"
```

### Create .gitignore

Create file `.gitignore` in project root:

```gitignore
# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/xcshareddata/
*.xcworkspace/*
!*.xcworkspace/contents.xcworkspacedata
DerivedData/
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Swift Package Manager
.build/
Packages/
Package.pins
Package.resolved

# CocoaPods (if used later)
Pods/

# Secrets
*.plist.secret
Secrets/

# OS generated
.DS_Store
*.swp
*~
```

---

## 12. Next Steps

Now you're ready to implement features from the implementation spec:

### Week 1 Priorities
1. [ ] Implement `GlassCard` component
2. [ ] Build `TodaySummaryCard` 
3. [ ] Create mock `Panchanga` data
4. [ ] Build Home screen UI
5. [ ] Implement basic Settings

### Resources

- **SwiftUI Documentation**: [developer.apple.com/documentation/swiftui](https://developer.apple.com/documentation/swiftui)
- **SF Symbols**: Download from Apple for icon reference
- **Human Interface Guidelines**: [developer.apple.com/design/human-interface-guidelines](https://developer.apple.com/design/human-interface-guidelines)

---

## Quick Reference: Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Build | ⌘B |
| Run | ⌘R |
| Stop | ⌘. |
| Clean Build | ⌘⇧K |
| Show/Hide Navigator | ⌘0 |
| Show/Hide Inspector | ⌘⌥0 |
| Canvas Preview | ⌘⌥↵ |
| Jump to Definition | ⌘-click |
| Find in Project | ⌘⇧F |

---

*You're all set! Start building from the implementation spec, referencing the design system files you've created.*