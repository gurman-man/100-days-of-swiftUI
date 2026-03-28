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
    
    // @Query автоматично оновлює список при будь-яких змінах у базі даних
    // Макрос #Predicate перетворює твій код Swift на запит, який зрозуміє база даних
    @Query(filter: #Predicate<User> { user in
        // localizedStandardContains — розумний пошук (ігнорує регістр: "R" == "r")
        user.name.localizedStandardContains("R") &&
        user.city == "London"
    }, sort: \User.name) var users: [User]
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                Text(user.name)
            }
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
            }
        }
    }
}

#Preview {
    ContentView()
}
