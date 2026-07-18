//
//  AstronautView.swift
//  Moonshot
//
//  Created by mac on 18.02.2026.
//

import SwiftUI

/// Екран детальної інформації про астронавта
struct AstronautView: View {
    let astronaut: Astronaut
    
    var body: some View {

        ScrollView {
            VStack {
                // Зображення астронавта
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("Portrait of \(astronaut.name)")
                
                // Біографія
                Text(astronaut.description)
                    .padding()
                
            }
            .clipShape(.rect(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 1)
                    .shadow(color: .white.opacity(0.5), radius: 5)
            )
        }
        .padding()
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let astonauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    AstronautView(astronaut: astonauts["aldrin"]!)
        .preferredColorScheme(.dark)
}
