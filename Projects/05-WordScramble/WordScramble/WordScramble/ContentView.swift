//
//  ContentView.swift
//  WordScramble
//
//  Created by mac on 28.01.2026.
//

import SwiftUI

struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    
    var body: some View {
        List {
            Section("Section 1") {
                Text("Static Row 1")
                Text("Static Row 2")
            }
            
            Section("Section 2") {
                ForEach(0..<5) {
                    Text("Dynamic Row\($0)")
                }
            }
            
            Section("Section 3") {
                Text("Static Row 3")
                Text("Static Row 4")
            }
        }
        .listStyle(.grouped)
        
        List(people, id: \.self) {
            Text($0)
        }
    }
}

#Preview {
    ContentView()
}
