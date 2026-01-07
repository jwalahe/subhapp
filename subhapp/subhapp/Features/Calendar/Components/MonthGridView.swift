//
//  MonthGridView.swift
//  subhapp
//
//  Calendar - Month grid with day cells
//

import SwiftUI

struct MonthGridView: View {
    let days: [Date?]
    let selectedDate: Date
    let panchangaData: [Date: Panchanga]
    let onDateSelected: (Date) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack(spacing: Spacing.xs) {
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.shubhCaption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, Spacing.xs)

            // Days grid
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            isToday: Calendar.current.isDateInToday(date),
                            panchanga: panchangaData[Calendar.current.startOfDay(for: date)]
                        )
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            onDateSelected(date)
                        }
                    } else {
                        // Empty cell for padding
                        Color.clear
                            .frame(height: 52)
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.md)
    }
}

// MARK: - Day Cell
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let panchanga: Panchanga?

    var body: some View {
        VStack(spacing: 4) {
            // Day number
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.shubhBody)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundStyle(textColor)

            // Auspiciousness indicator dot
            Circle()
                .fill(auspiciousnessColor)
                .frame(width: 6, height: 6)
        }
        .frame(height: 52)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.shubhSaffron : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isToday && !isSelected ? Color.shubhSaffron : Color.clear, lineWidth: 2)
        )
    }

    private var textColor: Color {
        if isSelected {
            return Color.surfacePrimary
        }
        return Color.textPrimary
    }

    private var auspiciousnessColor: Color {
        guard let score = panchanga?.overallAuspiciousnessScore else {
            return Color.textTertiary.opacity(0.5)
        }

        if isSelected {
            return Color.surfacePrimary.opacity(0.7)
        }

        switch score {
        case 7...10: return .muhurtaExcellent
        case 5..<7: return .muhurtaGood
        case 3..<5: return .muhurtaNeutral
        default: return .muhurtaCaution
        }
    }
}

#Preview {
    ZStack {
        Color.surfacePrimary.ignoresSafeArea()

        MonthGridView(
            days: [nil, nil, Date(), Date(), Date(), Date(), Date()],
            selectedDate: Date(),
            panchangaData: [:],
            onDateSelected: { _ in }
        )
    }
}
