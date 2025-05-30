//
//  SelectedDateView.swift
//  CustomCalendar
//
//  Created by Rafiul Hasan on 5/30/25.
//

import SwiftUI

struct SelectedDateView: View {
    
    let selectedDates: Set<Date>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(selectedDates.sorted(by: <), id: \.self) { date in
                    Text(date.dayAsString())
                        .font(.system(size: 14))
                        .padding(.horizontal, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    SelectedDateView(selectedDates: [Date()])
}
