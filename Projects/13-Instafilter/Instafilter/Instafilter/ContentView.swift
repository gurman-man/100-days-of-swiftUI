//
//  ContentView.swift
//  Instafilter
//
//  Created by mac on 18.04.2026.
//

import StoreKit // Фреймворк для роботи з App Store (відгуки, покупки)
import SwiftUI

struct ContentView: View {
    // Читаємо системний метод для виклику вікна оцінки
    @Environment(\.requestReview) var requestReview
    
    // Зберігаємо кількість дій у пам'ять телефону (не зникає після перезапуску)
    @AppStorage("processCount") var processCount = 0
    
    var body: some View {
        VStack {
            Button("Leave a review") {
                // Викликаємо
                reviewAction()
            }
        }
    }
    
    func reviewAction() {
        processCount += 1
        if processCount >= 5 {
            requestReview() // Просимо відгук, коли юзер вже "втягнувся"
        }
    }
}

#Preview {
    ContentView()
}


