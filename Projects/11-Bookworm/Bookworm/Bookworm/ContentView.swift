//
//  ContentView.swift
//  Bookworm
//
//  Created by mac on 17.03.2026.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("notes") private var notes = ""
    
    var body: some View {
        Form {
            TextField("Enter your text", text: $notes, axis: .vertical)
                .font(.custom("HelveticaNeue", size: 18))
        }
        
        NavigationStack {
            VStack {
                TextField("Enter your text", text: $notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .font(.custom("HelveticaNeue", size: 18))
                    .padding()
            }
            .navigationTitle("Notes")
        }
    }
}

#Preview {
    ContentView()
}
