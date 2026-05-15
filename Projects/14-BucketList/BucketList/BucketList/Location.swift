//
//  Location.swift
//  BucketList
//
//  Created by mac on 16.05.2026.
//
import Foundation
import MapKit

// Модель даних для локації візиту
// Codable — для збереження, Equatable — для порівняння, Identifiable — для списків/карт
struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    // Computed property, яка автоматично збирає широту й довготу в тип
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Блок для тестування: ці дані доступні ТІЛЬКИ під час розробки та в Preview
    #if DEBUG
    static let example = Location(
        id: UUID(),
        name: "Buckingham Palace",
        description: "Lit by over 40,000 lightbulbs.",
        latitude: 51.501,
        longitude: -0.141
    )
    #endif
    
    // Оптимізація порівняння: замість перевірки всіх полів, Swift порівнює лише унікальні ID
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
