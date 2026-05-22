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
    
    // Опціональний стан: коли він стає не-nil, автоматично відкривається .sheet
    @State private var selectedPlace: Location?
    
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
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(.circle)
                            // Використовуємо високопріоритетний жест, щоб мапа не глушила довге натискання
                            .highPriorityGesture(
                                LongPressGesture(minimumDuration: 0.2)
                                    .onEnded({ _ in
                                        selectedPlace = location // Активує відкриття шіта
                                    })
                            )
                    }
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
                        longitude: coordinate.longitude)
                    
                    locations.append(newLocation) // додаємо у наших масив місць
                }
            }
            // Презентація шіта: передає розгорнуту (unwrapped) локацію в константу 'place'
            .sheet(item: $selectedPlace) { place in
                EditView(location: place) { newLocation in
                    // Шукаємо індекс старої точки (place) і замінюємо її оновленою (newLocation)
                    if let index = locations.firstIndex(of: place) {
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
