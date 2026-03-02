//
//  HabitStore.swift
//  HabitTracker
//
//  Created by mac on 02.03.2026.
//

import SwiftUI

@Observable
class HabitStore {
    var savedHabits: [Habit] = [] {
        didSet {
            save() // Автозбереження при будь-якій зміні масиву
        }
    }
    
    private let saveKey = "SavedHabits"
    
    init() {
        load() // Завантажуємо при старті
    }
    
    // Збереження через UserDefaults (Кодуємо в JSON)
    func save() {
        if let encoded = try? JSONEncoder().encode(savedHabits) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    // Завантаження (Декодуємо з JSON)
    func load() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Habit].self, from: savedData) {
                savedHabits = decoded
                return
            }
        }
        savedHabits = [] // Якщо даних немає
    }
    
    func addHabit(_ habbit: Habit) {
        savedHabits.append(habbit)
    }
    
    func deleteHabit(at offsets: IndexSet) {
        savedHabits.remove(atOffsets: offsets)
    }
    
    // Оновлення лічильника
    func updateCount(for habit: Habit) {
        if let index = savedHabits.firstIndex(where: { $0.id == habit.id }) {
            savedHabits[index].completionCount += 1
        }
    }
}

