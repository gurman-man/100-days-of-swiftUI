//
//  ExpensesList.swift
//  iExpense-SwiftData
//
//  Created by mac on 01.04.2026.
//

import SwiftUI
import SwiftData

struct ExpensesList: View {
    
    // НОВЕ: modelContext — це наш "менеджер" для роботи з базою (додавання/видалення)
    @Environment(\.modelContext) var modelContext
    
    // ✅ Day 59.1: Використання @Query
    // БУЛО: @State var expenses = Expenses() (ініціалізація класу).
    // СТАЛО: @Query — магічний макрос, який сам витягує дані з бази
    // та оновлює екран щоразу, коли дані змінюються.
    @Query var expenses: [ExpenseItem]
    
    var body: some View {
        List {
            // ✅ Day 38.3: Розподіл на секції
            let personal = expenses.filter { $0.type == "Personal"}
            let business = expenses.filter { $0.type == "Business"}
            
            if !personal.isEmpty {
                Section("Personal") {
                    ForEach(personal) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offset in removeItems(at: offset, from: personal)} // Спрощене видалення
                }
            }
            
            if !business.isEmpty {
                Section("Business") {
                    ForEach(business) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offset in removeItems(at: offset, from: business)} // Спрощене видалення
                }
            }
            
        }
    }
    
    
    // ✅ Day 59.2 & 59.3: Динамічне сортування та фільтрація через ініціалізатор
    init(filter: String, sort: [SortDescriptor<ExpenseItem>]) {
        // Ми звертаємо до самого об'єкта Query через підкреслення (_expenses),
        // щоб налаштувати його параметри перед відобраденням
        _expenses = Query(
            filter: #Predicate<ExpenseItem> { item in
                filter == "All" ?  true : item.type == filter
            },
            sort: sort) // Передаємо сортування, яке прийшло з ContentView
    }
    
    
    // ✅ Day 38.3: Безпечне видалення з відфільтрованого списку
    // Метод видалення тепер тут, бо він працює з локальним @Query
    func removeItems(at offsets: IndexSet, from items: [ExpenseItem]) {
        for offset in offsets {
            // Знаходимо конкретний об'єкт у відфільтрованому масиві за індексом і видаляємо його з контексту
            let item = items[offset]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ExpensesList(filter: "Personal", sort: [SortDescriptor(\ExpenseItem.name)])
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
