//
//  ContentView.swift
//  UniConvert
//
//  Created by mac on 06.01.2026.
//

import SwiftUI

enum LengthUnit: String, CaseIterable {
    case meters = "m"
    case kilometers = "km"
    case feet = "ft"
    case yards = "yd"
    case miles = "mi"
    
    var fullName: String {
        switch self {
        case .meters: return "Meters"
        case .kilometers: return "Kilometers"
        case .feet: return "Feet"
        case .yards: return "Yards"
        case .miles: return "Miles"
        }
    }
    
    var toMeters: Double {
        switch self {
        case .meters: return 1.0
        case .kilometers: return 1000.0
        case .feet: return 0.3048
        case .yards: return 0.9144
        case .miles: return 1609.34
        }
    }
}

struct ContentView: View {
    @FocusState private var valueIsFocused: Bool            // Створюємо стан фокусу
    @State private var value = 0.0
    @State private var inputUnit = LengthUnit.meters
    @State private var outputUnit = LengthUnit.kilometers

    // Логіка обчислення
    var convertedValue: Double {
        let inputInMeters = value * inputUnit.toMeters
        let result = inputInMeters / outputUnit.toMeters
        return result
    }
        
    var body: some View {
        NavigationStack {
            Form {
                Section("Value to convert"){
                    TextField("Enter a value", value: $value, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($valueIsFocused)
                }
                Section("Input units") {
                    Picker("Select unit", selection: $inputUnit) {
                        ForEach(LengthUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Output units") {
                    Picker("Select unit", selection: $outputUnit) {
                        ForEach(LengthUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Converted value") {
                    // Програма покаже не більше 2 знаків після коми
                    Text("\(convertedValue.formatted(.number.precision(.fractionLength(0...2)))) \(outputUnit.rawValue)")
                        .font(.headline)
                        .foregroundColor(.blue) // Виділимо результат кольором
                }
            }
            .navigationTitle("UniConvert")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if valueIsFocused {
                    Button("Done") {
                        valueIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
