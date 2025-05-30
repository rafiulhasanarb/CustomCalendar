//
//  MonthView.swift
//  CustomCalendar
//
//  Created by Rafiul Hasan on 5/30/25.
//

import SwiftUI

struct MonthView: View {
    
    let month: Date
    @Binding var selectedDates: Set<Date>
    
    var body: some View {
        VStack {
            Text(month.monthAsString())
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            
            HStack(spacing: 10) {
                ForEach(DateFormatter().shortWeekdaySymbols, id: \.self) { weekday in
                    Text(weekday)
                        .font(.system(size: 12,weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                ForEach(daysInMonth(), id: \.self) { day in
                    if let day = day {
                        DayView(date: day, isSelected: Binding(
                            get: {isSelected(day)},
                            set: {if $0 { selectedDates.insert(day)}})
                        )
                        .opacity(1.0)
                    } else {
                        Spacer()
                            .frame(width: 30, height: 30)
                            .hidden()
                    }
                }
            }
        }
    }
    
    // MARK: - local methods
    func daysInMonth() -> [Date?] {
        let calendar = Calendar.current
        var dateComponents = DateComponents(year: calendar.component(.year, from: month), month: calendar.component(.month, from: month))
        guard let range = calendar.range(of: .day, in: .month, for: calendar.date(from: dateComponents)!) else { return [] }
        let firstWeekDay = calendar.component(.weekday, from: month)
        var monthDays: [Date?] = Array(repeating: nil, count: firstWeekDay - 1)
        
        for day in  1 ..< range.upperBound {
            dateComponents.day = day
            monthDays.append(calendar.date(from: dateComponents))
        }
        
        return monthDays
    }
    
    func isSelected(_ date: Date) -> Bool {
        selectedDates.contains {
            Calendar.current.isDate($0, inSameDayAs: date)
        }
    }
}

#Preview {
    MonthView(month: Date(), selectedDates: .constant([]))
}
