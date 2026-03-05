//
//  ConfettiEffectView.swift
//  HabitTracker
//
//  Created by mac on 05.03.2026.
//

import SwiftUI

struct ConfettiEffectView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { i in
                Rectangle()
                    .fill([Color.red, Color.blue, Color.green, Color.yellow, Color.pink, Color.purple].randomElement()!)
                    .frame(width: 10, height: 20)
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .offset(x: animate ? Double.random(in: -200...200) : 0,
                            y: animate ? Double.random(in: -500...500) : -600)
                    .opacity(animate ? 0 : 1)
                    .animation(.easeOut(duration: 3).delay(Double.random(in: 0...0.2)), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    ConfettiEffectView()
}
