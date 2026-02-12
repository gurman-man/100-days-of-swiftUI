//
//  ContentView.swift
//  iExpense
//
//  Created by mac on 11.02.2026.
//

import SwiftUI

struct User: Codable {
    let firstName: String
    let lastName: String
}

struct ContentView: View {
    
    // MARK: - storing data with UserDefaults
    
    @State private var user = User(firstName: "Taylor", lastName: "Swift")
    
    var body: some View {
        Button("Save User") {
            let encoder = JSONEncoder()
            
            // try to convert to JSON (Java Script Object Notation)
            if let data = try? encoder.encode(user) {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
    }
}

#Preview {
    ContentView()
}
