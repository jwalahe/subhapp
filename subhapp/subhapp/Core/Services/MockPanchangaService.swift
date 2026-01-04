//
//  MockPanchangaService.swift
//  subhapp
//
//  Mock Panchanga Service - Provides realistic test data for MVP
//

import Foundation

@Observable
class MockPanchangaService {
    static let shared = MockPanchangaService()

    private init() {}

    // MARK: - Telugu Months
    private let teluguMonths = [
        "Chaitra", "Vaishakha", "Jyeshtha", "Ashadha",
        "Shravana", "Bhadrapada", "Ashwina", "Kartika",
        "Margashira", "Pushya", "Magha", "Phalguna"
    ]

    // MARK: - Get Panchanga for Date

    func getPanchanga(for date: Date) -> Panchanga {
        let calendar = Calendar.current

        // Calculate sunrise/sunset (approximate for Milwaukee, WI)
        let sunrise = calendar.date(bySettingHour: 7, minute: 15, second: 0, of: date) ?? date
        let sunset = calendar.date(bySettingHour: 17, minute: 45, second: 0, of: date) ?? date

        // Generate pseudo-random but consistent values based on date
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let tithiIndex = (dayOfYear % 15) + 1
        let nakshatraIndex = (dayOfYear % 27)
        let yogaIndex = (dayOfYear + 5) % 27
        let karanaIndex = (dayOfYear % 7)

        // Determine paksha based on lunar cycle (simplified)
        let paksha: Tithi.Paksha = (dayOfYear / 15) % 2 == 0 ? .shukla : .krishna

        // Create Tithi
        let tithiData = Tithi.names[min(tithiIndex - 1, 14)]
        let tithi = Tithi(
            name: tithiData.english,
            teluguName: tithiData.telugu,
            number: tithiIndex,
            endTime: calendar.date(byAdding: .hour, value: 18, to: sunrise) ?? date,
            paksha: paksha
        )

        // Create Nakshatra
        let nakshatraData = Nakshatra.all[nakshatraIndex]
        let nakshatra = Nakshatra(
            name: nakshatraData.name,
            teluguName: nakshatraData.telugu,
            number: nakshatraIndex + 1,
            endTime: calendar.date(byAdding: .hour, value: 22, to: sunrise) ?? date,
            deity: nakshatraData.deity,
            rulingPlanet: nakshatraData.planet
        )

        // Create Yoga
        let yogaData = Yoga.all[yogaIndex]
        let yoga = Yoga(
            name: yogaData.name,
            teluguName: yogaData.telugu,
            number: yogaIndex + 1,
            endTime: calendar.date(byAdding: .hour, value: 14, to: sunrise) ?? date
        )

        // Create Karana
        let karanaData = Karana.movable[karanaIndex]
        let karana = Karana(
            name: karanaData.name,
            teluguName: karanaData.telugu,
            number: karanaIndex + 1,
            endTime: calendar.date(byAdding: .hour, value: 8, to: sunrise) ?? date
        )

        // Get Vara
        let vara = Vara.from(date: date)

        // Calculate Rahu Kalam based on day of week
        let rahuKalam = calculateRahuKalam(for: vara, sunrise: sunrise, sunset: sunset)

        // Calculate Yamaganda (roughly 1.5 hours, position varies by day)
        let yamaganda = calculateYamaganda(for: vara, sunrise: sunrise, sunset: sunset)

        // Calculate Gulika Kalam
        let gulikaKalam = calculateGulikaKalam(for: vara, sunrise: sunrise, sunset: sunset)

        // Amrit Kalam (not every day - about 60% of days)
        let amritKalam: TimeRange? = dayOfYear % 5 != 0 ?
            TimeRange.today(startHour: 10, startMinute: 30, endHour: 12, endMinute: 0) : nil

        // Abhijit Muhurta (midday, around solar noon)
        let abhijitMuhurta = TimeRange.today(startHour: 11, startMinute: 48, endHour: 12, endMinute: 36)

        // Calculate overall score
        let score = calculateOverallScore(
            tithi: tithi,
            nakshatra: nakshatra,
            yoga: yoga,
            karana: karana,
            vara: vara
        )

        // Telugu calendar info
        let monthIndex = (calendar.component(.month, from: date) + 8) % 12  // Offset for Telugu calendar
        let teluguMonth = teluguMonths[monthIndex]
        let teluguYear = "Krodhi"  // Current Telugu year name (changes annually)

        return Panchanga(
            id: UUID(),
            date: date,
            tithi: tithi,
            nakshatra: nakshatra,
            yoga: yoga,
            karana: karana,
            vara: vara,
            teluguMonth: teluguMonth,
            teluguYear: teluguYear,
            sunrise: sunrise,
            sunset: sunset,
            rahuKalam: rahuKalam,
            yamaganda: yamaganda,
            gulikaKalam: gulikaKalam,
            amritKalam: amritKalam,
            abhijitMuhurta: abhijitMuhurta,
            varjyam: [],
            durMuhurtam: [],
            overallAuspiciousnessScore: score
        )
    }

