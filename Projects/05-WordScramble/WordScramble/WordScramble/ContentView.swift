//
//  ContentView.swift
//  WordScramble
//
//  Created by mac on 28.01.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Hello, world!")
        }
    }
    
    func testBundles() {
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            
            if let fileContents = try? String(contentsOf: fileURL, encoding: .utf8) {
                // we loaded the file into a string!
            }
        }
    }
}

#Preview {
    ContentView()
}
