//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by mac on 17.02.2026.
//

import Foundation

extension Bundle {
    
    // Створення універсального Generic, який повертає будь-який тип
    func decode<T: Codable>(_ file: String) -> T {
        
        // 1. Пошук файлу: перевіряємо, чи існує файл із такою назвою в проекті
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        // 2. Завантаження даних: намагаємося зчитати вміст файлу в пам'ять (Data)
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        // 3. Налаштування декодера
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        // Вказуємо формат дати, який використовується в нашому JSON
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        // 4. Декодування: намагаємося перетворити JSON на об'єкти Swift
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' - \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON: \(context.debugDescription).")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
