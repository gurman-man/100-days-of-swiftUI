//
//  GameView.swift
//  Edutainment
//
//  Created by mac on 08.02.2026.
//

import SwiftUI

struct GameView: View {
    
    // MARK: - Properties
    
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
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            backgroundGradient
            VStack(spacing: 30) {
                Spacer()
                questionHeader
                questionCard
                submitButton
                
                Spacer()
                bottomControlBar
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // клавіатура не ламає UI
        .onAppear {
            autoFocusKeyboard()
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            alertActions
        } message: {
            Text(alertMessage)
        }
    }
}

// MARK: - Subviews
private extension GameView {

    /// Фоновий градієнт, ідентичний головному екрану
    var backgroundGradient: some View {
        LinearGradient(colors: [.red, .yellow, .green], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
    
    
    /// Заголовок з інформацією про поточний прогрес
    var questionHeader: some View {
        VStack {
            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
        }
        .font(.system(size: 22, weight: .black, design: .monospaced))
        .foregroundStyle(.white)
        .padding()
    }
    
    
    /// Основна картка питання з полем для введення відповіді
    var questionCard: some View {
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
    }
    
    
    /// Кнопка підтвердження відповіді
    var submitButton: some View {
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
    }
    
    
    /// Нижня панель з рахунком та кнопкою виходу
    var bottomControlBar: some View {
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
    
    
    /// Набір кнопок для системного алерта
    @ViewBuilder
    var alertActions: some View {
        if alertTitle == "Game Over" {
            Button("Great!", action: onExit)
        } else {
            Button("OK") { userAnswer = "" }
            Button("Exit Game", role: .destructive) { onExit() }
        }
    }
}

// MARK: - Private Methods
private extension GameView {
    
    /// Перевірка введеної відповіді та перехід до наступного питання
    func checkAnswer() {
        isFieldFocused = false // Приховуємо клавіатуру для показу результату
        
        // Приводимо відповідь користувача у Int
        guard let actualAnswer = Int(userAnswer) else {
            alertTitle = "Oops!"
            alertMessage = "Please enter a valid number, not letters."
            showingAlert = true
            return
        }
        
        let correctAnwer = questions[currentQuestionIndex].answer
        
        if actualAnswer == correctAnwer {
            score += 1
            UIImpactFeedbackGenerator(style: .medium).impactOccurred() // Вібрація при успіху
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Логіка переходу до наступного питання
            if currentQuestionIndex + 1 < questions.count {
                currentQuestionIndex += 1
                userAnswer = ""
                // Повертаємо фокус для наступного питання через мить
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    isFieldFocused = true
                }
            } else {
                alertTitle = "Game Over"
                alertMessage = "You scored \(score) out of \(questions.count)"
                showingAlert = true
            }
        }
    }
    
    
    /// Активує клавіатуру з невеликою затримкою для плавності
    func autoFocusKeyboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFieldFocused = true
        }
    }
}

#Preview {
    GameView(questions: [Question(text: "2 x 2?", answer: 4)], onExit: {})
}
