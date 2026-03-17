//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by mac on 13.03.2026.
//

import SwiftUI

// Challenge 2
enum CheckoutError: Error, LocalizedError {
    case invalidResponse
    case serverError
    case encodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response from the server."
        case .serverError: return "The server temporary unavailable. Please try again later."
        case .encodingFailed: return "Failed to encode the order data."
        }
    }
}

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var alertTitle = ""
    
    var body: some View {
        ScrollView {
            VStack {
                // Завантаження картинки з інтернету
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    // Використовуємо Task для запуску асинхронної функції з синхронної кнопки
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize) // Дозволяє ScrollView відскакувати, тільки якщо контент не влізає в екран
        
        .alert(alertTitle, isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    
    // Основна функція для відправки замовлення
    func placeOrder() async {
        // 1. Конвертуємо наш об'єкт order у формат JSON
        guard let encoded = try? JSONEncoder().encode(order) else {
            showErrorMessage(CheckoutError.encodingFailed.localizedDescription)
            return
        }
        
        // 2. Налаштовуємо URL та запит
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST" // використовується для відправки даних
        
        do {
            // 3. Відправляємо дані на сервер та чекаємо на відповідь (upload)
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // Якщо код 404, 405 або 500 — ми відразу викидаємо помилку, що сервер впав
                throw CheckoutError.serverError
            }
            
            // 4. Пробуємо розшифрувати те, що прислав сервер, назад у наш тип Order
            guard let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
                throw CheckoutError.invalidResponse
            }
            
            // 5. Формуємо успішне повідомлення для користувача
            alertTitle = "Thank you!"
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
        } catch {
            // Challenge 2 - Day 52
            showErrorMessage(error.localizedDescription)
        }
    }
    
    func showErrorMessage(_ message: String) {
        alertTitle = "Oops!"
        confirmationMessage = message
        showingConfirmation = true
    }
}

#Preview {
    CheckoutView(order: Order())
}
