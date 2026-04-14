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
                            .fill(user.isActive ? .green : .secondary)
                            .strokeBorder(.ultraThickMaterial)
                            .shadow(color: user.isActive ? .green : .clear ,radius: 2)
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
            }
            .navigationTitle("FriendFace")
            .navigationDestination(for: User.self) { user in
                Text("Detail for\n\(user.name)").bold()
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
