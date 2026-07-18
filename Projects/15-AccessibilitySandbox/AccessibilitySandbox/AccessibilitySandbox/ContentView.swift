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
            Button("John Fitzgerald Kennedy") {
                print("Button tapped")
            }
            // Додає синоніми (JFK, Kennedy), щоб кнопку можна було легко натиснути голосом через Voice Control
            .accessibilityInputLabels(["John Fitzgerald Kennedy", "Kennedy", "JFK"])
        }
    }
}

#Preview {
    ContentView()
}
