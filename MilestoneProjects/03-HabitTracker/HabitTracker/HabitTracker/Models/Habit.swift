//
//  Habit.swift
//  HabitTracker
//
//  Created by mac on 02.03.2026.
//

import SwiftUI

struct Habit: Codable, Identifiable {
    let id: UUID
    var title: String
    var description: String
    var completionCount: Int
    let category: HabitCategory
    var icon: String
    var color: HabitColor
    var goal: Int
}

enum HabitCategory: String, Codable, CaseIterable {
    case health = "Health"
    case work = "Work"
    case hobby = "Hobby"
    case education = "Education"
    
    var icons: [String] {
        switch self {
        case .health: return ["figure.run", "figure.walk", "dumbbell.fill", "heart.fill", "flame.fill"]
        case .work: return ["laptopcomputer", "calendar", "paperplane.fill", "briefcase.fill", "doc.text.fill"]
        case .hobby: return ["paintpalette.fill", "camera.fill", "gamecontroller.fill", "music.note", "bicycle"]
        case .education: return ["book.fill", "pencil", "brain", "graduationcap.fill", "lightbulb.fill"]
        }
    }
}

enum HabitColor: String, Codable, CaseIterable {
    case red, orange, yellow, green, mint, teal, blue, indigo, purple, pink, gray, brown
    
    var swiftUIColor: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .mint: return .mint
        case .teal: return .teal
        case .blue: return .blue
        case .indigo: return .indigo
        case .purple: return .purple
        case .pink: return .pink
        case .gray: return .gray
        case .brown: return .brown
        }
    }
}
