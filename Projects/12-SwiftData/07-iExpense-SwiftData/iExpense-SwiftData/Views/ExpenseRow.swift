//
//  ExpenseRow.swift
//  iExpense-SwiftData
//
//  Created by mac on 01.04.2026.
//

import SwiftUI

struct ExpenseRow: View {
    let item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()
            // ✅ Day 38.1: Використання валюти користувача (Locale)
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "UAH"))
            // ✅ Day 38.2: Стилізація суми (колір + шрифт)
                .foregroundStyle(item.color)
                .fontWeight(item.amount > 100 ? .bold : .regular)
        }
    }
}
