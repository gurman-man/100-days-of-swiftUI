//
//  ContentView.swift
//  Edutainment
//
//  Created by mac on 06.02.2026.
//

import SwiftUI

struct ContentView: View {
    @State var tableButtons: [String] = ["chick", "chicken", "crocodile", "cow", "buffalo", "elephant", "giraffe", "hippo", "sloth", "parrot", "frog", "zebra"]
    
    @State private var selectedTable = 0
    @State private var questionsCount = 5
    private let questionOptions = [5, 10, 20]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 5) {
                    Spacer()
                    Text("Choose dificuty:")
                        .fontWeight(.black)
                    Spacer()
                    
                    VStack (spacing: 20) {
                        tables(from: 0, to: 2)
                        tables(from: 3, to: 5)
                        tables(from: 6, to: 8)
                        tables(from: 9, to: 11)
                    }
                
                    Spacer()
                    
                    VStack(spacing: 0) {
                        Text("How many questions?")
                            .fontWeight(.black)
                        
                        Picker("Questions", selection: $questionsCount) {
                            ForEach(questionOptions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                    }
                    
                    Button("START ADVENTURE") {
                        // Action
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .fontWeight(.bold)
                    
                    Spacer()
                }
                .navigationTitle("Edutainment")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    func tables(from start: Int, to end: Int) -> some View {
        HStack {
            ForEach(start...end, id: \.self) { index in
                Button {
                    selectedTable = index + 2
                } label: {
                    VStack {
                        Image(tableButtons[index])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 80)
                        
                        Text("\(index + 2)")
                    }
                }
                .scaleEffect(selectedTable == index + 2 ? 1.2 : 1)
                .animation(.easeOut, value: selectedTable) // додасть плавність
            }
        }
    }
}

#Preview {
    ContentView()
}
