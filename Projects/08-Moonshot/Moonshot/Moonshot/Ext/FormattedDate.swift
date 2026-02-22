//
//  FormattedDate.swift
//  Moonshot
//
//  Created by mac on 19.02.2026.
//

import SwiftUI

extension Mission {
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    var formattedLaunchDate2: String {
        launchDate?.formatted(date: .complete, time: .omitted) ?? "N/A"
    }
}
