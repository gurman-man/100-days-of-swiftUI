//
//  ContentView.swift
//  Instafilter
//
//  Created by mac on 18.04.2026.
//

import CoreImage // Базові інструменти для роботи з зображеннями
import CoreImage.CIFilterBuiltins // Готові вбудовані фільтри (Sepia, Bloom тощо)
import PhotosUI
import SwiftUI

struct ContentView: View {
    
    @State private var processedImage: Image? // Зображення після фільтрації
    @State private var filterIntensity = 0.5
    
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var currentFilter = CIFilter.sepiaTone()
    
    // Контекст (об'єкт, що "малює" картинку). Створюємо один раз
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage) // Завантажуємо фото при виборі
                
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing) // Оновлюємо фільтр при русі слайдера
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                    
                    Spacer()
                    
                    // share the picture
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
        }
    }
    
    func changeFilter() {
        
    }
    
    func loadImage() {
        Task {
            // 1. Отримуємо "сирі" дані з медіатеки
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            
            // 2. Перетворюємо в UIImage
            guard let inputImage = UIImage(data: imageData) else { return }
            
            // 3. Конвертуємо в CIImage (формат для Core Image)
            let beginImage = CIImage(image: inputImage)
            
            // 4. Передаємо картинку у фільтр через спеціальний ключ
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            
            // 5. Запускаємо обробку
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        // Налаштовуємо інтенсивність
        currentFilter.intensity = Float(filterIntensity)
        
        // Отримуємо результат від фільтра (це ще не картинка, а лише "рецепт")
        guard let outputImage = currentFilter.outputImage else { return }
        
        // Рендеримо (малюємо) рецепт у реальні пікселі (CGImage)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
    
        // Конвертуємо назад: CGImage -> UIImage -> SwiftUI Image
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}


