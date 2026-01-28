//
//  ContentView.swift
//  WordScramble
//
//  Created by mac on 28.01.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
        }
    }
    
    func testStrings() {
        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        let allGood = misspelledRange.location == NSNotFound
        
        let letters = word.components(separatedBy: "\n") // Розбиває один довгий рядок на масив
        let letter = letters.randomElement() // Повертає випадковий елемент
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines) // Видаляє зайві символи
    }
}

#Preview {
    ContentView()
}
