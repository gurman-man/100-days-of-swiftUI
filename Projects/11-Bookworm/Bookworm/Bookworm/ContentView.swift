//
//  ContentView.swift
//  Bookworm
//
//  Created by mac on 17.03.2026.
//

import SwiftData
import SwiftUI

// можливість відображення AddBookView та приховування під час додавання книг
struct ContentView: View {
    @Environment(\.modelContext) var modelContext // для видалення книг
    @Query var books: [Book] // для зчитування книг
    
    @State private var showingAddScreen = false // для відстеження чи відображається вікно
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Count: \(books.count)")
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
}

#Preview {
    ContentView()
}
