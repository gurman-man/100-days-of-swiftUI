//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by mac on 08.01.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack() {
            VStack(spacing: 0) {
                Color.red
                Color.blue
            }
            
            Text("Your Content")
                .foregroundStyle(.secondary)
                .padding(50)
                .background(.ultraThinMaterial)
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    ContentView()
}
