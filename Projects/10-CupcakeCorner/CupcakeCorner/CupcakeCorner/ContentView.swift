//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by mac on 10.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var order = Order() // щоб всіекрани працювали з тими самими даними
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Form {
                    // section of Cupcake-Type & Cupcake-Quantity
                    Section {
                        Picker("Select your cacke type", selection: $order.type) {
                            ForEach(Order.types.indices, id: \.self) {
                                Text(Order.types[$0])
                            }
                        }
                        
                        Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                    }
                    
                    // section with extra supplements
                    Section {
                        Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())
                        
                        if order.specialRequestEnabled {
                            Toggle("Add extra frosting", isOn: $order.extraFrosting)
                            
                            Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                        }
                    }
                    
                    // section of Navigation to AdressView
                    Section {
                        NavigationLink("Delivery details") {
                            AddressView(order: order)
                        }
                    }
                    
                }
                .navigationTitle("Cupcake Corner")
                
            }
        }
    }
    
}

#Preview {
    ContentView()
}
