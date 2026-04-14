//
//  User.swift
//  FriendFace
//
//  Created by mac on 06.04.2026.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: String
    var isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
    
    struct Friend: Codable, Identifiable, Hashable {
        let id: String
        let name: String
    }
}
