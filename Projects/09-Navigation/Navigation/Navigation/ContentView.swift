//
//  ContentView.swift
//  Navigation
//
//  Created by mac on 24.02.2026.
//

import SwiftUI

struct Student: Hashable {
    var id = UUID()
    
    var name: String
    var age: Int
}

struct ContentView: View {
    var body: some View {
        VStack {
            NavigationStack {
                List(0..<100) { i in
                    NavigationLink("Select \(i)", value: i)
                }
                .navigationDestination(for: Int.self) { selection in
                    Text("You selected \(selection)")
                }
                .navigationDestination(for: Student.self) { student in
                    Text("You selected \(student.name)")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
