//
//  ContentView.swift
//  AccessibilitySandbox
//
//  Created by mac on 17.07.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var value = 10
    var body: some View {
        VStack {
            VStack {
                Text("Value: \(value)")
                
                Button("Increment") {
                    value += 1
                }
                
                Button("Decrement") {
                    value -= 1
                }
            }
            
            // Об'єднує всі внутрішні елементи у один єдиний компонент для VoiceOver
            .accessibilityElement()
            
            // Задає назву (контекст) для об'єднаного елемента
            .accessibilityLabel("Value")
            
            // Передає поточне значення, яке VoiceOver озвучуватиме при зміні
            .accessibilityValue(String(value))
            
            // Дозволяє змінювати значення свайпами вгору/вниз без натискання окремих кнопок
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment: value += 1
                case .decrement: value -= 1
                @unknown default: print("Not handled")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
