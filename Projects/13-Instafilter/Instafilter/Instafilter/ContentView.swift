//
//  ContentView.swift
//  Instafilter
//
//  Created by mac on 18.04.2026.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
    
    
    func loadImage() {
        let inputImage = UIImage(resource: .skating)
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.crystallize()
        
        currentFilter.inputImage = beginImage
//        currentFilter.radius = 1000
//        currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        
        
        // Викорситання старішого API для змінювати значення динамічно для будь якого з фільтрів
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 23, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
        
        // Спроба отримати CIImage з нашого фільтра
        guard let outputImage = currentFilter.outputImage else { return }
        
        // Cпроба отримати CGImage з нашого CIImage
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        // Перетворюємо у UIImage
        let uiImage = UIImage(cgImage: cgImage)
        
        // Перетворюємо у SwiftUI image
        image = Image(uiImage: uiImage)
    }
    
}

#Preview {
    ContentView()
}
