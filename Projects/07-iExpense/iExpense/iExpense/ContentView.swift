//
//  ContentView.swift
//  iExpense
//
//  Created by mac on 11.02.2026.
//

// MARK: - Challenges - Day38

/*
    1. Use the user’s preferred currency, rather than always using US dollars.

    2. Modify the expense amounts in 'ContentView' to contain some styling depending on their value – expenses under $10 should have one style, expenses under $100 another, and expenses over $100 a third style. What those styles are depend on you.

    3. For a bigger challenge, try splitting the expenses list into two sections: one for personal expenses, and one for business expenses. This is tricky for a few reasons, not least because it means being careful about how items are deleted!
 */

// MARK: - Implementation

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
    @State var expenses = Expenses()
    
    @State private var showingAddExpense = false // Стан для керування 2 екраном
    
    var body: some View {
        NavigationStack {
            List {
                // Challenge 3
                Section("Personal") {
                    ForEach(expenses.items.filter { $0.type == "Personal"}) { item in
                        setupHStack(with: item)
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, in: "Personal")
                    }
                }
            
                // Challenge 3
                Section("Business") {
                    ForEach(expenses.items.filter { $0.type == "Business"}) { item in
                        setupHStack(with: item)
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, in: "Business")
                    }
                }
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
}

extension ContentView {
    func setupHStack(with item: ExpenseItem) -> some View {
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
    
    // Challenge 3
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
    
    // Challenge 2
    func color(for amount: Double) -> Color {
        switch amount {
        case ..<10:     return .green
        case 10..<100:  return .blue
        default:        return .red
        }
    }
}

#Preview {
    ContentView()
}
