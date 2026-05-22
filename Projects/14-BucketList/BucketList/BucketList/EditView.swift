//
//  EditView.swift
//  BucketList
//
//  Created by mac on 17.05.2026.
//

import SwiftUI

struct EditView: View {
    // Перелік усіх можливих станів завантаження для UI
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location // Локація, яку редагуємо
    
    // Замикання (closure), яке викликається при натисканні "Save" та приймає оновлену локацію
    var onSave: (Location) -> Void
    
    @State private var loadingState = LoadingState.loading // Початковий стан — завантаження
    @State private var pages = [Page]() // Масив для збереження отриманих сторінок
    
    // Тимчасові стани для збереження тексту з текстових полів
    @State private var name: String
    @State private var description: String
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // Секція для редагування назви та опису
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                // Секція для відображення цікавих місць поруч
                Section("Nearby...") {
                    switch loadingState {
                    case .loading:
                       Text("Loading...")
                    case .loaded:
                        // Виводимо знайдені сторінки Вікіпедії
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            
                            + Text(": ") // Оператор "+" склеює Text в один рядок із різними стилями
                            
                            + Text(page.description)
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
                    // Створюємо нову копію локації з новими даними та свіжим UUID (щоб оновити карту)
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation) // Передаємо дані назад у ContentView
                    dismiss() // Закриваємо шіт
                }
            }
            // Викликаємо асинхронне завантаження місць при появі екрана
            .task { await fetchNearbyPlaces() }
        }
    }
    
    // Кастомний ініціалізатор: потрібен для передачі даних з моделі в @State
    // @escaping означає, що closure буде збережено в пам'яті й викликано пізніше
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave // зберігає назву та опис локації у пам'ять
        
        // Ініціалізація Property Wrappers через підкреслення (_name, _description)
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    // Асинхронна функція для завантаження даних з Wikipedia
    func fetchNearbyPlaces() async {
        // Формуємо URL-рядок, підставляючи координати поточної локації
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            // Виконуємо мережевий запит
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Декодуємо отриманий JSON у наші структури
            let items = try JSONDecoder().decode(Result.self, from: data)
            
            // Успіх - конвертуємо наші значення масиву у масив сторінок та сортуємо за алфавітом (завдяки Comparable)
            pages = items.query.pages.values.sorted()
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
