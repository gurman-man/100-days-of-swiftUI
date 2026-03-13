//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by mac on 13.03.2026.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
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
        
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    
    // Основна функція для відправки замовлення
    func placeOrder() async {
        // 1. Конвертуємо наш об'єкт order у формат JSON
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        // 2. Налаштовуємо URL та запит
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST" // використовується для відправки даних
        
        do {
            // 3. Відправляємо дані на сервер та чекаємо на відповідь (upload)
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // Додай це, щоб побачити, ЩО саме прислав сервер
            if let stringData = String(data: data, encoding: .utf8) {
                print("Server response: \(stringData)")
            }
            
            // 4. Пробуємо розшифрувати те, що прислав сервер, назад у наш тип Order
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            // 5. Формуємо успішне повідомлення для користувача
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
        } catch {
            // Якщо інтернет зник або сервер лежить — виводимо помилку
            print("Checkout failed: \(error.localizedDescription)")
            confirmationMessage = "Checkout failed: \(error.localizedDescription)"
            showingConfirmation = true
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
