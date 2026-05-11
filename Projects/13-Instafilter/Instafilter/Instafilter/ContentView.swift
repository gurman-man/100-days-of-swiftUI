//
//  ContentView.swift
//  Instafilter
//
//  Created by mac on 18.04.2026.
//
// MARK: - Challenges - Day67

/*
    1. Try making the Slider and Change Filter buttons disabled if there is no image selected.
 
    2. Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.
 
    3. Explore the range of available Core Image filters, and add any three of your choosing to the app.
 */

import CoreImage // Базові інструменти для роботи з зображеннями
import CoreImage.CIFilterBuiltins // Готові вбудовані фільтри (Sepia, Bloom тощо)
import StoreKit // Фреймворк для роботи з App Store (відгуки, покупки)
import PhotosUI
import SwiftUI

struct ContentView: View {
    
    @State private var processedImage: Image? // Зображення після фільтрації
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    @State private var filterVector = 0.5
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    
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
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                            // Оновлюємо фільтр при русі слайдера
                            .onChange(of: filterIntensity, applyProcessing)
                            // Вимикаємо слайдер, якщо фільтр не підтримує Intensity ключа
                            .disabled(!currentFilter.inputKeys.contains(kCIInputIntensityKey))
                    }
                    
                    HStack {
                        // Challenge 2
                        Text("Radius")
                        Slider(value: $filterRadius)
                            .onChange(of: filterRadius, applyProcessing)
                            .disabled(!currentFilter.inputKeys.contains(kCIInputRadiusKey))
                    }
                    
                    HStack {
                        // Challenge 2
                        Text("Scale")
                        Slider(value: $filterScale)
                            .onChange(of: filterScale, applyProcessing)
                            .disabled(!currentFilter.inputKeys.contains(kCIInputScaleKey))
                    }
                    
                    HStack {
                        // Challenge 3
                        Text("Vector")
                        Slider(value: $filterVector)
                            .onChange(of: filterVector, applyProcessing)
                            .disabled(!(currentFilter.inputKeys.contains("inputMaxComponents") || currentFilter.inputKeys.contains("inputMinComponents")))
                    }
                }
                .padding(.vertical)
                .disabled(selectedItem == nil) // Challenge 1
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(selectedItem == nil) // Challenge 1
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Gloom") { setFilter(CIFilter.gloom()) }
                Button("Color Clamp") { setFilter(CIFilter.colorClamp()) }
                Button("Effect Mono") { setFilter(CIFilter.photoEffectMono()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
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
    
    
    // Безпечне налаштування фільтра через Ключі
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        // Налаштовуємо інтенсивність
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        
        // Налаштовуємо радіус
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 100, forKey: kCIInputRadiusKey) }
        
        // Налаштовуємо масштабування
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale  * 10, forKey: kCIInputScaleKey)}
        
        // Challenge 3
        // Кастомні параметри для Color Clamp
        if inputKeys.contains("inputMaxComponents") {
            // Створюємо вектор, де кожен канал (R, G, B, A) обмежений значенням слайдера
            let maxVector = CIVector(x: filterVector, y: filterVector, z: filterVector, w: 1)
            currentFilter.setValue(maxVector, forKey: "inputMaxComponents")}
        
        if inputKeys.contains("inputMinComponents") {
            // Створюємо вектор, де кожен канал (R, G, B, A) обмежений значенням слайдера
            let maxVector = CIVector(x: 0, y: 0, z: 0, w: 0)
            currentFilter.setValue(maxVector, forKey: "inputMinComponents")}
        
        
        // Отримуємо результат від фільтра (це ще не картинка, а лише "рецепт")
        guard let outputImage = currentFilter.outputImage else { return }
        
        // Рендеримо (малюємо) рецепт у реальні пікселі (CGImage)
        // Cтворюємо CGImage з CIImage
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
    
        // Cтворюємо UIImage з CGImage
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    
    // Шаблон для оновлення стану
    // @MainActor гарантує безпечне оновлення UI та виклик системних вікон
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage() // Перезавантажуємо картинку
        
        filterCount += 1
        if filterCount >= 20 {
            requestReview() // Просимо відгук лише після 20 замін фільтрів
        }
    }
}

#Preview {
    ContentView()
}


