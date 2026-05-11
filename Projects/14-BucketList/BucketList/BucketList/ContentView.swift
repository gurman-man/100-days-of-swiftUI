//
//  ContentView.swift
//  BucketList
//
//  Created by mac on 11.05.2026.
//

import SwiftUI

struct User: Identifiable, Comparable {
    // Функція для Comparable: визначає логіку "менше ніж" (<)
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    let id = UUID()
    var firstName: String
    var lastName: String
}

struct ContentView: View {
    // Завдяки Comparable ми можемо просто викликати .sorted() в кінці масиву
    // Swift автоматично використає функцію < , яку ми описали вище
    let users = [
        User(firstName: "Arnold", lastName: "Rimmer"),
        User(firstName: "Kristine", lastName: "Kochanski"),
        User(firstName: "David", lastName: "Lister")
    ].sorted()
    
    var body: some View {
        List(users) { user in
            Text("\(user.lastName), \(user.firstName)")
        }
    }
}

#Preview {
    ContentView()
}
