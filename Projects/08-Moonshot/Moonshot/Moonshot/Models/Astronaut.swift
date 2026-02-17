//
//  Astronaut.swift
//  Moonshot
//
//  Created by mac on 17.02.2026.
//

import Foundation

struct Astronaut: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
}
