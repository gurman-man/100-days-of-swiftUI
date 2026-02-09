//
//  ContentView.swift
//  Edutainment
//
//  Created by mac on 06.02.2026.
//

import SwiftUI

struct Question {
    var text: String
    var answer: Int
}

struct ContentView: View {
    @State var tableButtons: [String] = ["chick", "chicken", "crocodile", "cow", "buffalo", "elephant", "giraffe", "hippo", "sloth", "parrot", "frog", "zebra"]
    
    @State private var questions = [Question]()
    @State private var isGameActive = false // перемикатиме нас з екрана налаштувань на екран гри.
    
    @State private var selectedTable = 2
    @State private var questionsCount = 5
    private let questionOptions = [5, 10, 20]
    
    init() {
        // Кастомізація заголовка
        let navAppearance = UINavigationBarAppearance()
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 22, weight: .ultraLight)
        ]
        UINavigationBar.appearance().standardAppearance = navAppearance
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if isGameActive {
                    GameView(questions: questions) {
                        // Закриє гру, коли дитина натисне "Give up"
                        isGameActive = false
                    }
                } else {
                    ZStack {
                        LinearGradient(colors: [.red, .yellow, .green], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                        VStack(spacing: 5) {
                            Spacer()
                            Text("Choose difficuty:")
                                .fontWeight(.black)
                                .foregroundStyle(.white)
                                .shadow(color: .black, radius: 1)
                            Spacer()
                            
                            VStack (spacing: 20) {
                                tables(from: 0, to: 2)
                                tables(from: 3, to: 5)
                                tables(from: 6, to: 8)
                                tables(from: 9, to: 11)
                            }
                        
                            Spacer()
                            
                            VStack(spacing: 0) {
                                Text("How many questions?")
                                    .fontWeight(.black)
                                    .foregroundStyle(.white)
                                    .shadow(color: .black, radius: 1)
                                
                                Picker("Questions", selection: $questionsCount) {
                                    ForEach(questionOptions, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(.segmented)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .padding()
                                .animation(.spring, value: questionsCount)
                            }
                            
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
                            
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(isGameActive ? "Challenge Time" : "EDUTAINMENT")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func tables(from start: Int, to end: Int) -> some View {
        HStack {
            ForEach(start...end, id: \.self) { index in
                Button {
                    selectedTable = index + 2
                    UIImpactFeedbackGenerator(style: .light).impactOccurred() // легка вібрація
                } label: {
                    VStack {
                        Image(tableButtons[index])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 80)
                        
                        Text("\(index + 2)")
                            .font(.system(size: 20) .weight(.semibold))
                            .tint(.white)
                            .shadow(color: .black, radius: 5)
                    }
                }
                .scaleEffect(selectedTable == index + 2 ? 1.2 : 1)
                .animation(.easeOut, value: selectedTable) // додасть плавність
                .opacity(selectedTable == index + 2 ? 1 : 0.6)
            }
        }
    }
    
    
    // Метод що генерує питання відповідно таблиці
    func generateQuestions() {
        
        questions.removeAll() // очищаємо старий масив питань
        
        for _ in 0..<questionsCount {
            let num1 = selectedTable
            let num2 = Int.random(in: 2...12)
            
            let text = "How much will \(num1) x \(num2) be?"
            let newQuestion = Question(text: text, answer: num1 * num2)
            questions.append(newQuestion)
        }
    }
    
    
}

#Preview {
    ContentView()
}
