//
//  ContentView.swift
//  iExpense
//
//  Created by mac on 11.02.2026.
//

import SwiftUI

// Модель даних для однієї витрати. Identifiable дозволяє ForEach працювати без id: \.self
struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

// Клас для зберігання списку витрат
// @Observable робить клас "розумним": SwiftUI автоматично оновить інтерфейс, коли список items зміниться
@Observable
class Expenses {
    var items = [ExpenseItem]()
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false // Стан для керування 2 екраном
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) {
                    Text("\($0.name)")
                }
                .onDelete(perform: removeItems) // Додаємо можливість видалення свайпом
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            // Викликаємо AddView та ПЕРЕДАЄМО йому наш об'єкт expenses
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
