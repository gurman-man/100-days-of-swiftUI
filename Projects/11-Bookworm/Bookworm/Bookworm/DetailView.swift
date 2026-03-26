//
//  DetailView.swift
//  Bookworm
//
//  Created by mac on 22.03.2026.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    @Environment(\.modelContext) var modelContext // щоб могли видаляти дані
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack { // Контент всередині ScrollView
                    ZStack(alignment: .bottomTrailing) {
                        Image(book.genre)
                            .resizable()
                            .scaledToFit()
                        
                        Text(book.genre.uppercased())
                            .fontWeight(.black)
                            .padding(8)
                            .foregroundStyle(.white)
                            .background(.black.opacity(0.75))
                            .clipShape(.capsule)
                            .offset(x: -5, y: -5)
                    }
                    
                    Text(book.author)
                        .font(.title)
                        .foregroundStyle(.secondary)
                        .padding()
                    
                    Text(book.review)
                        .padding()
                }
            }
            
            VStack {
                Divider().padding(.horizontal)
                
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                    .padding(.vertical, 8) // Невеликий відступ зверху/знизу
                
                Divider().padding(.horizontal)
                
                // Challenge 3
                Text(book.date.formatted(date: .long, time: .shortened))
                    .font(.subheadline)
                    .italic()
                    .padding(.vertical, 20)
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
    }
    
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    do {
        // 1. Конфігурація: зберігаємо дані лише в оперативній пам'яті (RAM)
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        // 2. Сховище: ініціалізуємо базу даних для моделі Book
        let container = try ModelContainer(for: Book.self, configurations: config)
        
        // 3. Mock Data: створюємо тестовий об'єкт для відображення
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book; I really enjoyed it!", rating: 4, date: .now)
        
        // 4. Ін'єкція: передаємо дані у View та підключаємо до контейнера
        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed tp create preview:  \(error.localizedDescription)")
    }
}
