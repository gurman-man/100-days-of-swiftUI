//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by mac on 13.03.2026.
//

import SwiftUI

struct AddressView: View {
    // Додаємо @Bindable тут, щоб отримати доступ до $order та змінити його
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
                .disabled(order.hasValidAddress == false)
            }
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
