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
    @Query(sort: \User.name) var users: [User]
    
    // Path - "шлях" у який ми передаємо об'єкт User для переходу
    @State private var path = [User]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(users) { user in
                NavigationLink(value: user) {
                    Text(user.name)
                }
            }
            .navigationTitle("Users")
            .navigationDestination(for: User.self) { user in
                EditUserView(user: user)
            }
            .toolbar {
                Button("Add User", systemImage: "plus") {
                    let user = User(name: "", city: "", joinDate: .now)
                    modelContext.insert(user)   // Додаємо в контекст (пам'ять)
                    path = [user]
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
