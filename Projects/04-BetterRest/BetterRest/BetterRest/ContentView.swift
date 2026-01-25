//
//  ContentView.swift
//  BetterRest
//
//  Created by mac on 21.01.2026.
//

// MARK: - Challenges - Day28

/*
    1. Replace each VStack in our form with a Section, where the text view is the title of the section. Do you prefer this layout or the VStack layout? It’s your app – you choose!
 
    2. Replace the “Number of cups” stepper with a Picker showing the same range of values.
 
    3. Change the user interface so that it always shows their recommended bedtime using a nice and large font. You should be able to remove the “Calculate” button entirely.
 */

// MARK: - Implementation
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State private var recommendLabel = ""
    
    // Встановлюємо стандартний час пробудження (8:00 AM) замість поточного час
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            // Challenge 1
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .padding()
                }
                
                // Challenge 2
                Section("Daily coffee intake") {
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach(0..<21) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .pickerStyle(.automatic)
                    .padding(.vertical, 5)
                }
                
                // Challenge 3
                Section("Recommended bedtime") {
                    HStack (alignment: .center) {
                        Button("Calculate", action: calculateBedtime)
                            .buttonStyle(.borderless)
                        
                        Spacer()
                        
                        Text(alertMessage.isEmpty ? "___" : alertMessage)
                            .font(.title3.weight(.light))
                            .shadow(color: .orange, radius: 5)
                            .italic()
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("BetterRest")
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        do {
            // 1. Налаштовуємо та завантажуємо модель CoreML
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // 2. Отримуємо компоненти часу (години та хвилини) з обраної дати
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            // Перетворюємо час у секунди від початку дня (саме так очікує модель)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // 3. Робимо прогноз за допомогою моделі
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            // 4. Обчислюємо час, коли треба лягти (бажаний час підйому - результат моделі)
            let sleepTime = wakeUp - prediction.actualSleep
            
            // 5. Форматуємо результат для виводу в алерт
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = false
    }
}

#Preview {
    ContentView()
}
