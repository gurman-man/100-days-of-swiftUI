//
//  GameView.swift
//  Edutainment
//
//  Created by mac on 08.02.2026.
//

import SwiftUI

struct GameView: View {
    let questions: [Question]
    var onExit: () -> Void //  Функція-кложур для виходу з гри
    
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                .font(.headline)
            
            Text(questions[currentQuestionIndex].text)
                .font(.largeTitle)
            
            TextField("Your answer", text: $userAnswer)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding()
            
            Button("Submit Answer", action: checkAnswer)
                .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button("Give up") {
                onExit()
            }
            .foregroundColor(.red)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .keyboard) { // Розміщення по центру
                if currentQuestionIndex + 1 <= questions.count && alertTitle != "Game Over" {
                    Text("Score: \(score)")
                        .fontWeight(.black)
                        .monospacedDigit()
                }
            }
        }
        
        .alert(alertTitle, isPresented: $showingAlert) {
            if alertTitle == "Game Over" {
                Button("Great!", action: onExit)
            } else {
                Button("OK") { userAnswer = "" }
                
                Button("Exit Game", role: .destructive) {
                    onExit()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // Функція для перевірки
    func checkAnswer() {
        
        // Приводимо відповідь користувача у Int
        guard let actualAnswer = Int(userAnswer) else {
            alertTitle = "Oops!"
            alertMessage = "Please enter a valid number, not letters."
            showingAlert = true
            return
        }
        
        // Праивльна відповідь
        let correctAnwer = questions[currentQuestionIndex].answer
        
        if actualAnswer == correctAnwer {
            score += 1
        }
        
        // Логіка переходу до наступного питання
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            userAnswer = ""
        } else {
            alertTitle = "Game Over"
            alertMessage = "Your final score is \(score) out of \(questions.count)"
            showingAlert = true
        }
    }
}

#Preview {
    GameView(questions: [Question(text: "2 x 2?", answer: 4)], onExit: {})
}
