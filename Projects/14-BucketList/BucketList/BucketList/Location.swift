//
//  Location.swift
//  BucketList
//
//  Created by mac on 16.05.2026.
//
import Foundation

// Модель даних для Visit location
struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double
    var logitude: Double
}
