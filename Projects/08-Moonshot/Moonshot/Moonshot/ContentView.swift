//
//  ContentView.swift
//  Moonshot
//
//  Created by mac on 15.02.2026.
//

import SwiftUI

let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text(String(astronauts.count))
        }
    }
}

#Preview {
    ContentView()
}