    // MARK: - Get Panchanga for Month

    func getPanchangaForMonth(_ date: Date) -> [Date: Panchanga] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else {
            return [:]
        }

        var result: [Date: Panchanga] = [:]

        for dayOffset in range {
            if let dayDate = calendar.date(byAdding: .day, value: dayOffset - 1, to: startOfMonth) {
                let startOfDay = calendar.startOfDay(for: dayDate)
                result[startOfDay] = getPanchanga(for: dayDate)
            }
        }

        return result
    }

    // MARK: - Helper Methods

    private func calculateRahuKalam(for vara: Vara, sunrise: Date, sunset: Date) -> TimeRange {
        // Rahu Kalam order: Mon=2, Sat=1, Fri=3, Wed=4, Thu=5, Tue=6, Sun=7
        // Each day divided into 8 parts of ~1.5 hours each
        let rahuOrder: [Vara: Int] = [
            .monday: 2, .saturday: 1, .friday: 3, .wednesday: 4,
            .thursday: 5, .tuesday: 6, .sunday: 7
        ]

        let dayDuration = sunset.timeIntervalSince(sunrise)
        let partDuration = dayDuration / 8
        let position = rahuOrder[vara] ?? 1

        let start = sunrise.addingTimeInterval(partDuration * Double(position - 1))
        let end = start.addingTimeInterval(partDuration)

        return TimeRange(start: start, end: end)
    }

    private func calculateYamaganda(for vara: Vara, sunrise: Date, sunset: Date) -> TimeRange {
        // Yamaganda order: Sun=5, Mon=4, Tue=3, Wed=2, Thu=1, Fri=7, Sat=6
        let yamaOrder: [Vara: Int] = [
            .sunday: 5, .monday: 4, .tuesday: 3, .wednesday: 2,
            .thursday: 1, .friday: 7, .saturday: 6
        ]

        let dayDuration = sunset.timeIntervalSince(sunrise)
        let partDuration = dayDuration / 8
        let position = yamaOrder[vara] ?? 1

        let start = sunrise.addingTimeInterval(partDuration * Double(position - 1))
        let end = start.addingTimeInterval(partDuration)

        return TimeRange(start: start, end: end)
    }

    private func calculateGulikaKalam(for vara: Vara, sunrise: Date, sunset: Date) -> TimeRange {
        // Gulika order: Sun=7, Mon=6, Tue=5, Wed=4, Thu=3, Fri=2, Sat=1
        let gulikaOrder: [Vara: Int] = [
            .sunday: 7, .monday: 6, .tuesday: 5, .wednesday: 4,
            .thursday: 3, .friday: 2, .saturday: 1
        ]

        let dayDuration = sunset.timeIntervalSince(sunrise)
        let partDuration = dayDuration / 8
        let position = gulikaOrder[vara] ?? 1

        let start = sunrise.addingTimeInterval(partDuration * Double(position - 1))
        let end = start.addingTimeInterval(partDuration)

        return TimeRange(start: start, end: end)
    }

    private func calculateOverallScore(
        tithi: Tithi,
        nakshatra: Nakshatra,
        yoga: Yoga,
        karana: Karana,
        vara: Vara
    ) -> Double {
        var score: Double = 5.0  // Base neutral

        // Tithi influence (weight: 2.0)
        if tithi.isAuspicious { score += 2.0 }
        if tithi.isInauspicious { score -= 2.0 }

        // Nakshatra influence (weight: 2.0)
        if nakshatra.isFavorable { score += 2.0 }

        // Yoga influence (weight: 1.5)
        if yoga.isAuspicious { score += 1.5 }
        if yoga.isInauspicious { score -= 1.5 }

        // Karana influence (weight: 1.0)
        if karana.isFavorable { score += 0.5 }
        if karana.isBhadra { score -= 1.0 }

        // Vara influence (weight: 0.5)
        let goodDays: [Vara] = [.monday, .wednesday, .thursday, .friday]
        if goodDays.contains(vara) { score += 0.5 }

        return min(10, max(0, score))
    }
}
