//
//  ContentView.swift
//  FriendFace
//
//  Created by mac on 06.04.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var users = [User]()
    @State private var manager = NetworkManager()
    
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                // Додаємо NavigationLink для переходу до деталей
                NavigationLink(value: user) {
                    HStack(spacing: 20) {
                        // 1. Статус індикатор
                        Circle()
                            .fill(user.isActive ? .blue : .secondary)
                            .strokeBorder(.ultraThickMaterial)
                            .shadow(color: user.isActive ? .blue : .clear ,radius: 2)
                            .frame(width: 25, height: 25)
                        
                        VStack (alignment: .leading, spacing: 5) {
                            // 2. Ім'я та Компанія
                            Text(user.name)
                                .font(.system(.body, design: .rounded))
                                .bold()
                            
                            HStack(spacing: 5) {
                                    Image(systemName: "building.2")
                                        .font(.caption)
                                    Text(user.company)
                                        .font(.subheadline)
                                }
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .cardStyle(material: AnyShapeStyle(.ultraThickMaterial), shadowColor: .blue.opacity(0.5))
            }
            .navigationTitle("FriendFace")
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                        colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
            )
            .navigationDestination(for: User.self) { user in
                DetailView(user: user)
            }
            .task {
                guard users.isEmpty else { return }
                
                do {
                    let fetchedUsers = try await manager.loadData()
                    users = fetchedUsers // Оновлюємо наш стан
                } catch {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
            .alert("Downloading error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
}


#Preview {
    ContentView()
}
