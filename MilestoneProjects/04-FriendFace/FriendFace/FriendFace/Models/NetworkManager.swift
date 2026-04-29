//
//  NetworkManager.swift
//  FriendFace
//
//  Created by mac on 06.04.2026.
//

import UIKit

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Error. Check your URL address!"
        case .invalidResponse: return "The server temporary unavailable. Please try again later."
        case .invalidData: return "Failed to decode data, because it appears to be invalid JSON"
        }
    }
}

struct NetworkManager {
    
    func loadData() async throws -> [User] {
        // 1. URL
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            throw NetworkError.invalidURL
        }
        
        // 2. Fetch
        // Ми не обробляємо помилку тут через do-catch, ми "прокидаємо" її далі
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Result: \(jsonString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        // 3. Decode
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Це навчить Swift розуміти формат дати з твого JSON
        
        do {
            // Намагаємося перетворити JSON на об'єкти Swift
            return try decoder.decode([User].self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
}
