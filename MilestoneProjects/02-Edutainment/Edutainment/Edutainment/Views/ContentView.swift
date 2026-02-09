//
//  ContentView.swift
//  Edutainment
//
//  Created by mac on 06.02.2026.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var questions = [Question]()
    @State private var isGameActive = false // керує станом навігації між налаштуваннями та грою
    
    @State private var selectedTable = 2
    @State private var questionsCount = 5
    
    // MARK: - Initialization
    
    init() {
        setupNavigationAppearance()
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if isGameActive {
                    GameView(questions: questions) {
                        isGameActive = false
                    }
                } else {
                    ZStack {
                        backgroundGradient
                        
                        VStack(spacing: 5) {
                            Spacer()
                            difficultyTitle
                            Spacer()
                            
                            // Ряди кнопок вибору таблиці множення
                            VStack (spacing: 20) {
                                tables(from: 0, to: 2)
                                tables(from: 3, to: 5)
                                tables(from: 6, to: 8)
                                tables(from: 9, to: 11)
                            }
                        
                            Spacer()
                            questionsPickerSection
                            
                            startButton
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(isGameActive ? "" : "EDUTAINMENT")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Subviews
private extension ContentView {
    
    // Background
    var backgroundGradient: some View {
        LinearGradient(colors: [.red, .yellow, .green], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    // Difficulty Title
    var difficultyTitle: some View {
        Text("Choose difficulty:")
            .fontWeight(.black)
            .foregroundStyle(.white)
            .shadow(color: .black, radius: 1)
    }
    
    // Picker and title
    var questionsPickerSection: some View {
        VStack(spacing: 0) {
            Text("How many questions?")
                .fontWeight(.black)
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 1)
            
            Picker("Questions", selection: $questionsCount) {
                ForEach(GameSettings.questionOptions, id: \.self) {
                    Text("\($0)")
                }
            }
            .pickerStyle(.segmented)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .padding()
            .animation(.spring, value: questionsCount)
        }
    }
    
    // Start Button
    var startButton: some View {
        Button("START ADVENTURE") {
            generateQuestions()
            withAnimation {
                isGameActive = true
            }
        }
        .buttonStyle(.borderedProminent)
        .shadow(color: .black, radius: 1)
        .tint(.orange)
        .font(.system(.title2, design: .rounded).weight(.heavy))
    }
}

// MARK: - Helper Methods

private extension ContentView {
    
    /// Створює індивідуальну кнопку з твариною для вибору таблиці множення
    func animalButton(for index: Int) -> some View {
        let tableNumber = index + 2
        
        return Button {
            selectedTable = tableNumber
            UIImpactFeedbackGenerator(style: .light).impactOccurred() // легка вібрація
            
        } label: {
            VStack {
                Image(GameSettings.animals[index])
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 80)
                
                Text("\(tableNumber)")
                    .font(.system(size: 20) .weight(.semibold))
                    .tint(.white)
                    .shadow(color: .black, radius: 5)
            }
        }
        .scaleEffect(selectedTable == tableNumber ? 1.2 : 1.0)
        .opacity(selectedTable == tableNumber ? 1 : 0.6)
        .animation(.easeOut, value: selectedTable) // додасть плавність
    }
    
    
    /// Формує горизонтальний ряд кнопок вибору таблиці
    func tables(from start: Int, to end: Int) -> some View {
        HStack {
            ForEach(start...end, id: \.self) { index in
                animalButton(for: index)
            }
        }
    }
    
    
    /// Герує масив випадкових питань на основі обраної таблиці
    func generateQuestions() {
        questions.removeAll() // очищаємо старий масив питань
        
        for _ in 0..<questionsCount {
            let num1 = selectedTable
            let num2 = Int.random(in: 2...12)
            
            let text = "\(num1) × \(num2)"
            let newQuestion = Question(text: text, answer: num1 * num2)
            questions.append(newQuestion)
        }
    }
    
    
    /// Налаштування візуального стилю Navigation Bar
    func setupNavigationAppearance() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 22, weight: .ultraLight)
        ]
        UINavigationBar.appearance().standardAppearance = navAppearance
    }
}

#Preview {
    ContentView()
}
