//
//  Color-Theme.swift
//  Moonshot
//
//  Created by mac on 17.02.2026.
//

import SwiftUI

// Розширюємо ShapeStyle, щоб використовувати власні кольори
extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}
