//
//  AddView.swift
//  iExpense
//
//  Created by mac on 12.02.2026.
//

import SwiftUI

struct AddView: View {
    // Локальні стани для збереження значень полів введення
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    // Посилання на існуючий екземпляр класу Expenses
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                List {
                    Section("Personal") {
                        ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                            // Твій дизайн рядка тут
                        }
                        .onDelete { offsets in
                            removeItems(at: offsets, in: "Personal")
                        }
                    }

                    Section("Business") {
                        ForEach(expenses.items.filter { $0.type == "Business" }) { item in
                            // Твій дизайн рядка тут
                        }
                        .onDelete { offsets in
                            removeItems(at: offsets, in: "Business")
                        }
                    }
                }
                
                TextField("Amount",
                          value: $amount,
                          // Challenge 1
                          format: .currency(code: Locale.current.currency?.identifier ?? "UAH")).keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, in sectionType: String) {
        // 1. Створюємо тимчасовий масив тільки тих елементів, які ми бачимо в цій секції
        let filteredItems = expenses.items.filter { $0.type == sectionType }
        
        for offset in offsets {
            // 2. Знаходимо конкретний об'єкт, який хочемо видалити
            let itemToDelete = filteredItems[offset]
            
            // 3. Знаходимо індекс цього об'єкта в ОСНОВНОМУ масиві за його унікальним ID
            if let index = expenses.items.firstIndex(where: { $0.id == itemToDelete.id }) {
                expenses.items.remove(at: index)
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
