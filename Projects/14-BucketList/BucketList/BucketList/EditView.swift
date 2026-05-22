//
//  EditView.swift
//  BucketList
//
//  Created by mac on 17.05.2026.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    // Замикання (closure), яке викликається при натисканні "Save" та приймає оновлену локацію
    var onSave: (Location) -> Void
    
    @State private var loadingState = LoadingState.loading // для відображення стану завантаження
    @State private var pages = [Page]() // для зберігання сторінок з Wikipedia
    
    @State private var name: String
    @State private var description: String
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby...") {
                    switch loadingState {
                    case .loading:
                       Text("Loading...")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            
                            + Text(": ") + // використання + дозволить адаптуватися до різних типів форматування
                            
                            Text("Page description here")
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation) // Передаємо дані назад у ContentView
                    dismiss() // Закриваємо шіт
                }
            }
            .task { await fetchNearbyPlaces() } // виклик запиту у Wikipedia
        }
    }
    
    // Кастомний ініціалізатор: потрібен для передачі даних з моделі в @State
    // @escaping означає, що closure буде збережено в пам'яті й викликано пізніше
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave // зберігає назву та опис локації у пам'ять
        
        // Використовуємо підкреслення, щоб налаштувати сам Property Wrapper
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    // Головна функція для отримання даних із Wikipedia
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            
            // Успіх - конвертуємо наші значення масиву у масив сторінок
            pages = items.query.pages.values.sorted { $0.title < $1.title }
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
}

#Preview {
    // { _ in } — пуста заглушка для closure, оскільки в Preview нам не потрібно реально зберігати дані
    EditView(location: .example, onSave: { _ in })
}
