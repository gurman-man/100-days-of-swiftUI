//
//  ContentView.swift
//  WordScramble
//
//  Created by mac on 28.01.2026.
//

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
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord) //  Виконує дію, коли користувач натискає «Enter
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Game Logic
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
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
        
        // Додаємо слово в початок списку з плавною анімацією
        withAnimation {
            usedWords.insert(answer, at: 0)
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
