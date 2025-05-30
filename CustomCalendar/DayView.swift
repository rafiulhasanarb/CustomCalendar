//
//  DayView.swift
//  CustomCalendar
//
//  Created by Rafiul Hasan on 5/30/25.
//

import SwiftUI

struct DayView: View {
    
    let day: Date
    @Binding var isSelected: Bool
    @State var isTapped: Bool = false
    
    var body: some View {
        Text("\(Calendar.current.component(.day, from: day))")
            .font(.system(size: 14))
            .foregroundStyle(foregroundColor)
            .frame(width: 30, height: 30)
            .background(backgroundColor)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.blue, lineWidth: isTapped ? 2 : 0)
            }
            .onTapGesture {
                if !isPastDay(day) {
                    isTapped.toggle()
                    isSelected.toggle()
                }
            }
    }
    
    private func isPastDay(_ date: Date) -> Bool {
        let today = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: today)
        let selectedDate = calendar.startOfDay(for: date)
        return selectedDate < startOfToday
    }
    
    private var foregroundColor: Color {
        if isTapped || isSelected {
            return .white
        } else {
            return .primary
        }
    }
    
    private var backgroundColor: Color {
        if isTapped || isSelected {
            return .blue
        } else {
            return .clear
        }
    }
}

#Preview {
    DayView(day: Date(), isSelected: .constant(true))
}
