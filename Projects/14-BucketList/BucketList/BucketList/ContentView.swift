//
//  ContentView.swift
//  BucketList
//
//  Created by mac on 11.05.2026.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var locations = [Location]()
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View {
        
        // Обгортаємо у MapReader і використовуємо посередника (proxy), щоб перетворити "пікселі" у реальні географічні координати (широту / довготу)
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                // Створюємо маркери місць
                ForEach(locations) { location in
                    Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.logitude))
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    // місце, яке буде викликатися при тапі
                    let newLocation = Location(
                        id: UUID(),
                        name: "New Location",
                        description: "",
                        latitude: coordinate.latitude,
                        logitude: coordinate.longitude)
                    
                    locations.append(newLocation) // додаємо у наших масив місць
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
