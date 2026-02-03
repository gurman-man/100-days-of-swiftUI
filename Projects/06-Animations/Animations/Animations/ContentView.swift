//
//  ContentView.swift
//  Animations
//
//  Created by mac on 01.02.2026.
//

import SwiftUI

struct ContentView: View {
    // Розбиваємо рядок на масив окремих символів
    let letters = Array("Hello SwiftUI")
    
    @State private var enabled = false // Стан для перемикання кольору (синій/червоний)
    @State private var dragAmount = CGSize.zero // Стан для відстеження координат руху пальця
    
    
    var body: some View {
        // Перебираємо кожен символ за його індексом (num)
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount) // Зміщуємо кожну літеру на відстань перетягування пальцем
                    .animation(.linear.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
            // Спрацьовує постійно, поки ви ведете пальцем по екрану
                .onChanged { dragAmount = $0.translation }
            
            // Спрацьовує один раз, коли ви відриваєте палець
                .onEnded { _ in
                    dragAmount = .zero // Повертаємо літери в початкову точку
                    enabled.toggle() // Змінюємо стан кольору на протилежний
                }
        )
    }
}

#Preview {
    ContentView()
}
