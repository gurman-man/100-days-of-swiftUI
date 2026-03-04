//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by mac on 03.03.2026.
//

import SwiftUI

struct AddHabitView: View {
    // Додаємо dismiss, щоб закривати екран після збереження
    @Environment(\.dismiss) var dismiss
    
    var store: HabitStore
    
    let columns = [
        GridItem(.adaptive(minimum: 55), spacing: 15)
    ]
    
    @State private var mainTitle = "Add a new habit"
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: HabitCategory = .health
    @State private var selectedColor: HabitColor = .blue
    @State private var selectedIcon = "figure.run"
    @State private var goal = 1
    
    var body: some View {
        NavigationStack {
            Form {
                Section("DETAILS") {
                    TextField("Habit title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section("CATEGORY") {
                    Picker("Select category", selection: $selectedCategory) {
                        ForEach(HabitCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section("GOAL") {
                    Stepper("Do \(goal) times", value: $goal, in: 1...100)
                    
                    ProgressView(value: Double(goal), total: 100)
                        .progressViewStyle(.linear)
                }
                
                Section("CHOOSE iCON") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (spacing: 15) {
                            ForEach(selectedCategory.icons, id: \.self) { icon in
                                Image(systemName: icon)
                                    .foregroundStyle(selectedIcon == icon ? selectedColor.swiftUIColor : .primary)
                                    .frame(width: 50, height: 50)
                                    .background(selectedIcon == icon ? selectedColor.swiftUIColor.opacity(0.1) : Color.clear)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        withAnimation(.interpolatingSpring()) {
                                            selectedIcon = icon
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                    }
                }
                
                Section("COLOR SCHEME") {
                    LazyVGrid(columns: columns) {
                        ForEach(HabitColor.allCases, id: \.self) { habitColor in
                            ZStack {
                                Circle()
                                    .fill(habitColor.swiftUIColor)
                                    .frame(width: 40, height: 40)
                                
                                if selectedColor == habitColor {
                                    Circle()
                                        .stroke(habitColor.swiftUIColor, lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                }
                            }
                            .frame(width: 55, height: 55)
                            .onTapGesture {
                                withAnimation { selectedColor = habitColor }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
                
            }
            .navigationTitle($mainTitle)
            .navigationBarTitleDisplayMode(.inline)
            
            .onChange(of: selectedCategory) {
                selectedIcon = selectedCategory.icons.first ?? "questionmark"
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let newHabit = Habit(
                            id: UUID(),
                            title: title,
                            description: description,
                            completionCount: 0,
                            category: selectedCategory,
                            icon: selectedIcon,
                            color: selectedColor,
                            goal: goal
                            
                        )
                        store.addHabit(newHabit)
                        dismiss()
                    }
                    .disabled(title.isEmpty) // Кнопка не активна, поки немає назви
                }
            }
        }
    }
}

#Preview {
    let previewStore = HabitStore()
    AddHabitView(store: previewStore)
}
