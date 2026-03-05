//
//  ContentView.swift
//  HabitTracker
//
//  Created by mac on 02.03.2026.
//

import SwiftUI

struct ContentView: View {
    @State var store = HabitStore()
    @State private var isShowingAddHabit = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<store.savedHabits.count, id: \.self) { index in
                    NavigationLink(destination: HabitDetailView(habit: $store.savedHabits[index])) {
                        HabitRowView(habit: store.savedHabits[index])
                    }
                }
                .onDelete(perform: store.deleteHabit)
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { isShowingAddHabit = true } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isShowingAddHabit) {
                        AddHabitView(store: store)
                    }
                }
            }
        }
    }
}

#Preview {
    let previewStore = HabitStore()
    previewStore.savedHabits = [
        Habit(id: UUID(), title: "Gym", description: "Go to gym", completionCount: 1, category: .health, icon: "figure.run", color: .blue, goal: 2),
        Habit(id: UUID(), title: "Swift", description: "Learn SwiftUI", completionCount: 10, category: .education, icon: "book.fill", color: .green, goal: 10)
    ]
    return ContentView(store: previewStore)
}
