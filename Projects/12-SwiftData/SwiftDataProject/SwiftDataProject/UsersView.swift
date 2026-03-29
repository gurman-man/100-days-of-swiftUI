//
//  UserView.swift
//  SwiftDataProject
//
//  Created by mac on 29.03.2026.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    @Environment(\.modelContext) var modelContext
    
    // Масив користувачів, який SwiftData буде автоматично оновлювати
    @Query var users: [User]
    
    var body: some View {
        List(users) { user in
            
            HStack {
                Text(user.name)
                Spacer()
                
                // Виводимо кількість завдань, які належать цьому юзеру
                Text(String(user.jobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
        .onAppear(perform: addSamples)
    }
    
    // Спеціальний ініціалізатор, який дозволяє змінювати фільтрацію та сортування "на льоту"
    // Макрос #Predicate перетворює твій код Swift на запит, який зрозуміє база даних
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        // Ми звертаємося до самого об'єкта Query через підкреслення (_users),
        // щоб налаштувати його параметри перед відображенням
        _users = Query(
            // Фільтр: показувати лише тих, хто приєднався після вказаної дати
            filter: #Predicate<User> { user in user.joinDate >= minimumJoinDate },
            sort: sortOrder
        )
    }
    
    func addSamples() {
        let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Organize sock drawer", priority: 3)
        let job2 = Job(name: "Make plans with Alex", priority: 4)
        
        modelContext.insert(user1)
        
        // Зв'язуємо об'єкти: просто додаємо завдання в масив користувача
        // SwiftData сама зрозуміє, що user1 тепер є owner для job1 та job2
        user1.jobs.append(job1)
        user1.jobs.append(job2)
    }
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
