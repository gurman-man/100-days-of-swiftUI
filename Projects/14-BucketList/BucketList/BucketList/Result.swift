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

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}

