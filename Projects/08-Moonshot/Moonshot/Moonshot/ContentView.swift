//
//  ContentView.swift
//  Moonshot
//
//  Created by mac on 15.02.2026.
//

import SwiftUI

let layout = [
    GridItem(.adaptive(minimum: 80, maximum: 120)),
             ]

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView (.horizontal) {
                LazyHGrid(rows: layout) {
                    ForEach(0..<1000) {
                        Text("Item \($0)")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
