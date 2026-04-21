//
//  ContentView.swift
//  FriendFace
//
//  Created by mac on 06.04.2026.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var users = [User]()
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
        // Уникаємо повторного запиту, якщо дані вже є
        guard users.isEmpty else { return }
        
        do {
            let fetchedUsers = try await manager.loadData()
            users = fetchedUsers // Оновлюємо наш стан
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
    ContentView()
}
