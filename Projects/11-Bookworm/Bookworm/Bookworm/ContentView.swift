//
//  ContentView.swift
//  Bookworm
//
//  Created by mac on 17.03.2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext // to access the model context
    @Query var students: [Student] // SwiftData loads students from model container
    
    var body: some View {
        NavigationStack {
            VStack {
                List(students) { student in
                    Text(student.name)
                }
                .navigationTitle("Classroom")
                .toolbar {
                    Button("Add") {
                        let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                        let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
                        
                        let chosenFirstName = firstNames.randomElement()!
                        let chosenLastName = lastNames.randomElement()!
                        
                        let student = Student(id: UUID(), name: "\(chosenFirstName) \(chosenLastName)")
                        modelContext.insert(student) // saved in our model context
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
