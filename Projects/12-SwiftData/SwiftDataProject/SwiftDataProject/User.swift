//
//  User.swift
//  SwiftDataProject
//
//  Created by mac on 28.03.2026.
//

import Foundation
import SwiftData

@Model  // Перетворює клас на схему бази даних та додає підтримку відстеження змін
class User {
    var name: String
    var city: String
    var joinDate: Date
    
    // .cascade — якщо видалити юзера, всі його завдання (jobs) видаляться автоматично
    @Relationship(deleteRule: .cascade) var jobs = [Job]()
    
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
