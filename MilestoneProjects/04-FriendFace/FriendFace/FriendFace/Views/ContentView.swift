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
                Text(user.name)
            }
            .navigationTitle("FriendFace")
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
