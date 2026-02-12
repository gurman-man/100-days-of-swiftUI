//
//  ContentView.swift
//  iExpense
//
//  Created by mac on 11.02.2026.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - storing data with @AppStorage
    //
    // @AppStorage("tapCount") private var tapCount = 0
    
    // MARK: - storing data with UserDefaults
    
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    
    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
            
            UserDefaults.standard.set(tapCount, forKey: "Tap")
        }
    }
}

#Preview {
    ContentView()
}
