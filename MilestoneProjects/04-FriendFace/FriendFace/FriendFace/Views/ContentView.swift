//
//  ContentView.swift
//  FriendFace
//
//  Created by mac on 06.04.2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    // MARK: - Properties

    @State private var manager = NetworkManager()
    @State private var searchTerm = ""
    
    @State private var errorMessage = ""
    @State private var showingError = false
    
    // Обчислювальна властивість для динамічного пошуку
    var filteredUsers: [User] {
        guard !searchTerm.isEmpty else { return users }
        return users.filter {
            $0.name.localizedCaseInsensitiveContains(searchTerm) ||
            $0.company.localizedCaseInsensitiveContains(searchTerm)
        }
    }
    
    // Контекст для збереження та видалення даних (запис у базу)
    @Environment(\.modelContext) var modelContext
    
    // Автоматично завантажений та відсортований список з бази (читання)
    @Query(sort: \User.age) var users: [User]
    
    var body: some View {
        NavigationStack {
            mainList
                .navigationTitle("FriendFace")
                .navigationDestination(for: User.self) { user in
                    DetailView(user: user)
                }
                .searchable(text: $searchTerm, placement: .automatic, prompt: "Looking for")
                // Завантаження даних при появі екрана
                .task { await loadUsers() }
                .alert("Downloading error", isPresented: $showingError) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage)
                }
        }
    }
    
    
    // MARK: - Subviews
    
    private var mainList: some View {
        List(filteredUsers) { user in
            NavigationLink(value: user) {
                UserRowView(user: user)
            }
            // Кастомний Glassmorphism стиль для рядків
            .cardStyle(material: AnyShapeStyle(.ultraThickMaterial), shadowColor: .blue.opacity(0.5))
        }
        .scrollContentBackground(.hidden)
        .background(backgroundGradient)
    }
    
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3), .clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    
    // MARK: - Logic
    
    private func loadUsers() async {
        // 1. Перевіряємо, чи база не порожня
        guard users.isEmpty else { return }
        
        do {
            // 2. Отримуємо дані через NetworkManager
            let fetchedUsers = try await manager.loadData()
            
            // 3. Вставляємо кожного юзера в контекст
            // SwiftData сама зрозуміє, що їх треба зберегти
            for user in fetchedUsers {
                modelContext.insert(user)
            }
            
            // Після циклу SwiftData побачить зміни, і @Query автоматично
            // оновить твій список у UI.
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}


// MARK: - Helper Views

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 20) {
            statusIndicator
            
            VStack (alignment: .leading, spacing: 5) {
                // Ім'я
                Text(user.name)
                    .font(.system(.body, design: .rounded))
                    .bold()
                
                // Компанія
                HStack(spacing: 5) {
                    Image(systemName: "building.2")
                        .font(.caption)
                    Text(user.company)
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    // Індикатор статусу з неоновим ефектом для активних користувачів
    private var statusIndicator: some View {
        Circle()
            .fill(user.isActive ? .blue : .secondary)
            .strokeBorder(.ultraThickMaterial, lineWidth: 2)
            .shadow(color: user.isActive ? .blue : .clear ,radius: 2)
            .frame(width: 25, height: 25)
    }

}


#Preview {
    // 1. Використовуємо MainActor, щоб гарантувати правильний потік для контейнера
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: User.self, configurations: config)
        return container
    }()
    
    // 2. Створюємо друзів
    let f1 = Friend(id: "1", name: "Nazar")
    let f2 = Friend(id: "2", name: "Katya")
    let f3 = Friend(id: "3", name: "Vitaliy")
    let f4 = Friend(id: "4", name: "Diana")
    let f5 = Friend(id: "5", name: "Marki")
    
    // 3. Створюємо приклад юзера
    let example = User(
        id: "1",
        isActive: true,
        name: "Maksym",
        age: 21,
        company: "Native",
        email: "max@gmail.com",
        address: "Ternopil",
        about: "Bio",
        registered: .now,
        tags: ["boyfriend", "dude"],
        friends: [f1, f2, f3, f4, f5]
    )
    
    // 4. Вставляємо дані в контекст контейнера
    container.mainContext.insert(example)
    
    // 5. ПОВЕРТАЄМО VIEW
    return ContentView()
        .modelContainer(container)
}
