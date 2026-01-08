//
//  subhappWidget.swift
//  subhappWidget
//
//  Home Screen Widget - Daily panchanga at a glance
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct PanchangaEntry: TimelineEntry {
    let date: Date
    let tithi: String
    let tithiTeluguName: String
    let nakshatra: String
    let nakshatraTeluguName: String
    let vara: String
    let rahuKalam: String
    let score: Double
    let energyLevel: String
}

// MARK: - Timeline Provider
struct PanchangaProvider: TimelineProvider {
    func placeholder(in context: Context) -> PanchangaEntry {
        PanchangaEntry(
            date: Date(),
            tithi: "Purnima",
            tithiTeluguName: "పూర్ణిమ",
            nakshatra: "Rohini",
            nakshatraTeluguName: "రోహిణి",
            vara: "Sunday",
            rahuKalam: "4:30 PM - 6:00 PM",
            score: 8.5,
            energyLevel: "Excellent"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (PanchangaEntry) -> Void) {
        let entry = generateEntry(for: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PanchangaEntry>) -> Void) {
        var entries: [PanchangaEntry] = []

        // Generate entries for the next 24 hours
        let currentDate = Date()
        for hourOffset in 0..<24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = generateEntry(for: entryDate)
            entries.append(entry)
        }

        // Refresh every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }

    private func generateEntry(for date: Date) -> PanchangaEntry {
        // In production, this would call a shared data service
        // For MVP, we generate sample data based on the date
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        let weekday = calendar.component(.weekday, from: date)

        // Sample tithi rotation
        let tithis = [
            ("Pratipada", "పాడ్యమి"),
            ("Dwitiya", "విదియ"),
            ("Tritiya", "తదియ"),
            ("Chaturthi", "చవితి"),
            ("Panchami", "పంచమి"),
            ("Shashthi", "షష్ఠి"),
            ("Saptami", "సప్తమి"),
            ("Ashtami", "అష్టమి"),
            ("Navami", "నవమి"),
            ("Dashami", "దశమి"),
            ("Ekadashi", "ఏకాదశి"),
            ("Dwadashi", "ద్వాదశి"),
            ("Trayodashi", "త్రయోదశి"),
            ("Chaturdashi", "చతుర్దశి"),
            ("Purnima", "పూర్ణిమ")
        ]

        let nakshatras = [
            ("Ashwini", "అశ్వని"),
            ("Bharani", "భరణి"),
            ("Krittika", "కృత్తిక"),
            ("Rohini", "రోహిణి"),
            ("Mrigashira", "మృగశిర"),
            ("Ardra", "ఆర్ద్ర"),
            ("Punarvasu", "పునర్వసు"),
            ("Pushya", "పుష్యమి"),
            ("Ashlesha", "ఆశ్లేష")
        ]

        let varas = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        // Calculate Rahu Kalam based on weekday
        let rahuKalamTimes = [
            "4:30 PM - 6:00 PM",  // Sunday
            "7:30 AM - 9:00 AM",  // Monday
            "3:00 PM - 4:30 PM",  // Tuesday
            "12:00 PM - 1:30 PM", // Wednesday
            "1:30 PM - 3:00 PM",  // Thursday
            "10:30 AM - 12:00 PM", // Friday
            "9:00 AM - 10:30 AM"  // Saturday
        ]

        let tithiIndex = (dayOfMonth - 1) % tithis.count
        let nakshatraIndex = dayOfMonth % nakshatras.count
        let varaIndex = weekday - 1

        // Score varies by date
        let baseScore = 6.0 + Double(dayOfMonth % 5)
        let score = min(10.0, baseScore)

        let energyLevel: String
        switch score {
        case 8...10: energyLevel = "Excellent"
        case 6..<8: energyLevel = "Good"
        case 4..<6: energyLevel = "Neutral"
        default: energyLevel = "Caution"
        }

        return PanchangaEntry(
            date: date,
            tithi: tithis[tithiIndex].0,
            tithiTeluguName: tithis[tithiIndex].1,
            nakshatra: nakshatras[nakshatraIndex].0,
            nakshatraTeluguName: nakshatras[nakshatraIndex].1,
            vara: varas[varaIndex],
            rahuKalam: rahuKalamTimes[varaIndex],
            score: score,
            energyLevel: energyLevel
        )
    }
}

// MARK: - Widget Entry View
struct PanchangaWidgetEntryView: View {
    var entry: PanchangaProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Widget
struct SmallWidgetView: View {
    let entry: PanchangaEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("🕉️")
                    .font(.title2)
                Text(entry.date.formatted(.dateTime.weekday(.abbreviated)))
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
            }

            Spacer()

