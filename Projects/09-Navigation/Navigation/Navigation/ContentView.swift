//
//  ContentView.swift
//  Navigation
//
//  Created by mac on 24.02.2026.
//

import SwiftUI

struct DetailView: View {
    var number: Int
    
    // lets us pass an @State property into another view and modify it
    @Binding var path: [Int]
    
    var body: some View {
        // wrinting (adding value)
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
            .toolbar {
                // return to base View
                Button("Home") {
                    path.removeAll() // writing (changing value)
                }
            }
    }
}

struct ContentView: View {
    @State private var path = [Int]()
    
    var body: some View {
        // reading (getting path)
        NavigationStack(path: $path) {
            DetailView(number: 0, path: $path)
                .navigationDestination(for: Int.self) { i in
                    // reading (getting i)
                    DetailView(number: i, path: $path)
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
