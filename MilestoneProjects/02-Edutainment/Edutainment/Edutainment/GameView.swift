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
    
    @FocusState private var isFieldFocused: Bool
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var animationAmount = 1.0 // Анімація для картки питання
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red, .yellow, .green], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack {
                    Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                }
                .font(.system(size: 22, weight: .black, design: .monospaced))
                .foregroundStyle(.white)
                .padding()
                
                VStack(spacing: 20) {
                    Text("solve this:")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                    
                    Text(questions[currentQuestionIndex].text)
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)
                    
                    TextField("???", text: $userAnswer)
                        .focused($isFieldFocused)
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(.white.opacity(0.5))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(40)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30)
                    .stroke(.white.opacity(0.5), lineWidth: 2)
                )
                .scaleEffect(animationAmount) // Ефект для переходу
                .padding()
                
                Button(action: checkAnswer) {
                    Text("SUBMIT ANSWER")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.orange)
                        .foregroundStyle(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Text("SCORE: \(score)")
                        .fontWeight(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 15)
                        .background(.blue.opacity(0.4))
                        .cornerRadius(10)

                    Button(role: .destructive) {
                        onExit()
                    } label: {
                        Text("GIVE UP")
                            .fontWeight(.black)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // клавіатура не ламає UI
        .onAppear {
            // Невелика затримка гарантує, що анімація переходу завершиться
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFieldFocused = true
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
        isFieldFocused = false // ховаємо клавіатуру
        
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
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Логіка переходу до наступного питання
            if currentQuestionIndex + 1 < questions.count {
                currentQuestionIndex += 1
                userAnswer = ""
            } else {
                alertTitle = "Game Over"
                alertMessage = "You scored \(score) out of \(questions.count)"
                showingAlert = true
            }
        }
    }
}

#Preview {
    GameView(questions: [Question(text: "2 x 2?", answer: 4)], onExit: {})
}
