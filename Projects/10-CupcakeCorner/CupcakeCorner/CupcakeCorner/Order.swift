//
//  Order.swift
//  CupcakeCorner
//
//  Created by mac on 12.03.2026.
//

import SwiftUI

@Observable
class Order: Codable {
    // CodingKeys — це мапа для перекладу
    // Swift використовує _ім'я (через @Observable), а JSON — звичайне ім'я
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
    
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
    
    // Перевірка заповненості всіх полів адрес
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }
    
    // Розрахунок вартості тортиків
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
