//
//  ContentView.swift
//  BetterRest
//
//  Created by mac on 21.01.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    
    var body: some View {
        Text(Date.now.formatted(date: .long, time: .shortened))
    }
    
    func exampleDates() {
//        let now = Date.now
//        let tomorrow = Date.now.addingTimeInterval(86400)
//        let range = now...tomorrow
        
//        var components = DateComponents()
//        components.hour = 8
//        components.minute = 0
//        let date = Calendar.current.date(from: components) ?? .now
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        
    }
}

#Preview {
    ContentView()
}
