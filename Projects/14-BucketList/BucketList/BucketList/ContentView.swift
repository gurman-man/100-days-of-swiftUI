//
//  ContentView.swift
//  BucketList
//
//  Created by mac on 11.05.2026.
//

import MapKit
import SwiftUI

// Модель даних: Identifiable потрібен, щоб Map міг розрізняти точки
struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    // Масив точок, які ми хочемо відобразити на карті
    let locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    
    // Стан камери: центр Лондона + зум (span)
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    )
    
    var body: some View {
        VStack(spacing: 10) {
            
            // ВАРІАНТ 1: Стандартні маркери (червоні "кульки")
            VStack {
                Map {
                    ForEach(locations) { location in
                        Marker(location.name, coordinate: location.coordinate)
                    }
                }
            }
            
            // ВАРІАНТ 2: Кастомні анотації (твій власний дизайн)
            VStack {
                Map {
                    ForEach(locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            // Все, що тут — це зовнішній вигляд твоєї точки
                            Text(location.name)
                                .font(.headline)
                                .padding()
                                .background(.blue.gradient)
                                .foregroundStyle(.white)
                                .clipShape(.capsule)
                        }
                        // Показувати або ховати додатковий системний підпис під анотацією
                        .annotationTitles(.visible)
                    }
                }
            }
            
            // ВАРІАНТ 3: Карта з обробкою натискань (Tap)
            VStack {
                MapReader { proxy in
                    // MapReader — це "контейнер", який стежить за всім, що відбувається з мапою всередині нього
                    
                    // MapProxy — інструмент для конвертації між екранними координатами та географічними.
                    
                    Map()
                        .onTapGesture { position in
                            // Перетворюємо пікселі дотику (position) у координати карти (coordinate)
                            if let coordinate = proxy.convert(position, from: .local) {
                                print(coordinate)
                            }
                        }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
