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
    
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
