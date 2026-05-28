//
//  ContentView.swift
//  BucketList
//
//  Created by mac on 11.05.2026.
//
// MARK: - Challenges - Day73

/*
    1. Allow the user to switch map modes, between the standard mode and hybrid.
 
    2. Our app silently fails when errors occur during biometric authentication, so add code to show those errors in an alert.
 
    3. Create another view model, this time for EditView. What you put in the view model is down to you, but I would recommend leaving dismiss and onSave in the view itself – the former uses the environment, which can only be read by the view, and the latter doesn’t really add anything when moved into the model.
 
    Tip: That last challenge will require you to make a State instance in your EditView initializer – remember to use an underscore with the property name!
 */

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
        // Обгортаємо у MapReader і використовуємо посередника (proxy), щоб перетворити "пікселі" у реальні географічні координати (широту / довготу)
        if viewModel.isUnlocked {
            NavigationStack {
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
                    // Challenge 1
                    .mapStyle(viewModel.isHybridMap ? .hybrid(elevation: .realistic) : .standard(elevation: .realistic))
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
                    // Challenge 1
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Menu {
                                Button("Standard") {
                                    viewModel.isHybridMap = false
                                }
                                Button("Hybrid") {
                                    viewModel.isHybridMap = true
                                }
                            } label: {
                                Label("Map Style", systemImage: "map")
                            }
                        }
                    }
                }
                .navigationTitle("BucketList")
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
            
                // Challenge 2
                .alert("Authentication Error", isPresented: $viewModel.showingError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    // Завдяки LocalizedError, .localizedDescription автоматично викличе твій var errorDescription
                    Text(viewModel.authError?.localizedDescription ?? "Unknown error")
                }
        }
    }
}

#Preview {
    ContentView()
}
