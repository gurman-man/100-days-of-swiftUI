//
//  ContentView.swift
//  HabitTracker
//
//  Created by mac on 02.03.2026.
//

import SwiftUI

struct ContentView: View {
    @State var store = HabitStore()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.savedHabits) { habit in
                    NavigationLink(value: habit.title) {
                        HabitRowView(habit: habit)
                    }
                }
                .onDelete(perform: store.deleteHabit)
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // action
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    let previewStore = HabitStore()
    previewStore.savedHabits = [
        Habit(id: UUID(), title: "Gym", description: "Go to gym", completionCount: 3, category: .health),
        Habit(id: UUID(), title: "Swift", description: "Learn SwiftUI", completionCount: 10, category: .education)
    ]
    return ContentView(store: previewStore)
}
