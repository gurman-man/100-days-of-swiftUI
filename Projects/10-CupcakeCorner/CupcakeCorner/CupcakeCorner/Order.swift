//
//  Order.swift
//  CupcakeCorner
//
//  Created by mac on 12.03.2026.
//

import SwiftUI

/*
    MARK: - Використовуємо клас Order, тому що нам потрібно:
 
    1. Передавати дані між екранами: Клас — це «посилання» (reference type), тому коли ви змінюєте щось на екрані адреси, ці зміни автоматично бачить екран оформлення замовлення (CheckoutView).
 
    2. Використовувати Codable: Нам потрібно легко перетворити все замовлення на один JSON-об'єкт для відправки на сервер. Робити це з купою окремих змінних @AppStorage було б набагато важче.
*/

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
    
    private let defaults = UserDefaults.standard
    
    var name: String {
        // спостерігач, щоб зберігати дані, як тільки вони змінюються
        didSet {
            defaults.set(name, forKey: StorageKeys.name)
        }
    }
    
    var streetAddress: String {
        didSet {
            defaults.set(streetAddress, forKey: StorageKeys.street)
        }
    }
    var city: String {
        didSet {
            defaults.set(city, forKey: StorageKeys.city)
        }
    }
    var zip: String {
        didSet {
            defaults.set(zip, forKey: StorageKeys.zip)
        }
    }
    
    // Використовуємо ініціалізатор, щоб завантажити дані з UserDefaults при створенні замовлення
    init() {
        self.name = defaults.string(forKey: StorageKeys.name) ?? ""
        self.streetAddress = defaults.string(forKey: StorageKeys.street) ?? ""
        self.city = defaults.string(forKey: StorageKeys.city) ?? ""
        self.zip = defaults.string(forKey: StorageKeys.zip) ?? ""
    }
    
    // Перевірка заповненості всіх полів адрес
    var hasValidAddress: Bool {
        // Challenge 1
        let textFieldsValid = !name.isBlank && !streetAddress.isBlank && !city.isBlank && !zip.isBlank
        let zipIsValid = !zip.isBlank && zip.isNumeric && zip.count == 5
        
        return textFieldsValid && zipIsValid
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

// Challenge 1 - Day 52
extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isNumeric: Bool {
        // перевіряє, чи відповідає кожен окремий елемент колекції певній умові
        return !self.isEmpty && self.allSatisfy { $0.isNumber }
    }
}

enum StorageKeys {
    static let name = "name"
    static let street = "streetAddress"
    static let city = "city"
    static let zip = "zip"
}
