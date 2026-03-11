//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by mac on 10.03.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
            
            // 1. Перевіряємо, чи картинка успішно завантажена
            if let image = phase.image {
                image
                    .resizable()    // Дозволяємо змінювати розмір
                    .scaledToFit()  // Масштабуємо, щоб вписати в рамки без спотворен
                
            // 2. Якщо картинки немає, перевіряємо, чи виникла помилка
            } else if let error = phase.error {
                Text("Помилка: \(error.localizedDescription)")
                
            // 3. Якщо немає ні картинки, ні помилки — значить іде процес завантаження
            } else {
                ProgressView()
            }
        }
        // Встановлюємо жорсткі розміри для всього контейнера AsyncImage
        .frame(width: 200, height: 200)
    }
}

#Preview {
    ContentView()
}
