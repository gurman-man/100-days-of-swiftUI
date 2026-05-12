//
//  ContentView.swift
//  BucketList
//
//  Created by mac on 11.05.2026.
//

import SwiftUI

// Окремі маленькі компоненти для кожного стану
struct LoadingView: View {
    var body: some View { Text("Loading...") }
}

struct SuccessView: View {
    var body: some View { Text("Success!") }
}

struct FailedView: View {
    var body: some View { Text("Failed.") }
}

struct ContentView: View {
    // Зберігаємо поточний стан. Swift автоматично оновить екран, коли стан зміниться
    @State private var loadingState = LoadingState.loading
    
    // Створюємо перерахування прямо всередині, бо воно стосується лише цієї View
    enum LoadingState {
        case loading, success, failed
    }
    
    var body: some View {
        switch loadingState {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
    }
}

#Preview {
    ContentView()
}
