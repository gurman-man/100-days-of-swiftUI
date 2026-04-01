//
//  iExpenseApp.swift
//  iExpense
//
//  Created by mac on 11.02.2026.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // НОВЕ: .modelContainer створює файл бази даних на диску
        // та забезпечує доступ до нього для всього додатка.
        .modelContainer(for: ExpenseItem.self)
    }
}
