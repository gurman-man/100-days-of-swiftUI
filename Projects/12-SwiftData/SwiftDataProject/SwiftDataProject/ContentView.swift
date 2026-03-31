//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by mac on 28.03.2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    // modelContext — це "робоча область", через яку ми додаємо/видаляємо дані
    @Environment(\.modelContext) var modelContext
    
    // Стан для фільтрації (тільки майбутні чи всі)
    @State private var showingUpcomingOnly = false
    
    // Стан для сортування (за замовчуванням: Ім'я, потім Дата)
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate)
    ]
    
    var body: some View {
        NavigationStack {
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
            .navigationTitle("Users")
            .toolbar {
                Button("Add Samples", systemImage: "plus") {
                    // Видаляє ВСІ об'єкти типу User з бази одним махом
                    try? modelContext.delete(model: User.self)
                    
                    // 86400 — це кількість секунд в одній добі (24 * 60 * 60)
                    // -10 — це дата "10 днів тому" від поточної
                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                    let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                    let fourth = User(name: "Johnyy English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                    
                    modelContext.insert(first)
                    modelContext.insert(second)
                    modelContext.insert(third)
                    modelContext.insert(fourth)
                }
                
                // Перемикач фільтрації
                Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                    showingUpcomingOnly.toggle()
                }
                
                // Меню вибору сортування
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([SortDescriptor(\User.name), SortDescriptor(\User.joinDate)])
                        
                        Text("Sort by Join Date")
                            .tag([SortDescriptor(\User.joinDate), SortDescriptor(\User.name)])
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
