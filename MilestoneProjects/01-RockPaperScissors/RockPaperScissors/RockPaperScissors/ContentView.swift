//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by mac on 17.01.2026.
//
// MARK: - Challenge - Day25

/*
 You have a basic understanding of arrays, state, views, images, text, and more, so let’s put them together: your challenge is to make a brain training game that challenges players to win or lose at rock, paper, scissors.

 So, very roughly:

    1. Each turn of the game the app will randomly pick either rock, paper, or scissors.
    2. Each turn the app will alternate between prompting the player to win or lose.
    3. The player must then tap the correct move to win or lose the game.
    4. If they are correct they score a point; otherwise they lose a point.
    5. The game ends after 10 questions, at which point their score is shown.
 
 So, if the app chose “Rock” and “Win” the player would need to choose “Paper”, but if the app chose “Rock” and “Lose” the player would need to choose “Scissors”.
 */

import SwiftUI

struct ContentView: View {
    
    // MARK: - Game State
    @State private var possibleMoves = ["✊", "✋", "✌️"]
    @State private var score = 0
    @State private var round = 0
    
    @State private var userAnsweredCorrectly = false
    @State private var showingFinalScore = false        // Контроль відображення фінального Alert
    
    @State private var shouldWin = true
    @State private var computerChoice = Int.random(in: 0..<3)
    
    // MARK: - Subviews
    
    /// Кастомний стиль для відображення статистики (Раунд та Рахунок)
    struct CustomSyle: View {
        var text: String
        
        var body: some View {
            Text(text)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
        }
    }
    
    /// Текст інструкції, який динамічно змінює колір та світіння залежно від умови
    var instructionView: some View {
        Text(shouldWin ? "WIN" : "LOSE")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundStyle(shouldWin ? .green : .red)
            .shadow(color: shouldWin ? .green.opacity(0.5) : .red.opacity(0.5), radius: 15)
    }
    
    // MARK: - Main Layout
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .indigo, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack (spacing: 30){
                Spacer()
                
                // Заголовок
                Text("Rock Paper Scissors")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                    .shadow(color: .yellow, radius: 7)
                    
                Spacer()
                
                // Картка комп'ютера
                HStack(spacing: 15) {
                    Text("COMPUTER CHOSE")
                        .foregroundStyle(.white)
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                    
                    Text(possibleMoves[computerChoice])
                        .font(.system(size: 30))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.horizontal)
                
                // Інструкція
                VStack(spacing: 5) {
                    Text("YOU MUST")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white.opacity(0.6))
                    instructionView
                }
                
                // Кнопки
                HStack() {
                    ForEach(0..<3) { number in
                        Button {
                            playGame(playerChoice: number)
                        } label: {
                            Text(possibleMoves[number])
                                .font(.system(size: 80))
                                .padding()
                                .background(.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                }
                
                Spacer()
                
                // Статистика
                HStack(spacing: 15) {
                    
                    CustomSyle(text: "Round: \(round)/10")
                        .animation(.default, value: round)
                    CustomSyle(text: "Score: \(score)")
                        .animation(.default, value: score)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        // Cповіщення
        .alert("Game Over", isPresented: $showingFinalScore) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    // MARK: - Game Logic (Логіка гри)
    
    /// Основна функція обробки ходу
    func playGame(playerChoice: Int) {
        let userWonRound = (computerChoice + 1) % 3 == playerChoice
        let userLostRound = (playerChoice + 1) % 3 == computerChoice
        
        // 1. Головна умова: що ми мали зробити?
        if shouldWin {
            if userWonRound {
                score += 1
            } else {
                score -= 1
            }
        } else {
            if userLostRound {
                score += 1
            } else {
                score -= 1
            }
        }
        
        // 2. Перевірка на завершення гри
        if round == 9 {
            showingFinalScore = true
        } else {
            advanceRound()
        }
    }
    
    /// Підготовка до наступного ходу
    func advanceRound() {
        computerChoice = Int.random(in: 0..<3)
        shouldWin.toggle()
        round += 1
    }
    
    /// Повне скидання гри до початкового стану
    func resetGame() {
        score = 0
        round = 0
        advanceRound()
    }
}

#Preview {
    ContentView()
}
