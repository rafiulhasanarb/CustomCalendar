//
//  WeekHeaderView.swift
//  CustomCalendar
//
//  Created by Rafiul Hasan on 5/31/25.
//

import SwiftUI

struct WeekHeaderView: View {
    
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
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(weekdays.indices, id: \.self) { index in
                WeekdayLabel(weekdays[index], isToday: index == todayWeekdayIndex)
            }
        }
    }
    
    @ViewBuilder
    func WeekdayLabel(_ name: String, isToday: Bool) -> some View {
        Text(name)
            .font(.system(size: 15))
            .frame(maxWidth: .infinity)
            .foregroundStyle(isToday ? Color.primary : .gray)
            .padding(.vertical, 3)
            .background(isToday ? .gray.opacity(0.4) : .gray.opacity(0.2), in: .rect(cornerRadius: 8))
    }
    
}

#Preview {
    WeekHeaderView()
}
