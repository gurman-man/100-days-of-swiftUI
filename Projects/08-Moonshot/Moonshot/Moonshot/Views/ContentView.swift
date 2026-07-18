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

// MARK: - Extra Challenge - Day46

/*
    3. Return to project 8 (Moonshot), and upgrade it to use NavigationLink(value:). This means adding Hashable conformance, and thinking carefully how to use navigationDestination().
*/

// MARK: - Extra Challenge - Day76

/*
    3. Do a full accessibility review of Moonshot – what changes do you need to make so that it’s fully accessible?
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
            // Extra Challenge 3 - Day46
            .navigationDestination(for: Mission.self) { mission in
                MissionView(mission: mission, astronauts: astronauts)
            }
            .navigationDestination(for: Astronaut.self) { astronaut in
                AstronautView(astronaut: astronaut)
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
                // Extra Challenge - Day76
                .accessibilityLabel(showingGrid ? "Switch to list view" : "Switch to grid view")
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
                // Extra Challenge 3 - Day46
                // Не створюємо екран прямо тут, а передаємо об'єкт mission у стек
                NavigationLink (value: mission) {
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
                    // Extra Challenge - Day76
                    .missionAccessibilityStyle(for: mission)
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
            // Extra Challenge 3 - Day46
            NavigationLink (value: mission) {
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
            // Extra Challenge - Day76
            .missionAccessibilityStyle(for: mission)
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}

extension View {
    // Налаштування доступності для картки місії Moonshot
    func missionAccessibilityStyle(for mission: Mission) -> some View {
        self
            .accessibilityElement()
            .accessibilityLabel("\(mission.displayName), launched on \(mission.formattedLaunchDate)")
            .accessibilityHint("Shows mission details and crew list")
    }
}

#Preview {
    ContentView()
}
