//
//  UserView.swift
//  SwiftDataProject
//
//  Created by mac on 29.03.2026.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    // Масив користувачів, який SwiftData буде автоматично оновлювати
    @Query var users: [User]
    
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
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
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
