//
//  WeekdayHeaderView.swift
//  CustomCalendar
//
//  Created by Rafiul Hasan on 5/21/25.
//

import SwiftUI

struct WeekdayHeaderView: View {
    
    @Binding var displayedMonth: Date
    let calendar = Calendar.current
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    var weekdays: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        return Array(symbols[1...6] + [symbols[0]])
    }
    var todayWeekdayIndex: Int {
        let originalIndex = calendar.component(.weekday, from: Date()) - 1
        return (originalIndex + 6) % 7
    }
    func changeMonth(by value: Int) {
        displayedMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) ?? displayedMonth
    }
    
    var body: some View {
        VStack(spacing: 24) {
            monthNavigationView
            weekdayHeaderView
        }
    }
    
    private var monthNavigationView: some View {
        HStack {
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(formatter.string(from: displayedMonth))
                .font(.headline)
            Spacer()
            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
            }
        }
        .tint(.primary)
        .padding(.horizontal)
    }
    
    private var weekdayHeaderView: some View {
        HStack(spacing: 6) {
            ForEach(weekdays.indices, id: \.self) { index in
                weekdayLabel(for: index)
            }
        }
    }
    
    private func weekdayLabel(for index: Int) -> some View {
        Text(weekdays[index])
            .font(.system(size: 15))
            .frame(maxWidth: .infinity)
            .foregroundStyle(index == todayWeekdayIndex ? Color.primary : Color.gray)
            .padding(.vertical, 3)
            .background(
                index == todayWeekdayIndex ? Color.gray.opacity(0.4) : Color.gray.opacity(0.2),
                in: .rect
            )
    }
    
}

#Preview {
    WeekdayHeaderView(displayedMonth: .constant(Date()))
}
