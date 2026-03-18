//
//  Student.swift
//  Bookworm
//
//  Created by mac on 18.03.2026.
//

import SwiftData
import Foundation

@Model
class Student {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
