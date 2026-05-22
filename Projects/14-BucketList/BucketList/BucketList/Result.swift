//
//  Result.swift
//  BucketList
//
//  Created by mac on 22.05.2026.
//

import Foundation

// Головний контейнер відповіді від Wikipedia API
struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    // Вікіпедія віддає дані у форматі "ID_Сторінки": { дані сторінки }
    let pages: [Int: Page]
}

// Модель сторінки. Conforming до Comparable дозволяє сортувати масив сторінок автоматично
struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    // Обчислювальна властивість: безпечно дістає опис або повертає заглушку, якщо опису немає
    var description: String {
        terms?["description"]?.first ?? "No funther information"
    }
    
    // Обов'язковий метод для протоколу Comparable: сортуємо сторінки за алфавітом (за назвою)
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}

