//
//  EditUserView.swift
//  SwiftDataProject
//
//  Created by mac on 28.03.2026.
//

import SwiftData
import SwiftUI

struct EditUserView: View {
    // @Bindable дозволяє створювати прямі зв'язки ($) до властивостей об'єкта @Model
    @Bindable var user: User
    
    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    //  Створюжмо тимчасову модель контейнера для відображення SwiftUI Preview

    do {
        // 1. Конфігурація: зберігаємо дані лише в оперативній пам'яті (RAM)
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        // 2. Сховище: ініціалізуємо базу даних для моделі User
        let container = try ModelContainer(for: User.self, configurations: config)
        
        // 3. Mock Data: створюємо тестовий об'єкт для відображення
        let user = User(name: "Taylor Swift", city: "Nashville", joinDate: .now)
        
        // 4. Ін'єкція: передаємо дані у View та підключаємо до контейнера
        return EditUserView(user: user)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
