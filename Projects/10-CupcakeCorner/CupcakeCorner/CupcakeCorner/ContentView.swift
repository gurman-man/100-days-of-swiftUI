//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by mac on 10.03.2026.
//
// MARK: - Challenges - Day52
/*
    1. Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.
 
    2. If our call to placeOrder() fails – for example if there is no internet connection – show an informative alert for the user. To test this, try commenting out the request.httpMethod = "POST" line in your code, which should force the request to fail.
 
    3. For a more challenging task, try updating the Order class so it saves data such as the user's delivery address to UserDefaults. This takes a little thinking, because @AppStorage won't work here, and you'll find getters and setters cause problems with Codable support. Can you find a middle ground?
 */

// MARK: - Accessibility_Challenge - Day57

/*
    1. The check out view in Cupcake Corner uses an image and loading spinner that don’t add anything to the UI, so find a way to make the screenreader not read them out.
*/

import SwiftUI

struct ContentView: View {
    
    @State private var order = Order() // щоб всі екрани працювали з тими самими даними (джерело даних)
    
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
                            AddressView(order: order) // передали посилання на той самий order
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
