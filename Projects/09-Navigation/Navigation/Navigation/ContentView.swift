//
//  ContentView.swift
//  Navigation
//
//  Created by mac on 24.02.2026.
//

import SwiftUI

struct DetailView: View {
    var number: Int
    
    var body: some View {
        Text("Detail View \(number)")
    }
    
    init(number: Int) {
        self.number = number
        print("Creating Detail View \(number)")
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationStack {
                List(0..<1000) { i in
                    NavigationLink("Tap Me") {
                        Text("Detail View")
                        DetailView(number: i)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
