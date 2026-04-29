//
//  Friend.swift
//  FriendFace
//
//  Created by mac on 22.04.2026.
//

import SwiftData
import Foundation

@Model
class Friend: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    var id: String
    var name: String
    var friend: User?
    
    init(id: String, name: String, friend: User? = nil) {
        self.id = id
        self.name = name
        self.friend = friend
    }
    
    // 1. Метод для розкодування (JSON -> Swift)
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    // 2. Метод для кодування (Swift -> JSON)
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
}
