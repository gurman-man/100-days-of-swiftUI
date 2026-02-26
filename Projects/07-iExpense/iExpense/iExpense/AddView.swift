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
    
    @State private var name = "New Expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    // Посилання на існуючий екземпляр класу Expenses
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        Form {
            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text("\($0)")
                }
            }
            // Challenge 1
            TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "UAH")).keyboardType(.decimalPad)
        }
        // Extra challenge 2 - Day 46
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        
        // Extra challenge 1 - Day 46
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
                .disabled(name.isEmpty) // перевірка на пустий заголовок
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
