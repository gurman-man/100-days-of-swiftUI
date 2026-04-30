//
//  ContentView.swift
//  Instafilter
//
//  Created by mac on 18.04.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            // Базовий варіант (текст "Share" + іконка)
            Section("Default Share") {
                ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
            }
            
            
            // З додаванням теми (subject) та опису (message)
            Section("Share with Metadata") {
                ShareLink(item: URL(
                    string: "https://www.hackingwithswift.com")!,
                          subject: Text("Learn Swift here"),
                          message: Text("Check out the 100 Days of SwiftUI")
                )
            }
            
            // З кастомним виглядом кнопки
            Section("Custom Label") {
                ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
                    Label("Spread the word about Swift", systemImage: "swift")
                }
            }
            
            
            // Поширення фото (потребує обов'язкове прев'ю)
            Section("Media Sharing") {
                let example = Image(.skating)
                
                ShareLink(
                    item: example,
                    preview: SharePreview("Skating photo", image: example)
                ) {
                    Label("Click to share", systemImage: "skateboard.fill")
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    ContentView()
}


