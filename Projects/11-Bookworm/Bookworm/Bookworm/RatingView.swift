//
//  RatingView.swift
//  Bookworm
//
//  Created by mac on 19.03.2026.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            // Якщо maximumRating = 5, то діапазон 1..<6 (тобто числа 1, 2, 3, 4, 5)
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Button {
                    // При натисканні на кнопку рейтинг стає рівним номеру цієї зірочки
                    rating = number
                } label: {
                    // Викликаємо функцію, яка малює іконку (заповнену або порожню)
                    image(for: number)
                        // Якщо номер зірочки більший за поточний рейтинг — вона "вимкнена" (сіра)
                        // Якщо менший або дорівнює — "увімкнена" (жовта)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
            .buttonStyle(.plain) // обробляє кожну кнопку окремо
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
