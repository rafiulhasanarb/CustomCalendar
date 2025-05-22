//
//  CustomCalendarView.swift
//  CustomCalendar
//
//  Created by Rafiul Hasan on 5/21/25.
//

import SwiftUI

enum CalendarSelectionMode {
    case single
    case range
    case multiple
}

struct CalendarConfiguration {
    var selectionMode: CalendarSelectionMode = .single
    var showsOverflowDates: Bool = false
}

struct CustomCalendarView: View {
    
    @State var displayedMonth: Date = Date()
    @State var selectedDates: Set<Date> = []
    @State var selectedRange: (start: Date?, end: Date?) = (nil, nil)
    @State var allowsToSelect: Bool = false
    
    var configuration: CalendarConfiguration = CalendarConfiguration()
    let calendar: Calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 6) {
            WeekdayHeaderView(displayedMonth: $displayedMonth)
            
            let days = generateMonthGrid()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 16) {
                ForEach(days, id: \.self) { date in
                    let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
                    
                    if configuration.showsOverflowDates || isCurrentMonth {
                        let isSelected = isDateSelected(date)
                        let isStart = calendar.isDate(date, inSameDayAs: selectedRange.start ?? Date.distantPast)
                        let isEnd = calendar.isDate(date, inSameDayAs: selectedRange.end ?? Date.distantFuture)
                        
                        ZStack {
                            Text("\(calendar.component(.day, from: date))")
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .foregroundStyle(colorForDate(isSelected: isSelected, isStart: isStart, isEnd: isEnd, isCurrentMonth: isCurrentMonth))
                                .opacity(isPastAndNotAllowed(date) ? 0.4 : 1.0)
                                //.strikethrough(isPastAndNotAllowed(date), color: Color.primary)
                            
                            Circle()
                                .frame(width: 6,height: 6)
                                .opacity(calendar.isDateInToday(date) ? 1 : 0)
                                .offset(y: 20)
                        }
                        .background(selectionBackgroundColor(for: configuration.selectionMode, isSelected: isSelected, isStart: isStart, isEnd: isEnd))
                        .onTapGesture { handleDateSelection(date)}
                    } else {
                        Color.clear.frame(maxWidth: 40)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
    
    // MARK: - local methods
    func isDateSelected(_ date: Date) -> Bool {
        switch configuration.selectionMode {
        case .single, .multiple:
            return selectedDates.contains(where: { calendar.isDate($0, inSameDayAs: date)})
        case .range:
            guard let start = selectedRange.start else { return false }
            if let end = selectedRange.end {
                return (date >= start && date <= end)
            }
            return calendar.isDate(date, inSameDayAs: start)
        }
    }
    
    func colorForDate(isSelected: Bool, isStart: Bool, isEnd: Bool, isCurrentMonth: Bool) -> Color {
        if configuration.selectionMode == .range {
            if isStart || isEnd {
                return Color("Se")
            } else if isSelected {
                return Color.primary
            } else {
                return isCurrentMonth ? Color.primary : .gray
            }
        } else {
            return isSelected ? Color("Se") : (isCurrentMonth ? Color.primary : .gray)
        }
    }
    
    func generateMonthGrid() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end) else {
            return []
        }
        
        return stride(from: firstWeek.start, through: lastWeek.end, by: 86400).map{$0}
    }
    
    func handleDateSelection(_ date: Date) {
        let today = calendar.startOfDay(for: Date())
        let tappedDay = calendar.startOfDay(for: date)
        
        if !allowsToSelect, tappedDay < today {
            return
        }
        
        switch configuration.selectionMode {
        case .single:
            if selectedDates.contains(where: {calendar.isDate($0, inSameDayAs: date)}) {
                selectedDates = selectedDates.filter { !calendar.isDate($0, inSameDayAs: date)}
            } else {
                selectedDates = [date]
            }
        case .multiple:
            if selectedDates.contains(where: {calendar.isDate($0, inSameDayAs: date)}) {
                selectedDates = selectedDates.filter { !calendar.isDate($0, inSameDayAs: date)}
            } else {
                selectedDates.insert(date)
            }
        case .range:
            if selectedRange.start == nil && selectedRange.end != nil {
                selectedRange = (start: date, end: nil)
            } else if let start = selectedRange.start {
                if calendar.isDate(date, inSameDayAs: start) {
                    selectedRange = (start: nil, end: nil)
                } else {
                    let newStart = min(start, date)
                    let newEnd = max(start, date)
                    selectedRange = (start: newStart, end: newEnd)
                }
            }
        }
    }
    
    
    @ViewBuilder
    func selectionBackgroundColor(for mode: CalendarSelectionMode, isSelected: Bool, isStart: Bool, isEnd: Bool) -> some View {
        if isSelected {
            switch mode {
            case .range:
                if isStart {
                    UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10, bottomTrailingRadius: 0, topTrailingRadius: 0)
                } else if isEnd {
                    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10)
                } else {
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.15))
                }
            case .multiple, .single:
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 48)
            }
        }
    }
    
    func isPastAndNotAllowed(_ date: Date) -> Bool {
        let today = calendar.startOfDay(for: Date())
        let thisDay = calendar.startOfDay(for: date)
        return !allowsToSelect && thisDay < today
    }
    
}

#Preview {
    CustomCalendarView()
}
