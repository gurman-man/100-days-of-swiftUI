//
//  Book.swift
//  Bookworm
//
//  Created by mac on 19.03.2026.
//

import Foundation
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var date: Date = Date.now
    
    init(title: String, author: String, genre: String, review: String, rating: Int, date: Date = .now) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.date = date
    }
}

// Challenge 1
extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
