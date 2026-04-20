//
//  ContentView.swift
//  Instafilter
//
//  Created by mac on 18.04.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        // Short version
        ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet"))
        
        Divider()
        
        // Full-control version
        ContentUnavailableView {
            Label("No snippets", systemImage: "swift")
        } description: {
            Text("You don't have any saved snippets yet")
        } actions: {
            Button("Create snnipet") {
                // create a snippet
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
