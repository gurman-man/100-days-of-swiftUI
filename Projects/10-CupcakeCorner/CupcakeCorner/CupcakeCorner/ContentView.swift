//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by mac on 10.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var username = ""
    @State private var email = ""
    
    var disableForm: Bool {
        // 1. Очищуємо дані від пробілів по боках
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 2. Перевіряємо довжину
        if cleanEmail.count < 5 || cleanUsername.count < 5 {
            return true
        }
        
        // 3. Перевіряємо наявність символів @ та . в імейлі
        if cleanEmail.contains("@") == false || cleanEmail.contains(".") == false {
            return true
        }
        
        // Якщо всі перевірки пройдено — розблоковуємо кнопку
        return false
        
        
        // КОРОТКА ВЕРСІЯ
        /*
            username.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 ||
            email.trimmingCharacters(in: .whitespacesAndNewlines).count < 5 ||
            !email.contains("@") ||
            !email.contains(".")
        */
    }
    
    var body: some View {
        Form {
            Section {
                TextField("UserName", text: $username)
                TextField("Email", text: $email)
            }
            
            Section {
                Button("Create account") {
                    print("Created account...")
                }
            }
            .disabled(disableForm)
        }
    }
}

#Preview {
    ContentView()
}
