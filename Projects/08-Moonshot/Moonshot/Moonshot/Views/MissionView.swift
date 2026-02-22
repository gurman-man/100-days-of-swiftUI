//
//  MissionView.swift
//  Moonshot
//
//  Created by mac on 18.02.2026.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView {
            VStack {
                // Header
                MissionHeader(mission: mission)
                
                // Description
                MissionDescription(mission: mission)
                
                // Crew
                CrewList(crew: crew)
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission  // збереження місії
        
        // визначення складу астронавтів
        self.crew = mission.crew.map { member in
            // якщо ми знаємо астронавта
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}


// MARK: - Refactoring (Challenge 2)

/// Mission Header
struct MissionHeader: View {
    let mission: Mission
    
    var body: some View {
        VStack {
            // Image
            Image(mission.image)
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { width, axis in
                    width * 0.6
                }
            
            // Challenge 1
            Text(mission.formattedLaunchDate2)
                .font(.subheadline.monospaced())
                .shadow(color: .cyan.opacity(0.8), radius: 3)
                .multilineTextAlignment(.center)
                .padding(.top)
        }
    }
}


/// MissionDescription
struct MissionDescription: View {
    let mission: Mission
    
    var body: some View {
        VStack(alignment: .leading) {
            
            dividingLine()
            
            Text("Mission Highlights")
                .font(.title.bold())
                .padding(.bottom, 5)
            
            Text(mission.description)
            
            dividingLine()
            
            Text("Crew")
                .font(.title.bold())
                .padding(.bottom, 5)
        }
        .padding(.horizontal)
    }
}


/// Crew List
struct CrewList: View {
    let crew: [MissionView.CrewMember] // cтворили властивість для отримання даних
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 110, height: 80, alignment: .center)
                                .clipShape(.capsule(style: .continuous))
                                .overlay(
                                    Capsule(style: .circular)
                                        .strokeBorder(.white)
                            )
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                
                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}


extension View {
    // DividingLine
    func dividingLine() -> some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    // Передаємо об'єкт Mission, щоб вона мала що відображати
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    MissionView(mission: missions[2], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
