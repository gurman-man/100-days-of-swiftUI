//
//  Habit.swift
//  HabitTracker
//
//  Created by mac on 02.03.2026.
//

import Foundation

struct Habit: Codable, Identifiable {
    let id: UUID
    var title: String
    var description: String
    var completionCount: Int
    let category: HabitCategory
}

enum HabitCategory: String, Codable {
    case health = "Health"
    case work = "Work"
    case hobby = "Hobby"
    case education = "Education"
}
