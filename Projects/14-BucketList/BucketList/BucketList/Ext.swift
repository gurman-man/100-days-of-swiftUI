//
//  File.swift
//  BucketList
//
//  Created by mac on 12.05.2026.
//

import SwiftUI

// Розширення, щоб легко читати/писати файли
extension FileManager {
    // Функція для отримання шляху до папки документів
    var documentsDirectory: URL {
        let path = self.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func encode<T: Encodable>(_ data: T, to fileName: String) {
        let url = documentsDirectory.appending(path: fileName)
        let encoder = JSONEncoder()
        
        do {
            let encoded = try encoder.encode(data)
            try encoded.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Writing error: \(error.localizedDescription)")
        }
    }
}
