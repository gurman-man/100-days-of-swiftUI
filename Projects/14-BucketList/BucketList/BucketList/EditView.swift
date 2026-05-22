//
//  EditView.swift
//  BucketList
//
//  Created by mac on 17.05.2026.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    // Замикання (closure), яке викликається при натисканні "Save" та приймає оновлену локацію
    var onSave: (Location) -> Void
    
    @State private var name: String
    @State private var description: String
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
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
}

#Preview {
    // { _ in } — пуста заглушка для closure, оскільки в Preview нам не потрібно реально зберігати дані
    EditView(location: .example, onSave: { _ in })
}
