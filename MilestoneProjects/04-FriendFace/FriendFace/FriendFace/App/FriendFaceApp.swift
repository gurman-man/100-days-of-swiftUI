//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by mac on 06.04.2026.
//

import SwiftData
import SwiftUI

@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Створює сховище та передає modelContext усім дочірнім View через Environment
        .modelContainer(for: User.self)
    }
}
