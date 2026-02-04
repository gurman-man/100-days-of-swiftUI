//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by mac on 08.01.2026.
//

// MARK: - Challenges
/*
    1. Add an @State property to store the user’s score, modify it when they get an answer right or wrong, then display it in the alert and in the score label.
 
    2. When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.
 
    3. Make the game show only 8 questions, at which point they see a final alert judging their score and can restart the game
 
 
Day 24: Challenge 2
 
    2. Go back to project 2 and replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had.
 
 Day 33: Challenges
 
    1. When you tap a flag, make it spin around 360 degrees on the Y axis.
 
    2. Make the other two buttons fade out to 25% opacity.
 
    3. Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment!
 
 */

// MARK: - Implementation
import SwiftUI

// Challenge 2 from Day 24
struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var questionCounter = 0
    @State private var gameOver = false
    
    @State private var selectedFlag = -1 // Зберігаємо номер натиснутого прапора
    @State private var wrongSelectedFlag = -1
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.3, green: 0.8, blue: 0.7), location: 0.3),
                    .init(color: Color(red: 0.5, green: 0.4, blue: 0.5), location: 0.3)],
                center: .top,
                startRadius: 200,
                endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.black)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.black)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation {
                                flagTapped(number)
                            }
                        } label: {
                        // Challenge 2 from Day 24
                            FlagImage(name: countries[number])
                        }
                        // Challenge 1 from Day 33
                        .rotation3DEffect(
                            .degrees(selectedFlag == number ? 360 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        // Challenge 2 from Day 33
                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.25)
                        
                        // Challenge 3 from Day 33
                        .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1.0 : 0.7)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.buttonBorder)
                
                Spacer()
                Spacer()
                // Challenge 1
                Text("Score: \(score)")
                    .foregroundStyle(.black)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            // Challenge 1
            Text("Your score is \(score)")
        }
        
        // Challenge 3
        .alert("Game Over!", isPresented: $gameOver) {
            Button("Restart Game", action: resetGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        
        
        // Challenge 1
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            // Challenge 2
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score -= 1
            wrongSelectedFlag = number
        }
        
        // Challenge 3
        questionCounter += 1
        
        if questionCounter == 8 {
            gameOver = true
        } else {
            showingScore = true
        }
    }
    
    //  Підготовка нового раунду гри
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1 // cкидаємо вибір
    }
    
    
    // Challenge 3
    func resetGame() {
        score = 0
        questionCounter = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
