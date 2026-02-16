//
//  ContentView.swift
//  Moonshot
//
//  Created by mac on 15.02.2026.
//

import SwiftUI

struct CustomText: View {
    let text: String
    
    var body: some View {
        Text(text)
    }
    
    init(text: String) {
        print("Creating a new CustomText")
        self.text = text
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { row in
                    NavigationLink("Row \(row)") {
                        Text("Detail \(row)")
                    }
                }
                .navigationTitle("SwiftUI")
        }
    }
}

#Preview {
    ContentView()
}
