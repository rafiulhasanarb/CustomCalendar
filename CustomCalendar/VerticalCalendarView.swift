//
//  VerticalCalendarView.swift
//  CustomCalendar
//
//  Created by Rafiul Hasan on 5/31/25.
//

import SwiftUI

struct VerticalCalendarView: View {
    
    @State var displayMonth: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
    @State var currentVisibleMonth: Date = Date()
    
    var calendar: Calendar = .current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(monthTitle(for: currentVisibleMonth, full: true))
                .font(.title.bold())
                .contentTransition(.numericText())
            
            WeekHeaderView()
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(generateMonths(), id: \.self) { month in
                            MonthView(month: month)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            proxy.scrollTo(displayMonth, anchor: .top)
                        }
                    }
                }
                .safeAreaPadding(.top, 10)
            }
        }
        .padding(.horizontal, 10)
    }
    
    //MARK: - Local methods
    func monthTitle(for date: Date, full: Bool = false) -> String {
        let Formatter = DateFormatter()
        Formatter.dateFormat = full ? "MMMM" : "MMM"
        return Formatter.string(from: date)
    }
    
    func generateMonths() -> [Date] {
        var months: [Date] = []
        let currentYear = calendar.component(.year, from: Date())
        for month in 0..<12 {
            if let date = calendar.date(from: DateComponents(year: currentYear, month: month)) {
                months.append(date)
            }
        }
        return months
    }
    
    func generateMonthGrid(for month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
        return stride(from: monthInterval.start, to: monthInterval.end, by: 86400).map { $0 }
    }
    
    @ViewBuilder
    func MonthView(month: Date) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(monthTitle(for: month))
                .bold()
                .padding(.bottom)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 2) {
                ForEach(generateMonthGrid(for: month), id: \.self) { date in
                    DayCellView(date: date, displayMonth: displayMonth, calendar: calendar)
                }
            }
            
            Spacer()
        }
        .id(month)
        .background {
            GeometryReader { geometry in
                Color.clear
                    .onChange(of: geometry.frame(in: .global).maxY) { offset, _ in
                        let screenHeight = UIScreen.main.bounds.height
                        if abs(offset - screenHeight / 1.8) < 44 {
                            withAnimation {
                                currentVisibleMonth = month
                            }
                        }
                    }
            }
        }
    }

    @ViewBuilder
    func DayCellView(date: Date, displayMonth: Date, calendar: Calendar) -> some View {
        let isCurrentMonth = calendar.isDate(date, equalTo: displayMonth, toGranularity: .month)
        
        Text("\(calendar.component(.day, from: date))")
            .font(.system(size: 15))
            .frame(maxWidth: .infinity, minHeight: 45)
            .foregroundStyle(isCurrentMonth ? .primary : Color.gray)
            .background(isCurrentMonth ? Color.yellow : .clear, in: .rect(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(calendar.isDateInToday(date) ? Color.primary : .clear)
                    .padding(1)
            }
    }

}

#Preview {
    VerticalCalendarView()
}
