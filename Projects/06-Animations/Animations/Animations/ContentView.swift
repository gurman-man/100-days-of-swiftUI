//
//  ContentView.swift
//  Animations
//
//  Created by mac on 01.02.2026.
//

import SwiftUI

// 1. Описуємо, ЯК саме буде змінюватися View (поворот + обрізка)
struct CornerRotateModifier: ViewModifier {
    let amount: Double      // Кут нахилу
    let anchor: UnitPoint   // Точка, навколо якої крутимо
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)   // Повертаємо
            .clipped()  // Не даємо об'єкту виходити за свої межі при русі
    }
}


// 2. Створюємо зручне ім'я для анімації появи/зникнення
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}


struct ContentView: View {
    @State private var isShowingRed = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot) // Застосовуємо наш кастомний перехід
            }
        }
        .onTapGesture {
            // Анімуємо зміну булевої змінної
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
