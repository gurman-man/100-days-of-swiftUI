//
//  Missions.swift
//  Moonshot
//
//  Created by mac on 17.02.2026.
//

import Foundation

struct Missions: Codable, Identifiable {
    let id: Int
    let launchDate: Date
    let crew: Crew
    let description: String
    
    struct Crew: Codable {
        let name: String
        let role: String
    }
}

