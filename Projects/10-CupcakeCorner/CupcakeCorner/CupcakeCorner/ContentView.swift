//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by mac on 10.03.2026.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

private var stringURL = "https://itunes.apple.com/search?term=taylor+swift&entity=song"


struct ContentView: View {
    @State private var results = [Result]()
    
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    
    func loadData() async {
        
        // 1. Creating the URL we want to read
        guard let url =  URL(string: stringURL) else {
            print("Invalid URL")
            return
        }
        
        // 2. Fetching data from that URL
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // 3. Decoding the result of that data into a Response struct
            if let decoded = try? JSONDecoder().decode(Response.self, from: data) {
                results = decoded.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
