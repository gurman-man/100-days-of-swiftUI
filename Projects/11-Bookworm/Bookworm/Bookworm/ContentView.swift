//
//  ContentView.swift
//  Bookworm
//
//  Created by mac on 17.03.2026.
//

/*
    MARK: - Challenges - DAY 56
 
    1. Right now it’s possible to select no title, author, or genre for books, which causes a problem for the detail view. Please fix this, either by forcing defaults, validating the form, or showing a default picture for unknown genres – you can choose.
 
    2. Modify ContentView so that books rated as 1 star are highlighted somehow, such as having their name shown in red.
 
    3. Add a new “date” attribute to the Book class, assigning Date.now to it so it gets the current date and time, then format that nicely somewhere in DetailView.
*/

import SwiftData
import SwiftUI

// можливість відображення AddBookView та приховування під час додавання книг
struct ContentView: View {
    @Environment(\.modelContext) var modelContext // для видалення книг
    
    // Для зчитування книг та сортування
    @Query(sort: [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ])  var books: [Book]
    
    @State private var showingAddScreen = false // для відстеження чи відображається вікно
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                        }
                        // Challenge 2
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                                .foregroundStyle(book.rating == 1 ? .red : .primary)
                            Text(book.author)
                                .foregroundStyle(book.rating == 1 ? .red : .secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: Book.self, destination: { book in
                DetailView(book: book)
            })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
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
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find book in our query
            let book = books[offset]
            
            // delete it from the context
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
