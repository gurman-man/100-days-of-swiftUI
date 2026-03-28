//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by mac on 28.03.2026.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Створює сховище та передає modelContext усім дочірнім View через Environment
        .modelContainer(for: User.self)
    }
}
