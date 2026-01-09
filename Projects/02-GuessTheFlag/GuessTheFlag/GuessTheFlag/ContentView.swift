//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by mac on 08.01.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Button1") {}
            .buttonStyle(.bordered)
        
        Button("Button2", role: .destructive) {}
            .buttonStyle(.bordered)
        
        Button("Button3") {}
            .buttonStyle(.borderedProminent)
        
        Button("Button4", role: .destructive) {}
            .buttonStyle(.borderedProminent)
        
        Image(systemName: "pencil.circle")
            .padding(50)
            .font(.largeTitle)
            .foregroundStyle(.orange)
    }
    
    
    func executeDelete() {
        print("Now deleting…")
    }
}

#Preview {
    ContentView()
}
