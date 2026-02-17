//
//  ContentView.swift
//  Moonshot
//
//  Created by mac on 15.02.2026.
//

import SwiftUI

// Завантаження та декодування даних з JSON за допомогою розширення Bundle
let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
let missions: [Mission] = Bundle.main.decode("missions.json")

// Адаптивна сітка
let columns = [
    GridItem(.adaptive(minimum: 150))
]

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                // LazyVGrid створює елементи лише при появі на екрані
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        // Перехід до Detail
                        NavigationLink {
                            Text("Detail view")
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground) // Кастомний колір
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground)
                            )
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    ContentView()
}
