//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by mac on 08.01.2026.
//

import SwiftUI

struct ContentView: View {
    var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    
    var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.33)
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundStyle(.black)
                    Text(countries[correctAnswer])
                        .foregroundStyle(.black)
                }
                
                ForEach(0..<3) { number in
                    Button {
                        // flag was tapped
                    } label: {
                        Image(countries[number])
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
