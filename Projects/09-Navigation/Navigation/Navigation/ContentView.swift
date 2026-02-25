//
//  ContentView.swift
//  Navigation
//
//  Created by mac on 24.02.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(0..<5) { i in
                    NavigationLink("Select Number: \(i)", value: i)
                }
                ForEach(0..<5) { i in
                    NavigationLink("Select String: \(i)", value: String(i))
                }
            }
            .toolbar {
                //  programmatic navigation
                Button("Push 556") {
                    path.append(556)
                }
                
                Button("Push Hello") {
                    path.append("Hello")
                }
            }
            
            // using navigationDestination() with different data types
            .navigationDestination(for: Int.self) { selection in
                Text("You selected the number \(selection)")
            }
            
            .navigationDestination(for: String.self) { selection in
                Text("You selected the string \(selection)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
