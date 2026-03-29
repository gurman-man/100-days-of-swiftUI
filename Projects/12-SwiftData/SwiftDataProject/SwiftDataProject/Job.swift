//
//  Job.swift
//  SwiftDataProject
//
//  Created by mac on 29.03.2026.
//

import Foundation
import SwiftData

@Model
class Job {
    var name: String
    var priority: Int
    var owner: User? // Опціональне посилання на власника (зворотний зв'язок)
    
    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
