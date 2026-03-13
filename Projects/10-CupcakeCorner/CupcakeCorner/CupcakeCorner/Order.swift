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
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // comlicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50.cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
}
