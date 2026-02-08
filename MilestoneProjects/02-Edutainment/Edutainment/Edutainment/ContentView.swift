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
                        VStack(spacing: 5) {
                            Spacer()
                            Text("Choose dificuty:")
                                .fontWeight(.black)
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
                                
                                Picker("Questions", selection: $questionsCount) {
                                    ForEach(questionOptions, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding()
                            }
                            
                            Button("START ADVENTURE") {
                                generateQuestions()
                                isGameActive = true
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                            .fontWeight(.bold)
                            
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(isGameActive ? "Challenge Time" : "Edutainment")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func tables(from start: Int, to end: Int) -> some View {
        HStack {
            ForEach(start...end, id: \.self) { index in
                Button {
                    selectedTable = index + 2
                } label: {
                    VStack {
                        Image(tableButtons[index])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 80)
                        
                        Text("\(index + 2)")
                    }
                }
                .scaleEffect(selectedTable == index + 2 ? 1.2 : 1)
                .animation(.easeOut, value: selectedTable) // додасть плавність
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
