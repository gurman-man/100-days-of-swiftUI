//
//  ContentView.swift
//  BucketList
//
//  Created by mac on 11.05.2026.
//

import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            // Змінюємо вигляд екрана залежно від стану авторизації
            isUnlocked ? Text("Unlocked") : Text("Locked")
        }
        // Запускаємо перевірку відразу, як тільки з'являється View
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError? // Сюди запишеться помилка, якщо біометрія недоступна
        
        // Крок 1: Перевіряємо, чи взагалі на пристрої є Face ID/Touch ID і чи вони налаштовані
        // .deviceOwnerAuthenticationWithBiometrics — перевірка саме пальцем/обличчям
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "We need to unlock your data." // Пояснення для Touch ID
            
            // Крок 2: Запускаємо процес сканування
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                // Крок 3: Обробляємо результат (у фоновому потоці)
                if success {
                    // Все добре, оновлюємо UI
                    isUnlocked = true
                } else {
                    // Користувач скасував або обличчя не розпізнано
                }
            }
        } else {
            // Крок 4: Біометрія не підтримується (наприклад, iPad 2 або заблоковано в налаштуваннях)
        }
    }
}

#Preview {
    ContentView()
}
