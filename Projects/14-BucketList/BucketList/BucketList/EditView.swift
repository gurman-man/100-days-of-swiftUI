//
//  EditView.swift
//  BucketList
//
//  Created by mac on 17.05.2026.
//

import SwiftUI

struct EditView: View {
    
    // Стан керується виключно нашою ViewModel
    @State private var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
    
    // Замикання (closure), яке викликається при натисканні "Save" та приймає оновлену локацію
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // Секція для редагування назви та опису
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                // Секція для відображення цікавих місць поруч
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                       Text("Loading...")
                    case .loaded:
                        // Виводимо знайдені сторінки Вікіпедії
                        ForEach(viewModel.pages, id: \.pageid) { page in
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
                    // Забираємо готову локацію з ViewModel, передаємо в ContentView та закриваємо екран
                    onSave(viewModel.updateLocation)
                    dismiss()
                }
            }
            // Викликаємо асинхронний метод моделі відразу при відкритті екрана
            .task { await viewModel.fetchNearbyPlaces() }
        }
    }
    
    // Кастомний ініціалізатор: зв'язує вхідні дані з ContentView з нашою ViewModel
    // @escaping означає, що closure буде збережено в пам'яті й викликано пізніше
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave // зберігає назву та опис локації у пам'ять
        
        // Використовуємо підкреслення (_viewModel), щоб вручну створити State з початковим значенням моделі
        _viewModel = State(initialValue: ViewModel(location: location))
        
    }
}

#Preview {
    // { _ in } — пуста заглушка для closure, оскільки в Preview нам не потрібно реально зберігати дані
    EditView(location: .example, onSave: { _ in })
}
