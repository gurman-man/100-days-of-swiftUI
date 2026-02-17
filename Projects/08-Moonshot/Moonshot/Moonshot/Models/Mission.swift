//
//  Missions.swift
//  Moonshot
//
//  Created by mac on 17.02.2026.
//

import Foundation

struct Mission: Codable, Identifiable {
    let id: Int
    let launchDate: String?
    let crew: [CrewRole]
    let description: String
    
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
}

