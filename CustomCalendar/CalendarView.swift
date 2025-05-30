//
//  CalendarView.swift
//  CustomCalendar
//
//  Created by Rafiul Hasan on 5/30/25.
//

import SwiftUI

struct CalendarView: View {
    
    @Binding var selectedDates: Set<Date>
    @State var currentYear: Int
    
    init(selectedDates: Binding<Set<Date>>) {
        self._selectedDates = selectedDates
        _currentYear = State(initialValue: Calendar.current.component(.year, from: Date()))
    }
    
    var body: some View {
        VStack {
            SelectedDateView(selectedDates: selectedDates)
            
            HStack {
                Button {
                    currentYear -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .font(.system(size: 18, weight: .semibold))
                        .padding()
                }

                Spacer()
                
                Text("\(currentYear)")
                
                Spacer()
                
                Button {
                    currentYear += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .font(.system(size: 18, weight: .semibold))
                        .padding()
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(monthInYear(), id: \.self) { month in
                        MonthView(month: month, selectedDates: $selectedDates)
                    }
                }
            }
        }
    }
    
    func monthInYear() -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        
        for month in 0...12 {
            let components = DateComponents(year: currentYear, month: month + 1, day: 1)
            if let date = calendar.date(from: components) {
                dates.append(date)
            }
        }
        
        return dates
    }
}

#Preview {
    CalendarView(selectedDates: .constant([]))
}
