//
//  ContentView.swift
//  iExpense
//
//  Created by mac on 11.02.2026.
//

import SwiftUI

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    let name: String
    
    var body: some View {
        Text("Hello, \(name)!")
        
        Button("Dismiss") {
            dismiss()
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

struct ContentView: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "$Max")
        }
    }
}

#Preview {
    ContentView()
}
