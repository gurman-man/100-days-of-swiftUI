//
//  ContentView.swift
//  Moonshot
//
//  Created by mac on 15.02.2026.
//

// MARK: - Challenges - Day28

/*
    1. Add the launch date to MissionView, below the mission badge. You might choose to format this differently given that more space is available, but it’s down to you.
 
    2. Extract one or two pieces of view code into their own new SwiftUI views – the horizontal scroll view in MissionView is a great candidate, but if you followed my styling then you could also move the Rectangle dividers out too.
 
    3. For a tough challenge, add a toolbar item to ContentView that toggles between showing missions as a grid and as a list.
 */

// MARK: - Impelementation

import SwiftUI

// Завантаження та декодування даних з JSON за допомогою розширення Bundle
let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
let missions: [Mission] = Bundle.main.decode("missions.json")


struct ContentView: View {
    @State private var showingGrid = true
    
    var body: some View {
        NavigationStack {
            // Challenge 3
            Group {
                if showingGrid {
                    ScrollView {
                        SpaceFlightsGrid()
                    }
                } else {
                    SpaceFlightsList()
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button {
                    withAnimation() {
                        showingGrid.toggle()
                    }
                } label: {
                    Image(systemName: showingGrid ? "list.bullet" : "square.grid.2x2")
                }
            }
        }
    }
}


/// Grid Layout
struct SpaceFlightsGrid: View {
    
    // Адаптивна сітка
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body:  some View {
        
        // LazyVGrid створює елементи лише при появі на екрані
        LazyVGrid(columns: columns) {
            ForEach(missions) { mission in
                // Перехід до Detail
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
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
    
}


/// List Layout
struct SpaceFlightsList: View {
    var body:  some View {
        List(missions) { mission in
            NavigationLink {
                MissionView(mission: mission, astronauts: astronauts)
            } label: {
                HStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 10)
                }
                
                VStack(alignment: .leading) {
                    Text(mission.displayName)
                        .font(.headline)
                    Text(mission.formattedLaunchDate)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .listRowBackground(Color.lightBackground)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    ContentView()
}
