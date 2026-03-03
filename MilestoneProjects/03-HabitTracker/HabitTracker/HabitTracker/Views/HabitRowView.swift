//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by mac on 03.03.2026.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit // Передаємо дані конкретної звички
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(habit.title)
                
                
                Text(habit.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("^[\(habit.completionCount) completion](inflect: true)")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(8)
            }
            
            
        }
        .padding()
    }
}

#Preview {
    HabitRowView(habit: Habit(
        id: UUID(),
        title: "Wake Up",
        description: "at 06:00 AM",
        completionCount: 5,
        category: .health))
}
