//
//  ContentView.swift
//  AccessibilitySandbox
//
//  Created by mac on 17.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(.character)
                .resizable()
                .scaledToFit()
                .accessibilityHidden(true) // повне ігнорування до будь-якого View
        }
        .frame(width: .infinity, height: 500)
        .padding(.vertical)
        
        VStack {
            Text("Your score is")
            
            Text("1000")
                .font(.title)
        }
        // ігорується Text - та читається сам accessibilityLabel
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Your score is 1000")
        .padding(.vertical)
    }
}

#Preview {
    ContentView()
}
