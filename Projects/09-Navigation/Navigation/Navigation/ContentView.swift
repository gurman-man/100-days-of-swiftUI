//
//  ContentView.swift
//  Navigation
//
//  Created by mac on 24.02.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Hello, world!")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("Tap Me") {
                            // action
                        }
                        
                        Button("Or Tap Me") {
                            // action
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