            // Tithi
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.tithi)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(entry.tithiTeluguName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Nakshatra
            Text(entry.nakshatra)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Score indicator
            HStack {
                Circle()
                    .fill(scoreColor)
                    .frame(width: 8, height: 8)
                Text(entry.energyLevel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var scoreColor: Color {
        switch entry.score {
        case 8...10: return Color(hex: "4CAF50")
        case 6..<8: return Color(hex: "8BC34A")
        case 4..<6: return Color(hex: "FFC107")
        default: return Color(hex: "FF9800")
        }
    }
}

// MARK: - Medium Widget
struct MediumWidgetView: View {
    let entry: PanchangaEntry

    var body: some View {
        HStack(spacing: 16) {
            // Left side - Date and energy
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("🕉️")
                        .font(.title)
                    VStack(alignment: .leading) {
                        Text(entry.date.formatted(.dateTime.weekday(.wide)))
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(entry.date.formatted(.dateTime.month().day()))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                // Score
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 3)
                            .frame(width: 40, height: 40)

                        Circle()
                            .trim(from: 0, to: entry.score / 10)
                            .stroke(scoreColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(-90))

                        Text(String(format: "%.0f", entry.score))
                            .font(.caption.bold())
                    }

                    VStack(alignment: .leading) {
                        Text(entry.energyLevel)
                            .font(.caption.bold())
                        Text("Day Energy")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 1)

            // Right side - Panchanga details
            VStack(alignment: .leading, spacing: 6) {
                PanchangaRow(label: "Tithi", value: entry.tithi, telugu: entry.tithiTeluguName)
                PanchangaRow(label: "Nakshatra", value: entry.nakshatra, telugu: entry.nakshatraTeluguName)

                Divider()
                    .background(Color.white.opacity(0.2))

                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(Color(hex: "FF9800"))
                    Text("Rahu: \(entry.rahuKalam)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var scoreColor: Color {
        switch entry.score {
        case 8...10: return Color(hex: "4CAF50")
        case 6..<8: return Color(hex: "8BC34A")
        case 4..<6: return Color(hex: "FFC107")
        default: return Color(hex: "FF9800")
        }
    }
}

// MARK: - Large Widget
struct LargeWidgetView: View {
    let entry: PanchangaEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                HStack {
                    Text("🕉️")
                        .font(.largeTitle)

                    VStack(alignment: .leading) {
                        Text("Shubh")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                        Text(entry.date.formatted(.dateTime.weekday(.wide).month().day()))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                // Score ring
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 4)
                        .frame(width: 56, height: 56)

                    Circle()
                        .trim(from: 0, to: entry.score / 10)
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 56, height: 56)
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 0) {
                        Text(String(format: "%.1f", entry.score))
                            .font(.headline)
                        Text("/10")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Divider()
                .background(Color.white.opacity(0.2))

            // Panchanga Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                PanchangaCard(icon: "moon.fill", label: "Tithi", value: entry.tithi, telugu: entry.tithiTeluguName)
                PanchangaCard(icon: "star.fill", label: "Nakshatra", value: entry.nakshatra, telugu: entry.nakshatraTeluguName)
            }

            // Rahu Kalam warning
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color(hex: "FF9800"))

                VStack(alignment: .leading) {
                    Text("Rahu Kalam")
                        .font(.caption.bold())
                    Text(entry.rahuKalam)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("Avoid new ventures")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Spacer()

            // Footer
            Text(entry.energyLevel + " energy day")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var scoreColor: Color {
        switch entry.score {
        case 8...10: return Color(hex: "4CAF50")
        case 6..<8: return Color(hex: "8BC34A")
        case 4..<6: return Color(hex: "FFC107")
        default: return Color(hex: "FF9800")
        }
    }
}

// MARK: - Helper Views
struct PanchangaRow: View {
    let label: String
    let value: String
    let telugu: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            HStack(spacing: 4) {
                Text(value)
                    .font(.subheadline.bold())
                Text("(\(telugu))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct PanchangaCard: View {
    let icon: String
    let label: String
    let value: String
    let telugu: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(Color(hex: "FFB347"))
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Text(value)
                .font(.headline)

            Text(telugu)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Color Extension
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
            (a, r, g, b) = (255, 0, 0, 0)
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

// MARK: - Widget Configuration
@main
struct subhappWidget: Widget {
    let kind: String = "subhappWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PanchangaProvider()) { entry in
            PanchangaWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Panchanga")
        .description("View today's panchanga and auspicious timings at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    subhappWidget()
} timeline: {
    PanchangaEntry(
        date: Date(),
        tithi: "Panchami",
        tithiTeluguName: "పంచమి",
        nakshatra: "Rohini",
        nakshatraTeluguName: "రోహిణి",
        vara: "Tuesday",
        rahuKalam: "3:00 PM - 4:30 PM",
        score: 8.5,
        energyLevel: "Excellent"
    )
}

#Preview(as: .systemMedium) {
    subhappWidget()
} timeline: {
    PanchangaEntry(
        date: Date(),
        tithi: "Panchami",
        tithiTeluguName: "పంచమి",
        nakshatra: "Rohini",
        nakshatraTeluguName: "రోహిణి",
        vara: "Tuesday",
        rahuKalam: "3:00 PM - 4:30 PM",
        score: 8.5,
        energyLevel: "Excellent"
    )
}

#Preview(as: .systemLarge) {
    subhappWidget()
} timeline: {
    PanchangaEntry(
        date: Date(),
        tithi: "Panchami",
        tithiTeluguName: "పంచమి",
        nakshatra: "Rohini",
        nakshatraTeluguName: "రోహిణి",
        vara: "Tuesday",
        rahuKalam: "3:00 PM - 4:30 PM",
        score: 8.5,
        energyLevel: "Excellent"
    )
}
