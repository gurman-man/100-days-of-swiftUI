//
//  ContentView.swift
//  iExpense
//
//  Created by mac on 11.02.2026.
//

import SwiftUI

// Модель даних для однієї витрати. Identifiable дозволяє ForEach працювати без id: \.self
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

// Клас для зберігання списку витрат
// @Observable робить клас "розумним": SwiftUI автоматично оновить інтерфейс, коли список items зміниться
@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet { // спостерігач властивості
            // 1. Намагаємося перетворити (encode) масив об'єктів у формат JSON
            if let encoded = try? JSONEncoder().encode(items) {
                // 2. Зберігаємо цей JSON у сховище UserDefaults під ключем "Items"
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    // Ініціалізатор (спрацьовує один раз при створенні Expenses)
    init() {
        // 1. Намагаємося дістати дані з UserDefaults за тим самим ключем
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            
            // 2. Намагаємося перетворити (decode) JSON назад у масив [ExpenseItem]
            if let decodedItems = try? decoder.decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false // Стан для керування 2 екраном
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        // Challenge 1
                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "UAH"))
                        // Challenge 2
                            .foregroundStyle(color(for: item.amount))
                            .fontWeight(item.amount > 100 ? .bold : .regular)
                    }
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
    
    func color(for amount: Double) -> Color {
        if amount < 10 {
            return .green
        } else if amount < 100 {
            return .blue
        } else {
            return .red
        }
    }
}

#Preview {
    ContentView()
}
