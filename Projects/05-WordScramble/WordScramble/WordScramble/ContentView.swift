//
//  ContentView.swift
//  WordScramble
//
//  Created by mac on 28.01.2026.
//

// MARK: - Challenges - Day31

/*
    1. Disallow answers that are shorter than three letters or are just our start word.
 
    2. Add a toolbar button that calls startGame(), so users can restart with a new word whenever they want to.
 
    3. Put a text view somewhere so you can track and show the player’s score for a given root word. How you calculate score is down to you, but something involving number of words and their letter count would be reasonable.
 */

// MARK: - Accessibility - Day75
/*  1. Group word row elements and read word with letter count */


import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    // MARK: - Error State
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score = 0
        
    // MARK: - UI Layout
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        // Task from Day75
                        .accessibilityElement()
                        .accessibilityLabel("\(word), \(word.count) letters")
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord) //  Виконує дію, коли користувач натискає «Enter
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
            // Challenge 2
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        startGame()
                    } label: {
                        Label("", systemImage: "arrow.clockwise")
                    }
                        .fontWeight(.black)
                        .tint(.primary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Score: \(score)")
                        .fontWeight(.black)
                        .tint(.primary)
                        .monospacedDigit() // Щоб цифри не "стрибали" при зміні
                }
            }
        }
    }
    
    // MARK: - Game Logic
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original )")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word is not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        // Challenge 1
        guard isTheRoot(word: answer) else {
            wordError(title: "Be more creative!", message: "You can't just use the start word.")
            return
        }
        
        // Challenge 1
        guard isLongEnough(word: answer) else {
            wordError(title: "Word too short", message: "Words must be at least 3 letters long.")
            return
        }
        
        // Додаємо слово в початок списку з плавною анімацією
        withAnimation {
            usedWords.insert(answer, at: 0)
            // Challenge 3
            score += (answer.count + (answer.count > 5 ? 5 : 0)) // якщо слово довше за 5 літер: +5 балів
        }
        
        newWord = ""
    }
    
    
    func startGame() {
        // 1. Шукаємо URL файлу "start.txt" у нашому пакеті
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            // 2. Перетворимо / зчитаємо знайдений файл у рядок (startWords)
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords.removeAll()
                newWord = ""
                score = 0
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    
    // MARK: - Validation Methods
    
    // Перевірка: чи не було це слово вгадане раніше
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    // Перевірка: чи складається нове слово тільки з літер rootWord
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    // Перевірка: чи існує таке слово в англійській мові (через системний словник)
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        
        // Якщо помилок не знайдено (NSNotFound), значить слово справжнє
        return misspelledRange.location == NSNotFound
    }
    
    // Challenge 1
    func isLongEnough(word: String) -> Bool {
        word.count >= 3
    }
    
    // Challenge 1
    func isTheRoot(word: String) -> Bool {
        rootWord == word ? false  : true
    }
    
    
    // MARK: - Helper Methods
    
    // Метод для відображення сповіщення-помилки
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
