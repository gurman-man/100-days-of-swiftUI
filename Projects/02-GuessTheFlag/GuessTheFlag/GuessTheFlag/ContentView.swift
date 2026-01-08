//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by mac on 08.01.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom)
        
        RadialGradient(colors: [.blue, .black], center: .center, startRadius: 20, endRadius: 200)
        
        AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center)
        
        Text("Your Content")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(.indigo.gradient)
    }
}

#Preview {
    ContentView()
}
