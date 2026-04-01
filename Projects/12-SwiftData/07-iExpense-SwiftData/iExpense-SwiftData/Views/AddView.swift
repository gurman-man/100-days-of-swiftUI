//
//  AddView.swift
//  iExpense
//
//  Created by mac on 12.02.2026.
//

import SwiftUI

struct AddView: View {
    // НОВЕ: modelContext — це наш "менеджер" для роботи з базою (додавання/видалення)
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    
    // ✅ Day 46.2: Редагування назви прямо в Navigation Title
    @State private var name = "New Expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    // БУЛО: Ми передавали сюди клас Expenses.
    // СТАЛО: AddView тепер незалежний і сам знає, куди зберігати дані.
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        Form {
            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text("\($0)")
                }
            }
            TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "UAH")).keyboardType(.decimalPad)
        }
        .navigationTitle($name) // ✅ Day 46.2: Binding до Title
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // ✅ Day 46.1: Приховуємо кнопку "Назад"
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    // БУЛО: expenses.items.append(item) (збереження через UserDefaults).
                    // СТАЛО: Вставляємо об'єкт у контекст бази, SwiftData збереже його автоматично.
                    modelContext.insert(item)
                    dismiss()
                }
                .disabled(name.isEmpty) // перевірка на пустий заголовок
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss() // ✅ Day 46.1: Явний вибір скасування
                }
            }
        }
    }
}

#Preview {
    AddView()
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
