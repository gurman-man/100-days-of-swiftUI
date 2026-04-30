//
//  ContentView.swift
//  Instafilter
//
//  Created by mac on 18.04.2026.
//

import PhotosUI // Фреймворк, для роботи з системним вікном вибору фото
import SwiftUI

struct ContentView: View {
    // Це не саме зображення, а масив "посилань" на вибрані фото
    @State private var pickerItems = [PhotosPickerItem]()
    
    // Масив готових SwiftUI зображень для відображення на екрані
    @State private var selectedImages = [Image]()
    
    var body: some View {
        VStack {
            // Конфігурація пікера
            PhotosPicker(
                selection: $pickerItems,
                maxSelectionCount: 5, // Обмежуємо вибір до 5 елементів
                matching: .any(of: [.images, .not(.screenshots)]) // Фільтр: фото, але не скріншоти
            ) {
                // Кастомізація зовнішнього вигляду кнопки
                Label("Select a picture", systemImage: "photo")
            }
            
            // Відображення вибраних зображень
            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { i in
                    selectedImages[i]
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
        // Відстежуємо зміну pickerItems (коли користувач натиснув "Done")
        .onChange(of: pickerItems) {
            Task {
                // Очищаємо попередні фото перед новим завантаженням
                selectedImages.removeAll()
                
                // Перебираємо всі вибрані "посилання"
                for item in pickerItems {
                    // Асинхронно намагаємось завантажити дані як Image
                    if let loadedImage = try await item.loadTransferable(type: Image.self) {
                        selectedImages.append(loadedImage)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
