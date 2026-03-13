//
//  Order.swift
//  CupcakeCorner
//
//  Created by mac on 12.03.2026.
//

import SwiftUI

@Observable
class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet { // дозволяє відслідковувати та одразу змінювати
            extraFrosting = false
            addSprinkles = false
        }
    }

    var extraFrosting = false // глазур
    var addSprinkles = false // посипка
    
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasVaildAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
}
