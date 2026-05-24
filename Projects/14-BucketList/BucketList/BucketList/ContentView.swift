//
//  ContentView.swift
//  BucketList
//
//  Created by mac on 11.05.2026.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    // Головне джерело істини (стан та логіка) для цього екрана
    // Завдяки розширенню (extension) тип автоматично розпізнається як ContentView.ViewModel
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            
            // Обгортаємо у MapReader і використовуємо посередника (proxy), щоб перетворити "пікселі" у реальні географічні координати (широту / довготу)
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    // Створюємо маркери місць з ViewModel
                    ForEach(viewModel.locations) { location in
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
                                            viewModel.selectedPlace = location // Активує відкриття шіта
                                        })
                                )
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        // місце, яке буде викликатися при тапі
                        viewModel.addLocation(at: coordinate)
                    }
                }
                // Презентація шіта: передає розгорнуту (unwrapped) локацію в константу 'place'
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) {
                        viewModel.update(location: $0)
                    }
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
