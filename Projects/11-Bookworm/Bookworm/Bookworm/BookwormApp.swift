//
//  BookwormApp.swift
//  Bookworm
//
//  Created by mac on 17.03.2026.
//

import SwiftData
import SwiftUI

@main // повідомляє Swift, що саме він запускає наш додаток
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup { // повідомляє SwiftUI, що наш додаток можна відображати у декількох вікнах
            ContentView()
        }
        .modelContainer(for: Student.self) // позначення місця зберігання своїх даних у (model container)
    }
}
