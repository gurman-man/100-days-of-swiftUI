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

// MARK: - Extra Challenges - Day46

/*
    1. Change project 7 (iExpense) so that it uses NavigationLink for adding new expenses rather than a sheet. (Tip: The dismiss() code works great here, but you might want to add the navigationBarBackButtonHidden() modifier so they have to explicitly choose Cancel.)
 
    2. Try changing project 7 so that it lets users edit their issue name in the navigation title rather than a separate textfield. Which option do you prefer?
*/


// MARK: - Extra Challenges - Day59

/*
    1. Start by upgrading it to use SwiftData.
 
    2. Add a customizable sort order option: by name or by amount.
 
    3. Add a filter option to show all expenses, just personal expenses, or just business expenses.
*/


// MARK: - Implementation

import SwiftUI
import SwiftData


struct ContentView: View {
    // ✅ Day 59.2: Збереження обраного сортування
    // Стан для сортуванння (за замовчуванням: Сума, потім Назва)
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.amount),
        SortDescriptor(\ExpenseItem.name)
    ]
    
    // ✅ Day 59.3: Збереження обраного фільтру
    @State private var filterType = "All"
    
    var body: some View {
        NavigationStack {
            // Весь список зі своєю логікою видалення тепер тут:
            ExpensesList(filter: filterType, sort: sortOrder)
                .navigationTitle("iExpense")
                .toolbar {
                    // ✅ Day 46.1: NavigationLink замість Sheet
                    NavigationLink {
                        AddView() // Тепер порожні дужки, бо AddView сам знає, що робити
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                    
                    
                    // ✅ Day 59.3: Керування фільтрацією
                    Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Filter", selection: $filterType) {
                            Text("Show All").tag("All")
                            Text("Personal").tag("Personal")
                            Text("Business").tag("Business")
                        }
                    }
                    
                    
                    // ✅ Day 59.2: Керування сортуванням
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by Amount")
                                .tag([SortDescriptor(\ExpenseItem.amount), SortDescriptor(\ExpenseItem.name)])
                            Text("Sort by Name")
                                .tag([SortDescriptor(\ExpenseItem.name), SortDescriptor(\ExpenseItem.amount)])
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
