//
//  ExpenseItem.swift
//  iExpense-SwiftData
//
//  Created by mac on 31.03.2026.
//

import Foundation
import SwiftData
import SwiftUICore

// ✅ Day 59.1: Перехід на SwiftData
@Model
class ExpenseItem {
    // БУЛО: struct з протоколами Codable та Identifiable.
    // СТАЛО: @Model перетворює клас на таблицю бази даних.
    // SwiftData сам генерує унікальні ID, тому 'id = UUID()' більше не потрібен.
    
    var name: String
    var type: String
    var amount: Double
    
    // ✅ Day 38.2: Динамічний колір залежно від суми
    var color: Color {
        switch amount {
        case ..<10:     return .green
        case 10..<100:  return .blue
        default:        return .red
        }
    }
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
