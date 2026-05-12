//
//  ContentView.swift
//  BucketList
//
//  Created by mac on 11.05.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Read and Write") {
            // 1. Перетворюємо рядок у набір байтів (Data) через кодування UTF-8
            let data = Data("Test Message".utf8)
            
            // 2. Отримуємо шлях до папки Documents нашого додатка
            // та додаємо назву файлу "message.txt"
            let url = URL.documentsDirectory.appending(path: "message.txt")
            
            do {
                // 3. Записуємо дані за вказаною адресою
                // .atomic — щоб файл не пошкодився при невдалому записі
                // .completeFileProtection — щоб зашифрувати файл на диску
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                
                // 4. Читаємо дані назад із того самого файлу
                let input = try String(contentsOf: url, encoding: .utf8)
                
                // 5. Виводимо результат у консоль
                print(input)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
