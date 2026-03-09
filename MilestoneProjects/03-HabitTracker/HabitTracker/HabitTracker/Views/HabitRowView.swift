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
            Image(systemName: habit.icon)
                .font(.title2)
                .frame(width: 60)
                .foregroundColor(habit.color.swiftUIColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.headline)
                
                
                Text(habit.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(habit.color.swiftUIColor)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                HStack(spacing: 4) {
                    Text("\(habit.completionCount)")
                        .monospacedDigit() // Щоб цифри не стрибали
                    
                    Text("/")
                    
                    Text("^[\(habit.goal) time](inflect: true)")
                        .monospacedDigit()
                    
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .lineLimit(1)
                .foregroundStyle(habit.completionCount >= habit.goal ? habit.color.swiftUIColor : .secondary)
            }
            
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    HabitRowView(habit: Habit(
        id: UUID(),
        title: "Wake Up",
        description: "at 06:00 AM",
        completionCount: 5,
        category: .health,
        icon: "figure.run",
        color: .red,
        goal: 1)
    )
}
